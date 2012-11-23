//
//  OEGJSONDateTransformer.m
//  OEGFlamingJune
//
//  Created by Anders Carlsson on 11/23/12.
//  Copyright (c) 2012 Önders et Gonas. All rights reserved.
//

#import "OEGJSONDateTransformer.h"

static NSDateFormatter *dateFormatter;

@implementation OEGJSONDateTransformer

+ (void)initialize {
  dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
  dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
  dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
}

+ (Class)transformedValueClass {
  return [NSObject class];
}

+ (BOOL)allowsReverseTransformation {
  return YES;
}

- (id)transformedValue:(id)value {
  return [dateFormatter dateFromString:value];
}

- (id)reverseTransformedValue:(id)value {
  return [dateFormatter stringFromDate:value];
}

@end
