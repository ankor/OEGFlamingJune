//
//  TransformingModel.h
//  OEGFlamingJune
//
//  Created by Anders Carlsson on 11/23/12.
//  Copyright (c) 2012‚ Önders et Gonas. All rights reserved.
//

#import "OEGModel.h"

@interface TransformingModel : OEGModel

@property (nonatomic, strong) NSString *secretString;
@property (nonatomic, strong) NSURL *aURL;
@property (nonatomic, assign, getter = isAwesome) BOOL awesome;
@property (nonatomic, strong) NSMutableArray *tags;

@end
