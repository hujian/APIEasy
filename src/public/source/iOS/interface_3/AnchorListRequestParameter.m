//  AnchorListRequestParameter.m
//
//  Created by CodeMan on 2017-02-22
//  Copyright 2012 theotino. All rights reserved.

#import "AnchorListRequestParameter.h"

@implementation AnchorListRequestParameter

@synthesize lastupdate;
@synthesize client_time;
@synthesize user_token;
@synthesize type;
@synthesize page;

- (void)dealloc {
    self.lastupdate = nil;
    self.client_time = nil;
    self.user_token = nil;
    self.type = nil;
    self.page = nil;
    [super dealloc];
}

@end