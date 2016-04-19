//
//  NSString+ContentSize.m
//  weibo
//
//  Created by roki on 15/10/27.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "NSString+ContentSize.h"

@implementation NSString (ContentSize)
- (CGSize)sizeWithMaxSize:(CGSize)size withTextFont:(UIFont *)font {
    NSDictionary *attr = @{NSFontAttributeName:font};
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
}
@end
