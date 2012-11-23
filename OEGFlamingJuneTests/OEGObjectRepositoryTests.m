//
//  OEGObjectRepositoryTests.m
//  OEGFlamingJune
//
//  Created by Anders Carlsson on 11/23/12.
//  Copyright (c) 2012, Önders et Gonas. All rights reserved.
//

#import <NSURLConnectionVCR.h>
#import "OEGObjectRepositoryTests.h"
#import "SenTestCase+AsyncTesting.h"
#import "OEGObjectRepository.h"

#import "AppDotNetPost.h"

#define QUOTE(str) #str
#define EXPAND_AND_QUOTE(str) QUOTE(str)

@implementation OEGObjectRepositoryTests

- (void)setUp {
  [super setUp];
  NSString *srcroot = [NSString stringWithFormat:@"%s", EXPAND_AND_QUOTE(SRCROOT)];
  NSString *tapesPath = [srcroot stringByAppendingPathComponent:@"OEGFlamingJuneTests/VCRTapes"];
  [NSURLConnectionVCR startVCRWithPath:tapesPath error:nil];
}

- (void)tearDown {
  [super tearDown];
  [NSURLConnectionVCR stopVCRWithError:nil];
}

- (void)testSavingAndLoadingEmptyObjectRepository {
  OEGObjectRepository *or = [OEGObjectRepository sharedRepository];
  [or clean];

  STAssertNoThrow([or saveToCache], nil);
  STAssertNoThrow([or loadCached], nil);
}

- (void)testSavingAndLoadingObjectRepository {
  OEGObjectRepository *or = [OEGObjectRepository sharedRepository];
  [or clean];

  [self runAsyncAndWait:^(dispatch_semaphore_t semaphore) {
    [AppDotNetPost globalTimeline:^(NSArray *posts, NSError *error) {
      STAssertNil(error, nil);
      STAssertEquals([or count], 39U, nil);   // Posts + users
      STAssertNoThrow([or saveToCache], nil);

      [or clean];
      STAssertNoThrow([or loadCached], nil);
      STAssertEquals([or count], 39U, nil);

      dispatch_semaphore_signal(semaphore);
    }];
  }];
}

@end
