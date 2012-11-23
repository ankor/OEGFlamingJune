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


#pragma mark - Private

+ (NSString *)identityCacheKeyForClass:(Class)klass withId:(NSString *)theId {
  return [NSString stringWithFormat:@"%@-%@", NSStringFromClass([klass class]), theId];
}

@end
