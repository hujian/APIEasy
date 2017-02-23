//  Value.h
//
//  Created by CodeMan on 2017-02-22
//  Copyright 2012 theotino. All rights reserved.

#import "TNDataModel.h"
#import "Live_member_info.h"

@interface Value: TNDataModel

@property (nonatomic, assign) int is_follow;
@property (nonatomic, retain) Live_member_info* live_member_info;
@property (nonatomic, assign) int live_pk_game;
@property (nonatomic, retain) NSString* live_contents;
@property (nonatomic, retain) NSString* live_sfs_port;
@property (nonatomic, assign) int live_start_time;
@property (nonatomic, assign) int live_id;
@property (nonatomic, assign) int live_view_count;
@property (nonatomic, retain) NSString* live_cover;
@property (nonatomic, retain) NSString* rtmp_url;
@property (nonatomic, retain) NSString* room_name;
@property (nonatomic, retain) NSString* live_sfs_url;
@property (nonatomic, assign) int live_status;
@property (nonatomic, assign) int live_game;

@end