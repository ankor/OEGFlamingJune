//
//  OEGModelTests.m
//  OEGFlamingJune
//
//  Created by Anders Carlsson on 11/13/12.
//  Copyright (c) 2012 Önders et Gonas. All rights reserved.
//

#import <NSURLConnectionVCR.h>
#import "OEGModelTests.h"
#import "SenTestCase+AsyncTesting.h"

#import "AppDotNetPost.h"
#import "AppDotNetUser.h"

#import "TransformingModel.h"

#define QUOTE(str) #str
#define EXPAND_AND_QUOTE(str) QUOTE(str)

@implementation OEGModelTests

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


#pragma mark - Tests

- (void)testFetchesGlobalTimeline {
  [self runAsyncAndWait:^(dispatch_semaphore_t semaphore) {
    [AppDotNetPost globalTimeline:^(NSArray *posts, NSError *error) {
      STAssertNil(error, nil);
      STAssertEquals([posts count], 20U, nil);
      STAssertTrue([posts[0] isKindOfClass:[AppDotNetPost class]], nil);
      dispatch_semaphore_signal(semaphore);
    }];
  }];
}

- (void)testFillsProperties {
  [self runAsyncAndWait:^(dispatch_semaphore_t semaphore) {
    [AppDotNetPost globalTimeline:^(NSArray *posts, NSError *error) {
      STAssertNil(error, nil);
      AppDotNetPost *post = posts[0];

      STAssertEqualObjects(post.createdAt, [NSDate dateWithTimeIntervalSince1970:1352813496], nil);
      STAssertEqualObjects(post.text, @"@kalupa IDEAR", nil);
      STAssertTrue([post.user isKindOfClass:[AppDotNetUser class]], nil);
      STAssertEqualObjects(post.user.name, @"Edna Piranha", nil);
      dispatch_semaphore_signal(semaphore);
    }];
  }];
}

- (void)testUserWithSameIdIsTheSameObject {
  [self runAsyncAndWait:^(dispatch_semaphore_t semaphore) {
    [AppDotNetPost globalTimeline:^(NSArray *posts, NSError *error) {
      STAssertNil(error, nil);
      AppDotNetUser *jasonSmith = ((AppDotNetPost *)posts[3]).user;
      AppDotNetUser *jasonSmith2 = ((AppDotNetPost *)posts[13]).user;

      STAssertEqualObjects(jasonSmith.name, @"Jason Smith", nil);
      STAssertEquals(jasonSmith, jasonSmith2, nil);
      dispatch_semaphore_signal(semaphore);
    }];
  }];
}

- (void)testPropertyValueTransformer {
  NSDictionary *sourceDict = @{
    @"plaintext_string" : @"Dammit i'm mad!",
    @"url": @"http://www.example.com/awesomeness"
  };

  TransformingModel *model = [TransformingModel findOrInitialize:sourceDict];

  STAssertEqualObjects(model.secretString, @"!dam m'i timmaD", nil);
  STAssertEquals([model.aURL class], [NSURL class], nil);
  STAssertEqualObjects(model.aURL, [NSURL URLWithString:@"http://www.example.com/awesomeness"], nil);

  // Transform it back again
  NSDictionary *targetDict = [model dictionaryRepresentation];

  STAssertEqualObjects([targetDict objectForKey:@"plaintext_string"], @"Dammit i'm mad!", nil);
  STAssertEqualObjects([targetDict objectForKey:@"url"], @"http://www.example.com/awesomeness", nil);
}

@end
