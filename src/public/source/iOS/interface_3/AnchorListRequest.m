#import "AnchorListRequest.h"

@implementation AnchorListRequest

- (id)initWithParam:(AnchorListRequestParameter*)param {
  self = [super init];

  if (nil != self) {
      self.param = param;
  }

  return self;
}

- (NSString *)requestUrl {
    return @"/ClientApi/user_login";
}

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodGET;
    
}

@end
