//
//  SenTestCase+AsyncTesting.m
//  OEGFlamingJune
//
//  Created by Anders Carlsson on 11/23/12.
//  Copyright (c) 2012 Önders et Gonas. All rights reserved.
//

#import "SenTestCase+AsyncTesting.h"

@implementation SenTestCase (AsyncTesting)

#pragma mark - Convenience

- (void)runAsyncAndWait:(void (^)(dispatch_semaphore_t semaphore))block {
  dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

  block(semaphore);

  while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

@end
