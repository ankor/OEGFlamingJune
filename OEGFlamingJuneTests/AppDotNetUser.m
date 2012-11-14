//
//  AppDotNetUser.m
//  OEGFlamingJune
//
//  Created by Anders Carlsson on 11/13/12.
//  Copyright (c) 2012 Önders et Gonas. All rights reserved.
//

#import <AFNetworking.h>
#import "AppDotNetUser.h"
#import "OEGModel+Private.h"
#import "AFAppDotNetAPIClient.h"


@implementation AppDotNetUser

+ (NSDictionary *)propertyMapping {
  return @{
    @"username" : @"username",
    @"name": @"name",
    @"type": @"type",
    @"avatar": @"avatar_image"
  };
}

+ (NSString *)arrayRootKey {
  return @"data";
}

+ (AFHTTPClient *)httpClient {
  return [AFAppDotNetAPIClient sharedClient];
}

@end
