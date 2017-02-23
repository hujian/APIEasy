//  Basic_info.m
//
//  Created by CodeMan on 2017-02-22
//  Copyright 2012 theotino. All rights reserved.

#import "Basic_info.h"

@implementation Basic_info

@synthesize cover;
@synthesize nickname;
@synthesize gender;
@synthesize avstar_small;
@synthesize avstar;

- (void)dealloc {
  self.cover = nil;
  self.nickname = nil;
  self.gender = nil;
  self.avstar_small = nil;
  self.avstar = nil;
  [super dealloc];
}

@end
