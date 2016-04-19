//
//  YTNewsContentImage.m
//  SwiftNews
//
//  Created by roki on 15/11/13.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTNewsContentImage.h"

@implementation YTNewsContentImage
- (void)setPixel:(NSString *)pixel {
    _pixel = pixel;
    NSArray *sizeStr = [pixel componentsSeparatedByString:@"*"];
    CGFloat width = YTScreenSize.width - 20;
    CGFloat height = [[sizeStr lastObject] floatValue] * width / [[sizeStr firstObject] floatValue];
    self.size = CGSizeMake(width, height);
}
@end
