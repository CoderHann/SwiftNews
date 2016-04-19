//
//  YTNewsTitleLabel.m
//  SwiftNews
//
//  Created by roki on 15/11/19.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTNewsTitleLabel.h"
#import "YTNewsTopicItem.h"

@implementation YTNewsTitleLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.font = [UIFont systemFontOfSize:13];
    self.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor colorWithRed:1.0 green:1 blue:1 alpha:0.8];
    self.textAlignment = NSTextAlignmentCenter;
}

- (void)setItem:(YTNewsTopicItem *)item {
    _item = item;
    self.text = item.tname;
}


@end
