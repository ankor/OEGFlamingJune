//
//  TransformingModel.m
//  OEGFlamingJune
//
//  Created by Anders Carlsson on 11/23/12.
//  Copyright (c) 2012‚ Önders et Gonas. All rights reserved.
//

#import <TransformerKit.h>
#import <TransformerKit/NSValueTransformer+TransformerKit.h>
#import "TransformingModel.h"
#import "OEGModel+Private.h"

@implementation TransformingModel

+ (void)initialize {
  [NSValueTransformer registerValueTransformerWithName:@"OEGURLTransformer" transformedValueClass:[NSObject class] returningTransformedValueWithBlock:^id(id value) {
    return [NSURL URLWithString:value];
  } allowingReverseTransformationWithBlock:^id(id value) {
    return [(NSURL *)value absoluteString];
  }];
}

+ (AFHTTPClient *)httpClient {
  return nil;
}

+ (NSDictionary *)propertyMapping {
  return @{
    @"secretString": @"plaintext_string",
    @"aURL": @"url"
  };
}


#pragma mark - Value transformers

- (NSValueTransformer *)secretStringTransformer {
  return [NSValueTransformer valueTransformerForName:TKReverseStringTransformerName];
}

- (NSValueTransformer *)aURLTransformer {
  return [NSValueTransformer valueTransformerForName:@"OEGURLTransformer"];
}

@end
