//
//  OEGAssociationTransformer.h
//  OEGFlamingJune
//
//  Created by Anders Carlsson on 12/4/12.
//  Copyright (c) 2012 Önders et Gonas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OEGAssociationTransformer : NSValueTransformer

+ (OEGAssociationTransformer *)associationTransformerForModelClass:(Class)modelClass;

@property (nonatomic, strong) Class propertyType;

@end
