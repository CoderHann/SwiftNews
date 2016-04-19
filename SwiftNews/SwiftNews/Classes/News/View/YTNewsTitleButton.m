//
//  YTNewTitleButton.m
//  SwiftNews
//
//  Created by roki on 15/11/7.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTNewsTitleButton.h"
#import "YTNewsTopicItem.h"

@implementation YTNewsTitleButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self sizeToFit];
    }
    return self;
}

// 模型set
- (void)setTopic:(YTNewsTopicItem *)topic {
    _topic = topic;
    [self setTitle:topic.tname forState:UIControlStateNormal];
}
@end
