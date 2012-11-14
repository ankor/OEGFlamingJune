//
//  OEGModel.h
//  OEGFlamingJune
//
//  Created by Anders Carlsson on 2012-09-16.
//  Copyright (c) 2012 Önders et Gonas. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CallbackBlock)(id responseData, NSError *error);

@interface OEGModel : NSObject

+ (void)requestMethod:(NSString *)method path:(NSString *)path params:(NSDictionary *)params inBackground:(CallbackBlock)block;
+ (void)requestMethod:(NSString *)method path:(NSString *)path params:(NSDictionary *)params inBackground:(CallbackBlock)block originalData:(CallbackBlock)originalBlock;

+ (id)findOrInitialize:(NSDictionary *)dict;
- (id)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic, strong) NSString *modelId;

@end
