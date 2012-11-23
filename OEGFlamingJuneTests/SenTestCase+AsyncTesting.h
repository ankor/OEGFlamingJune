//
//  SenTestCase+AsyncTesting.h
//  OEGFlamingJune
//
//  Created by Anders Carlsson on 11/23/12.
//  Copyright (c) 2012 Önders et Gonas. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface SenTestCase (AsyncTesting)

- (void)runAsyncAndWait:(void (^)(dispatch_semaphore_t semaphore))block;

@end
