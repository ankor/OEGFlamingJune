//
//  OEGModel.h
//  OEGFlamingJune
//
//  Created by Anders Carlsson on 2012-09-16.
//  Copyright (c) 2012 Önders et Gonas. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;

typedef void(^CallbackBlock)(id responseData, NSError *error);
typedef void(^OriginalCallbackBlock)(AFHTTPRequestOperation *operation, id responseData, NSError *error);

#define OEGFlamingJuneOriginalDataCallbackKey @"OEGFlamingJuneOriginalDataCallbackKey"
#define OEGFlamingJuneForceCacheKey @"OEGFlamingJuneForceCacheKey"

@interface OEGModel : NSObject

+ (void)requestMethod:(NSString *)method path:(NSString *)path params:(NSDictionary *)params inBackground:(CallbackBlock)block;
+ (void)requestMethod:(NSString *)method path:(NSString *)path params:(NSDictionary *)params inBackground:(CallbackBlock)block options:(NSDictionary *)options;

+ (id)findOrInitialize:(NSDictionary *)dict;
- (id)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic, strong) NSString *modelId;

- (NSDictionary *)dictionaryRepresentation;

+ (void)clearResponseCache;

@end
