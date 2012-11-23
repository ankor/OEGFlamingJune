//
//  OEGObjectRepository.m
//  OEGFlamingJune
//
//  Created by Anders Carlsson on 11/23/12.
//  Copyright (c) 2012‚ Önders et Gonas. All rights reserved.
//

#import "OEGObjectRepository.h"
#import "OEGModel.h"

@implementation OEGObjectRepository {
  NSMutableDictionary *loadedObjects;
}

+ (OEGObjectRepository *)sharedRepository {
  static OEGObjectRepository *_sharedRepository = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedRepository = [[OEGObjectRepository alloc] init];
  });

  return _sharedRepository;
}

- (id)init {
  if (self = [super init]) {
    loadedObjects = [NSMutableDictionary dictionary];
  }
  return self;
}


#pragma mark - Accessing and storing objects

- (OEGModel *)objectForClass:(Class)klass withId:(NSString *)theId {
  NSString *realId = [NSString stringWithFormat:@"%@", theId];
  return [loadedObjects objectForKey:[self.class identityCacheKeyForClass:klass withId:realId]];
}

- (void)storeObject:(OEGModel *)object {
  [loadedObjects setObject:object forKey:[self.class identityCacheKeyForClass:[object class] withId:object.modelId]];
}

- (NSUInteger)count {
  return [loadedObjects count];
}


#pragma mark - Persisting the repository to disk

- (void)clean {
  loadedObjects = [NSMutableDictionary dictionary];
}

- (void)loadCached {
  NSData *data = [NSData dataWithContentsOfFile:[self.class storePath]];
  if (!data) {
    return;
  }

  NSDictionary *allObjects = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

  loadedObjects = [NSMutableDictionary dictionaryWithCapacity:[allObjects count]];
  [allObjects enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    NSString *modelName = [key componentsSeparatedByString:@"-"][0];
    Class modelType = NSClassFromString(modelName);
    [loadedObjects setObject:[modelType findOrInitialize:obj] forKey:key];
  }];
}

- (void)saveToCache {
  NSMutableDictionary *allObjects = [NSMutableDictionary dictionaryWithCapacity:[loadedObjects count]];
  [loadedObjects enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    [allObjects setObject:[obj dictionaryRepresentation] forKey:key];
  }];

  if ([allObjects count]) {
    NSData *data = [NSJSONSerialization dataWithJSONObject:allObjects options:0 error:nil];
    [data writeToFile:[self.class storePath] atomically:YES];
  }
}


#pragma mark - Private

+ (NSString *)storePath {
  NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  [[NSFileManager defaultManager] createDirectoryAtPath:applicationDocumentsDir withIntermediateDirectories:YES attributes:nil error:nil];
  return [applicationDocumentsDir stringByAppendingPathComponent:@"OEGObjectRepository.cache"];
}

+ (NSString *)identityCacheKeyForClass:(Class)klass withId:(NSString *)theId {
  return [NSString stringWithFormat:@"%@-%@", NSStringFromClass([klass class]), theId];
}

@end
