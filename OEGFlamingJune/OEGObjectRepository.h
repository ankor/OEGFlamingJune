//
//  OEGObjectRepository.h
//  OEGFlamingJune
//
//  Created by Anders Carlsson on 11/23/12.
//  Copyright (c) 2012‚ Önders et Gonas. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OEGModel;

@interface OEGObjectRepository : NSObject

+ (OEGObjectRepository *)sharedRepository;

- (OEGModel *)objectForClass:(Class)klass withId:(NSString *)theId;
- (void)storeObject:(OEGModel *)object;

@end
