//
//  AppDotNetPost.m
//  OEGFlamingJune
//
//  Created by Anders Carlsson on 11/13/12.
//  Copyright (c) 2012 Önders et Gonas. All rights reserved.
//

#import <AFNetworking.h>
#import "AppDotNetPost.h"
#import "AFAppDotNetAPIClient.h"
#import "OEGModel+Private.h"

@implementation AppDotNetPost

+ (NSDictionary *)propertyMapping {
  return @{
    @"createdAt" : @"created_at",
    @"text": @"text",
    @"html": @"html",
    @"user": @"user",
    @"numReplies": @"num_replies",
    @"numReposts": @"num_reposts",
    @"numStars": @"num_stars"
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

+ (void)globalTimeline:(CallbackBlock)block originalData:(OriginalCallbackBlock)originalData {
  NSDictionary *options = @{
    OEGFlamingJuneOriginalDataCallbackKey: originalData
  };

  [self requestMethod:@"get" path:@"stream/0/posts/stream/global" params:nil inBackground:block options:options];
}

@end
