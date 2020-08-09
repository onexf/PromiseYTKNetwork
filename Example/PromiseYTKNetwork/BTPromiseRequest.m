//
//  BTPromiseRequest.m
//  PromiseYTKNetwork_Example
//
//  Created by XGW on 2020/7/19.
//  Copyright © 2020 onexf. All rights reserved.
//

#import "BTPromiseRequest.h"

@implementation BTPromiseRequest 

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}


- (NSString *)requestUrl {
    return @"/mock/148/banner/index";
}

- (NSString *)baseUrl {
    return @"http://yapi.ichangtou.com";
}

/// 设置请求头，验签
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {

    NSMutableDictionary *requestSerializers = [NSMutableDictionary dictionary];

    requestSerializers[@"Content-Type"] = @"application/json";

    ///
    
    ///
    
    ///
    
    ///
    
    ///

    return requestSerializers;
}


/// 超时时间
- (NSTimeInterval)requestTimeoutInterval {
    return 15;
}



- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeHTTP;
}


@end
