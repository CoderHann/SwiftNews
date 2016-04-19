//
//  YTNetRequestTool.m
//  SwiftNews
//
//  Created by roki on 15/11/7.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTNetRequestTool.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
@implementation YTNetRequestTool
+ (void)GET:(NSString *)url withParameters:(NSDictionary *)parameters success:(void (^)(id))success error:(void (^)(NSError *))failure {
    AFHTTPRequestOperationManager *mg = [AFHTTPRequestOperationManager manager];
    mg.requestSerializer = [AFHTTPRequestSerializer serializer];
    mg.responseSerializer = [AFHTTPResponseSerializer serializer];
    [mg GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        JLog(@"%@",responseObject);
        // 自己解析json数据不让afn介入
        NSError *error = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            NSString *errorString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            JLog(@"解析错误！%@",errorString);
            [MBProgressHUD showError:@"网络不稳定"];
            return ;
        }
        if (success) {
//            JLog(@"%@",jsonDict);
            success(jsonDict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
        failure(error);
        }
    }];
}
@end
