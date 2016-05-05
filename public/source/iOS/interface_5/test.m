//  test.m
//
//  Created by CodeMan on 2016-05-05
//  Copyright 2012 theotino. All rights reserved.

#import "test.h"

@implementation test

@synthesize parameters;
@synthesize version;
@synthesize device_udid;
@synthesize lang;
@synthesize code;
@synthesize time;
@synthesize source;
@synthesize value;

- (id)init {
  self = [super init];
  if (nil != self) {
    self.path = @"http://client.f3322.net:100/client/api";
    self.method = @"GET";
    self.httpClientName = @"default";
    self.parameters = [[[testParameter alloc] init] autorelease];
    self.parameters.test = @"test";
    self.needSignatureRequest = YES;
  }

  return self;
}

- (void)dealloc {
  self.parameters = nil;
  self.version = nil;
  self.device_udid = nil;
  self.lang = nil;
  self.time = nil;
  self.source = nil;
  [super dealloc];
}

- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock {

  [self getDataWithParameters:self.parameters completionBlock:completionBlock failedBlock:failedBlock];
}

- (void)parseData:(NSDictionary *)data {
  NSDictionary *map = [NSDictionary dictionaryWithObjectsAndKeys:
                                    nil];

  [self setModelFromDictionary:data keyMap:map];
}

@end
