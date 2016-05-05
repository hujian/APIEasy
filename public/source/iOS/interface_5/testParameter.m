//  testParameter.m
//
//  Created by CodeMan on 2016-05-05
//  Copyright 2012 theotino. All rights reserved.

#import "testParameter.h"

@implementation testParameter

@synthesize test;

- (void)dealloc {
    self.test = nil;
    [super dealloc];
}

@end