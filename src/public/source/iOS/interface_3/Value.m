//  Value.m
//
//  Created by CodeMan on 2017-02-22
//  Copyright 2012 theotino. All rights reserved.

#import "Value.h"

@implementation Value

@synthesize is_follow;
@synthesize live_member_info;
@synthesize live_pk_game;
@synthesize live_contents;
@synthesize live_sfs_port;
@synthesize live_start_time;
@synthesize live_id;
@synthesize live_view_count;
@synthesize live_cover;
@synthesize rtmp_url;
@synthesize room_name;
@synthesize live_sfs_url;
@synthesize live_status;
@synthesize live_game;

- (void)dealloc {
  self.live_member_info = nil;
  self.live_contents = nil;
  self.live_sfs_port = nil;
  self.live_cover = nil;
  self.rtmp_url = nil;
  self.room_name = nil;
  self.live_sfs_url = nil;
  [super dealloc];
}

@end
