//  Live_member_info.m
//
//  Created by CodeMan on 2017-02-22
//  Copyright 2012 theotino. All rights reserved.

#import "Live_member_info.h"

@implementation Live_member_info

@synthesize member_total_charm;
@synthesize member_online;
@synthesize member_type;
@synthesize member_charm;
@synthesize member_isnew;
@synthesize live_month_time;
@synthesize fans_number;
@synthesize member_rmb;
@synthesize member_city;
@synthesize is_operator;
@synthesize member_level;
@synthesize live_total_time;
@synthesize member_honor;
@synthesize member_sign;
@synthesize basic_info;
@synthesize member_lucky_key;
@synthesize follower_number;
@synthesize member_withdraw_rmb;
@synthesize is_follower;
@synthesize member_gold;
@synthesize member_birth;
@synthesize member_id;
@synthesize is_fans;
@synthesize bind_mobilephone;

- (void)dealloc {
  self.member_city = nil;
  self.member_sign = nil;
  self.basic_info = nil;
  self.member_birth = nil;
  [super dealloc];
}

@end
