//
//  OEGModel+Private.h
//  OEGFlamingJune
//
//  Created by Anders Carlsson on 11/13/12.
//  Copyright (c) 2012 Önders et Gonas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OEGModel.h"

@class AFHTTPClient;

@interface OEGModel ()

+ (AFHTTPClient *)httpClient;
+ (NSDictionary *)propertyMapping;
+ (NSString *)arrayRootKey;
+ (NSString *)dictionaryRootKey;

+ (Class)typeForPropertyName:(NSString *)propertyAccessor;
+ (NSString *)identityCacheKey:(NSString *)theId;
- (void)updateAttributes:(NSDictionary *)dict;

@end
