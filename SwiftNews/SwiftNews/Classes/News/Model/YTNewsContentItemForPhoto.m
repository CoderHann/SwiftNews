//
//  YTNewsContentForPhoto.m
//  SwiftNews
//
//  Created by roki on 15/11/16.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTNewsContentItemForPhoto.h"
#import "MJExtension.h"
#import "YTNewsContentPhoto.h"

@implementation YTNewsContentItemForPhoto
+ (NSDictionary *)objectClassInArray {
    return @{@"photos" : [YTNewsContentPhoto class]};
}
@end
