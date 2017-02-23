//  AnchorListRequestParameter.h
//
//  Created by CodeMan on 2017-02-22
//  Copyright 2012 theotino. All rights reserved.

#import "TNParametersModel.h"

@interface AnchorListRequestParameter : TNParametersModel

@property (nonatomic, retain) NSString *lastupdate;
@property (nonatomic, retain) NSString *client_time;
@property (nonatomic, retain) NSString *user_token;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *page;

@end
