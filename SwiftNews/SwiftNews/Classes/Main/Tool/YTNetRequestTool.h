//
//  YTNetRequestTool.h
//  SwiftNews
//
//  Created by roki on 15/11/7.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTNetRequestTool : NSObject
/*- (AFHTTPRequestOperation *)GET:(NSString *)URLString
parameters:(id)parameters
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
*/
/** get请求*/
+ (void)GET:(NSString *)url withParameters:(NSDictionary *)parameters success:(void (^)(id json))success error:(void (^)(NSError *error))failure;

@end
