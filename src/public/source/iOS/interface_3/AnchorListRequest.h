/*
 * @brief:  主播列表
 * @author: APIEASY
 * @date:   2017-02-22
 */

#import <Foundation/Foundation.h>
#import "XQRequest.h"
#import "AnchorListRequestParameter.h"

@interface AnchorListRequest : XQRequest

- (id)initWithParam:(AnchorListRequestParameter*)param;

@property (nonatomic, strong) AnchorListRequestParameter* param;

@end
