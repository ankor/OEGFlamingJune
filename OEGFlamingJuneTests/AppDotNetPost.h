//
//  AppDotNetPost.h
//  OEGFlamingJune
//
//  Created by Anders Carlsson on 11/13/12.
//  Copyright (c) 2012 Önders et Gonas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OEGModel.h"

@class AppDotNetUser;

@interface AppDotNetPost : OEGModel

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *html;
@property (nonatomic, strong) AppDotNetUser *user;
@property (nonatomic, strong) NSNumber *numReplies;
@property (nonatomic, strong) NSNumber *numReposts;
@property (nonatomic, strong) NSNumber *numStars;

+ (void)globalTimeline:(OEGCallbackBlock)block;
+ (void)globalTimeline:(OEGCallbackBlock)block originalData:(OEGRawCallbackBlock)originalData;
+ (void)globalTimelineWithResponseCache:(OEGCallbackBlock)block;
+ (void)globalTimelineWithResponseCacheSpecificCallback:(OEGCallbackBlock)block;

@end
