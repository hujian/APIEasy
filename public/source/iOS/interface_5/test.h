//  test.h
//
//  Created by CodeMan on 2016-05-05
//  Copyright 2012 theotino. All rights reserved.

#import "TNHttpModel.h"

#import "testParameter.h"

@interface test : TNHttpModel

/*
* 接口传入参数
*/
@property (nonatomic, retain) testParameter* parameters;

/*
* 返回结果集
*/
@property (nonatomic, retain) NSString* version;
@property (nonatomic, retain) NSString* device_udid;
@property (nonatomic, retain) NSString* lang;
@property (nonatomic, assign) int code;
@property (nonatomic, retain) NSString* time;
@property (nonatomic, retain) NSString* source;
@property (nonatomic, )  value;

/*
* @brief 获取model数据
*
* @param completionBlock 获取成功后回调的block
*
* @param failedBlock 失败后回调的block, 返回NSError。注意无数据也返回错误(no data).
*
*/
- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;

@end