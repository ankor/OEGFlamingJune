# OEGFlamingJune

Flaming June is a simple model superclass for interacting with a REST service using [AFNetworking](https://github.com/AFNetworking/AFNetworking). It also has an object identity map built in.

For now it assumes that all data is JSON and all model instances have unique ID's.

Flaming June uses [CocoaPods](http://cocoapods.org/) for dependency management.


## Usage

Let your models inherit from OEGModel like so:


### Header

    #import "OEGModel.h"

    @class AppDotNetUser;

    @interface AppDotNetPost : OEGModel

    @property (nonatomic, strong) NSDate *createdAt;
    @property (nonatomic, strong) NSString *text;
    @property (nonatomic, strong) AppDotNetUser *user;

    + (void)globalTimeline:(CallbackBlock)block;


### Implementation

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

The `globalTimeline:` method will call the callback block with an NSArray of AppDotNetPost objects or an NSError in case of error.

The `arrayRootKey` method is used because the App.net API wraps the response array in a JSON object with the key "data".

Because the "user" property is defined as an AppDotNetUser, which also is a subclass of OEGModel, it will be populated using that class's propertyMapping. If several posts share the same user (same ID), they will be associated with the same in-memory object.

If a property defined as an OEGModel subclass has a non-dictionary value in the response JSON, that value will be assumed to be the ID of the object. If the object was previously loaded through some earlier request, it will be associated correctly.

The `AFAppDotNetAPIClient` class is borrowed from [AFNetworking's example project](https://github.com/AFNetworking/AFNetworking/tree/master/Example/Classes). Any AFHTTPClient subclass will do.


## Testing

To run the tests, [NSURLConnectionVCR](https://bitbucket.org/andersc/nsurlconnectionvcr) is needed. It is included as a CocoaPod dependency.


## The name

[Flaming June](http://en.wikipedia.org/wiki/Flaming_June) is a painting by Sir Frederic Leighton of a resting model. It also matches AFNetworking's fiery theme.


## Other stuff

None! This project contains no implementations of `map` for NSArray, perhaps as the only open source Objective-C library in history.
