//
//  YTPageControl.m
//  SwiftNews
//
//  Created by roki on 15/11/11.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTPageControl.h"

@implementation YTPageControl

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat margin = 6;
    for (NSUInteger i = 0; i < self.subviews.count; i++) {
        
        UIImageView *imageView = self.subviews[i];
        imageView.size = CGSizeMake(6, 6);
        imageView.x = (imageView.width + margin) * i;
    }
}

@end
