# OEGFlamingJune

Flaming June is a simple model superclass for interacting with a REST service using [AFNetworking](https://github.com/AFNetworking/AFNetworking). It also has an object identity map built in (if objects have unique ID's). The cached objects in the identity map can be persisted to disk as an offline cache.

It accesses the REST service through any subclass of `AFHTTPClient`.

Flaming June uses [CocoaPods](http://cocoapods.org/) for dependency management.


## Usage

Let your models inherit from `OEGModel` like so:


### Header

```objective-c
#import "OEGModel.h"

@class AppDotNetUser;

@interface AppDotNetPost : OEGModel

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) AppDotNetUser *user;

+ (void)globalTimeline:(CallbackBlock)block;
```

### Implementation

```objective-c
#import <AFNetworking.h>
#import "AppDotNetPost.h"
#import "AFAppDotNetAPIClient.h"
#import "OEGModel+Private.h"

@implementation AppDotNetPost

+ (NSDictionary *)propertyMapping {
  return @{
    @"createdAt" : @"created_at",
    @"text": @"text",
    @"user": @"user"
  };
}

+ (NSString *)arrayRootKey {
  return @"data";
}

+ (AFHTTPClient *)httpClient {
  return [AFAppDotNetAPIClient sharedClient];
}


#pragma mark - Finding posts

+ (void)globalTimeline:(CallbackBlock)block {
  [self requestMethod:@"get" path:@"stream/0/posts/stream/global" params:nil inBackground:block];
}

@end
```

The `globalTimeline:` method will call the callback block with an `NSArray` of `AppDotNetPost` objects or an `NSError` in case of error.

The `arrayRootKey` method is used because the App.net API wraps the response array in a JSON object with the key `data`.

Because the `user` property is defined as an `AppDotNetUser`, which also is a subclass of `OEGModel`, it will be populated using that class's `propertyMapping`. If several posts share the same user (same ID), they will be associated with the same in-memory object.

If a property defined as an `OEGModel` subclass has a non-dictionary value in the response JSON, that value will be assumed to be the ID of the object. If the object was previously loaded through some earlier request, it will be associated correctly.

The `AFAppDotNetAPIClient` class is borrowed from [AFNetworking's example project](https://github.com/AFNetworking/AFNetworking/tree/master/Example/Classes). Any `AFHTTPClient` subclass will do.


## Transformations

Any property can have an associated [NSValueTransformer](http://nshipster.com/nsvaluetransformer/) for transforming a value in the web service response to a property. Is useful e.g. if the property is declared as an `NSURL` but the value from the service is interpreted as a string.

To attach an `NSValueTranformer` to a property, just implement a method on your `OEGModel` subclass `- (NSValueTransformer *)<propertyName>Transformer`. For a nice way to create new NSValueTransformers, check out [TransformerKit](https://github.com/mattt/TransformerKit).

A few property transformations are automatically handled:

- If the property is defined as an `NSDate`, the mapped response value is assumed to be a standard JSON date formatted string if no special transformer is defined.
- If the property is defined as an `NSArray`, `NSSet`, or any subclass (e.g. a `NSMutableArray`) and the value returned from the service is a regular array it will automatically be converted.
- If the property is a primitive type like a BOOL or an int, the value is transformed from its `NSNumber` wrapped counterpart automatically since the underlying implementation uses key-value coding.


## Associations

If your model has an `NSArray` or `NSSet` property and the web service responds with an array of dictionaries which should be interpreted as `OEGModel` objects, Flaming June supplies a special `NSValueTransformer` subclass called `OEGAssociationTransformer`.

Let's say you have an `OEGModel` subclass that has a property of type `NSArray` called `children`. This property should be initialised with an array of objects with the class `ChildObject` and the web service responds with a number of dictionaries representing these objects, implement this behaviour like this:

```objective-c
- (NSValueTransformer *)childrenTransformer {
  return [OEGAssociationTransformer associationTransformerForModelClass:[ChildObject class])];
}
```

The web service can also respond with an array of numerical ID's and the `children` array will be initialised with the correct `ChildObject` objects, as long as the objects were stored in the Object Repository at the time of initialisation.


## Persisting the Object Repository

The identity mapped local cache of objects are handled by the `OEGObjectRepository`. This class has some methods for persisting and loading the objects for offline caching purposes. To e.g. save the Object Repository when the app terminates, call:

```objective-c
[[OEGObjectRepository sharedRepository] saveToCache];
```

To load it again when the app boots:

```objective-c
[[OEGObjectRepository sharedRepository] loadCached];
```

There is also a method `- (void)clean` to empty the object repository, and `- (NSUInteger)count` to count the number of objects in it.


## Testing

To run the tests, [NSURLConnectionVCR](https://bitbucket.org/andersc/nsurlconnectionvcr) and [TransformerKit](https://github.com/mattt/TransformerKit) are needed. They are included as CocoaPod dependencies.


## The name

[Flaming June](http://en.wikipedia.org/wiki/Flaming_June) is a painting by Sir Frederic Leighton of a resting model. It also matches AFNetworking's fiery theme.
