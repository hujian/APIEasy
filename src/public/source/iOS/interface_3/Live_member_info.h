//  Live_member_info.h
//
//  Created by CodeMan on 2017-02-22
//  Copyright 2012 theotino. All rights reserved.

#import "TNDataModel.h"
#import "Basic_info.h"

@interface Live_member_info: TNDataModel

@property (nonatomic, assign) int member_total_charm;
@property (nonatomic, assign) BOOL member_online;
@property (nonatomic, assign) int member_type;
@property (nonatomic, assign) int member_charm;
@property (nonatomic, assign) BOOL member_isnew;
@property (nonatomic, assign) int live_month_time;
@property (nonatomic, assign) int fans_number;
@property (nonatomic, assign) float member_rmb;
@property (nonatomic, retain) NSString* member_city;
@property (nonatomic, assign) BOOL is_operator;
@property (nonatomic, assign) int member_level;
@property (nonatomic, assign) int live_total_time;
@property (nonatomic, assign) int member_honor;
@property (nonatomic, retain) NSString* member_sign;
@property (nonatomic, retain) Basic_info* basic_info;
@property (nonatomic, assign) int member_lucky_key;
@property (nonatomic, assign) int follower_number;
@property (nonatomic, assign) float member_withdraw_rmb;
@property (nonatomic, assign) BOOL is_follower;
@property (nonatomic, assign) int member_gold;
@property (nonatomic, retain) NSString* member_birth;
@property (nonatomic, assign) int member_id;
@property (nonatomic, assign) BOOL is_fans;
@property (nonatomic, assign) BOOL bind_mobilephone;

@end