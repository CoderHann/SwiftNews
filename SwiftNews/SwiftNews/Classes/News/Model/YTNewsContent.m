//
//  YTNewsContent.m
//  SwiftNews
//
//  Created by roki on 15/11/13.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTNewsContent.h"
#import "MJExtension.h"
#import "YTNewsContentImage.h"
@implementation YTNewsContent
+ (NSDictionary *)objectClassInArray {
    return @{@"img" : [YTNewsContentImage class]};
}
@end
