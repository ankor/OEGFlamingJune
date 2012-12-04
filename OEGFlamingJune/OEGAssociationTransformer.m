//
//  OEGAssociationTransformer.m
//  OEGFlamingJune
//
//  Created by Anders Carlsson on 12/4/12.
//  Copyright (c) 2012 Önders et Gonas. All rights reserved.
//

#import "OEGAssociationTransformer.h"
#import "OEGModel.h"

@interface OEGAssociationTransformer ()

@property (nonatomic, strong) Class modelClass;

@end


@implementation OEGAssociationTransformer

+ (OEGAssociationTransformer *)associationTransformerForModelClass:(Class)modelClass {
  OEGAssociationTransformer *transformer = [[OEGAssociationTransformer alloc] init];
  transformer.modelClass = modelClass;

  return transformer;
}

+ (Class)transformedValueClass {
  return [NSObject class];
}

+ (BOOL)allowsReverseTransformation {
  return YES;
}

- (id)transformedValue:(id)value {
  NSArray *dictArray = (NSArray *)value;

  NSMutableArray *associationObjects = [NSMutableArray arrayWithCapacity:[dictArray count]];
  for (NSDictionary *associationDict in dictArray) {
    id associationObject;
    if ([associationDict isKindOfClass:[NSDictionary class]]) {
      associationObject = [self.modelClass findOrInitialize:associationDict];
    } else {
      associationObject = [self.modelClass findOrInitialize:[NSDictionary dictionaryWithObject:associationDict forKey:@"id"]];
    }
    [associationObjects addObject:associationObject];
  }
  return [[self.propertyType alloc] initWithArray:associationObjects];
}

- (id)reverseTransformedValue:(id)value {
  NSMutableArray *dictArray = [NSMutableArray arrayWithCapacity:[value count]];
  for (OEGModel *model in value) {
    [dictArray addObject:[model dictionaryRepresentation]];
  }
  return [NSArray arrayWithArray:dictArray];
}

@end
