//
//  YTDuanZiItem.m
//  SwiftNews
//
//  Created by roki on 15/11/16.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTDuanZiItem.h"

@implementation YTDuanZiItem
- (void)setPixel:(NSString *)pixel {
    _pixel = pixel;
    
    NSArray *element = [pixel componentsSeparatedByString:@"*"];
    CGFloat height = (YTScreenSize.width - 20) * [[element lastObject] floatValue] / [[element firstObject] floatValue];
    self.imageSize = CGSizeMake(YTScreenSize.width - 20, height);
}
@end
