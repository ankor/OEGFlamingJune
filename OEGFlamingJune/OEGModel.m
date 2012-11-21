//
//  OEGModel.m
//  OEGFlamingJune
//
//  Created by Anders Carlsson on 2012-09-16.
//  Copyright (c) 2012 Önders et Gonas. All rights reserved.
//

#import <objc/runtime.h>
#import <AFNetworking.h>
#import "OEGModel.h"
#import "OEGModel+Private.h"

static NSMutableDictionary *loadedObjects;

@implementation OEGModel

+ (void)initialize {
  if (!loadedObjects) {
    loadedObjects = [NSMutableDictionary dictionary];
  }
}


#pragma mark - Network requests

+ (void)requestMethod:(NSString *)method path:(NSString *)path params:(NSDictionary *)params inBackground:(CallbackBlock)block {
  NSMutableURLRequest *request = [[self httpClient] requestWithMethod:[method uppercaseString] path:path parameters:params];
  AFHTTPRequestOperation *operation = [[self httpClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
    [self handleResponseData:responseObject withBlock:block];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (block != nil) {
      block(nil, error);
    }
  }];

  [[self httpClient] enqueueHTTPRequestOperation:operation];
}

+ (void)requestMethod:(NSString *)method path:(NSString *)path params:(NSDictionary *)params inBackground:(CallbackBlock)block originalData:(CallbackBlock)originalBlock {
  NSMutableURLRequest *request = [[self httpClient] requestWithMethod:[method uppercaseString] path:path parameters:params];
  AFHTTPRequestOperation *operation = [[self httpClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
    [self handleResponseData:responseObject withBlock:block];
    if (originalBlock != nil) {
      originalBlock(responseObject, nil);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (block != nil) {
      block(nil, error);
    }
    if (originalBlock != nil) {
      originalBlock(nil, error);
    }
  }];

  [[self httpClient] enqueueHTTPRequestOperation:operation];
}

+ (NSMutableArray *)parseArray:(NSArray *)array {
  NSMutableArray *objects = [NSMutableArray array];
  for (NSDictionary *dict in array) {
    OEGModel *object = [self findOrInitialize:dict];
    [objects addObject:object];
  }
  return objects;
}

+ (void)handleResponseData:(id)responseObject withBlock:(CallbackBlock)block {
  if ([responseObject isKindOfClass:[NSArray class]]) {
    NSMutableArray *objects = [self parseArray:responseObject];
    if (block != nil) {
      block(objects, nil);
    }
  } else if([responseObject isKindOfClass:[NSDictionary class]]) {
    id objectOrObjects = nil;
    if ([self arrayRootKey] && [responseObject objectForKey:[self arrayRootKey]]) {
      objectOrObjects = [self parseArray:[responseObject objectForKey:[self arrayRootKey]]];
    } else {
      objectOrObjects = [self findOrInitialize:responseObject];
    }
    if (block != nil) {
      block(objectOrObjects, nil);
    }
  } else {
    if (block != nil) {
      block(nil, nil);
    }
  }
}


#pragma mark - Initialization

+ (id)findOrInitialize:(NSDictionary *)dict {
  OEGModel *cachedObject = [loadedObjects objectForKey:[self identityCacheKey:[NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]]]];
  if (cachedObject) {
    [cachedObject updateAttributes:dict];
    return cachedObject;
  }

  return [[self alloc] initWithDictionary:dict];
}

- (id)initWithDictionary:(NSDictionary *)dict {
  if (self = [super init]) {
    self.modelId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
    [self updateAttributes:dict];
    [loadedObjects setObject:self forKey:[[self class] identityCacheKey:self.modelId]];
  }

  return self;
}


#pragma mark - To override

+ (AFHTTPClient *)httpClient {
  return nil;
}

+ (NSDictionary *)propertyMapping {
  // Override to return a mapping from the property names to the parameter name returned from api. E.g:
  // { @"groupId": @"group_id", @"user": @"user" }
  return nil;
}

+ (NSString *)arrayRootKey {
  // Optional. If array is returned wrapped in a dictionary with a root key, return that key here.
  return nil;
}


#pragma mark - Private helpers

+ (Class)typeForPropertyName:(NSString *)propertyAccessor {
  objc_property_t property = class_getProperty([self class], [propertyAccessor UTF8String]);

  const char *attrs = property_getAttributes(property);
  if (attrs == NULL)
    return NULL;

  if (attrs[0] != 'T') {
    return NULL;
  }

  if (attrs[1] == '@') {
    // Object type
    static char buffer[256];
    const char *e = strchr(attrs, ',');
    if (e == NULL)
      return NULL;

    int len = (int)(e - attrs);
    memcpy(buffer, attrs + 3, len - 4);
    buffer[len - 4] = '\0';

    return NSClassFromString([NSString stringWithCString:buffer encoding:NSUTF8StringEncoding]);
  } else {
    // Primitive type
    return [NSNumber class];
  }
}

+ (NSString *)identityCacheKey:(NSString *)theId {
  return [NSString stringWithFormat:@"%@-%@", NSStringFromClass([self class]), theId];
}

- (void)updateAttributes:(NSDictionary *)dict {
  [[[self class] propertyMapping] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    id dictObj = [dict objectForKey:obj];
    if (dictObj) {
      id value;

      // Check the property type to see if it is another model
      Class propertyType = [[self class] typeForPropertyName:key];
      if ([propertyType isSubclassOfClass:[OEGModel class]]) {
        // If the object in the dict is a dictionary, it's a representation of the object. Otherwise it's just the id and we must have it in the object repository already (otherwise we'll get a useless empty object)
        if ([dictObj isKindOfClass:[NSDictionary class]]) {
          value = [propertyType findOrInitialize:dictObj];
        } else {
          value = [propertyType findOrInitialize:[NSDictionary dictionaryWithObject:dictObj forKey:@"id"]];
        }
      } else if ([propertyType isSubclassOfClass:[NSArray class]]) {
        // If this is an 1:n association, populate it with OEGModel objects, otherwise just set the array
        SEL associationCheck = NSSelectorFromString([NSString stringWithFormat:@"associationClassFor_%@", key]);
        if ([self respondsToSelector:associationCheck]) {
          Class modelType = [self performSelector:associationCheck];
          NSMutableArray *associationObjects = [NSMutableArray arrayWithCapacity:[dictObj count]];
          for (NSDictionary *associationDict in dictObj) {
            id associationObject;
            if ([associationDict isKindOfClass:[NSDictionary class]]) {
              associationObject = [modelType findOrInitialize:associationDict];
            } else {
              associationObject = [modelType findOrInitialize:[NSDictionary dictionaryWithObject:associationDict forKey:@"id"]];
            }
            [associationObjects addObject:associationObject];
          }
          value = associationObjects;
        } else {
          value = dictObj;
        }
      } else if ([propertyType isSubclassOfClass:[NSDate class]]) {
        // Parse JSON dates
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        value = [dateFormatter dateFromString:dictObj];
      } else {
        value = dictObj;
      }

      if (value && value != [NSNull null]) {
        [self setValue:value forKey:key];
      }
    }
  }];
}

@end
