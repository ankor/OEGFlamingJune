//
//  TagModel.m
//  OEGFlamingJune
//
//  Created by Anders Carlsson on 12/4/12.
//  Copyright (c) 2012 Önders et Gonas. All rights reserved.
//

#import "TagModel.h"
#import "OEGModel+Private.h"

@implementation TagModel

+ (AFHTTPClient *)httpClient {
  return nil;
}

+ (NSDictionary *)propertyMapping {
  return @{
    @"name": @"name"
  };
}

@end
