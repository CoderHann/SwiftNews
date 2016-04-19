//
//  YTNewsAddTitleView.m
//  SwiftNews
//
//  Created by roki on 15/11/19.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTNewsAddTitleView.h"
#import "YTNewsTopicItem.h"
#import "YTNewsTitleLabel.h"

@interface YTNewsAddTitleView()
// 已有的标题Label
@property(nonatomic,weak) UILabel *ownLabel;
// 已有整个view
@property(nonatomic,weak) UIView *ownView;

// 未有的整个view
@property(nonatomic,weak) UIView *addView;
// 可以添加的标题
@property(nonatomic,weak) UILabel *enableLabel;

/** 存储当前点击的label*/
@property(nonatomic,weak) UILabel *tappedLabel;

@end

@implementation YTNewsAddTitleView



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = YTRGBColor(230, 230, 230);
    
    [self setupOwnView];
    
    [self setupAddView];
    
}
- (void)setupOwnView {
    UIView *ownView = [[UIView alloc] init];
    
    // 添加已有的标题Label
    UILabel *label = [[UILabel alloc] init];
    label.text = @"  已添加的标题:";
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:14];
    label.backgroundColor = YTRGBColor(247, 247, 247);
    [ownView addSubview:label];
    self.ownLabel = label;
    
//    ownView.backgroundColor = YTRGBColor(230, 230, 230);
    [self addSubview:ownView];
    self.ownView = ownView;
}

- (void)setupAddView {
    UIView *addView = [[UIView alloc] init];
    // 添加已有的标题Label
    UILabel *label = [[UILabel alloc] init];
    label.text = @"  选择标题:";
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:14];
    label.backgroundColor = YTRGBColor(247, 247, 247);
    [addView addSubview:label];
    self.enableLabel = label;
    
//    addView.backgroundColor = YTRGBColor(230, 230, 230);
    [self addSubview:addView];
    self.addView = addView;
}

- (void)setOwnTitle:(NSMutableArray *)ownTitle {
    _ownTitle = ownTitle;
    for (UIView *view in self.ownView.subviews) {
//        JLog(@"deleteView.subviews:%zd",deleteView.subviews.count);
//        JLog(@"self.ownTitle.count:%zd",self.ownTitle.count);
        if (![view isKindOfClass:[YTNewsTitleLabel class]]) {
            continue;
        }
        [view removeFromSuperview];
    }

    for (YTNewsTopicItem *item in ownTitle) {
        [self addNewsTitleWithItem:item forView:self.ownView];
    }
    
}

- (void)setEnableAddTitle:(NSMutableArray *)enableAddTitle {
    _enableAddTitle = enableAddTitle;
    for (UIView *view in self.addView.subviews) {
        //        JLog(@"deleteView.subviews:%zd",deleteView.subviews.count);
        //        JLog(@"self.ownTitle.count:%zd",self.ownTitle.count);
        if (![view isKindOfClass:[YTNewsTitleLabel class]]) {
            continue;
        }
        [view removeFromSuperview];
    }

    for (YTNewsTopicItem *item in enableAddTitle) {
        [self addNewsTitleWithItem:item forView:self.addView];
    }
}

- (void)addNewsTitleWithItem:(YTNewsTopicItem *)item forView:(UIView *)contentView {
    YTNewsTitleLabel *label = [[YTNewsTitleLabel alloc] init];
    label.item = item;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeNewsItem:)];
    [label addGestureRecognizer:tap];
    label.userInteractionEnabled = YES;
    [contentView addSubview:label];
//    self.tappedLabel = label;
    JLog(@"%d",label.userInteractionEnabled);
    
    [self setNeedsLayout];
}

/** 点击之后的action*/
- (void)changeNewsItem:(UITapGestureRecognizer *)tap {
    YTNewsTitleLabel *label = (YTNewsTitleLabel *)tap.view;
    if ([self is:self.ownTitle ContainingItem:label.item]) {

        
        [self changeNewsTitleItem:label.item delete:self.ownTitle andDeleteView:self.ownView add:self.enableAddTitle andAddView:self.addView];
        
    } else {

        [self changeNewsTitleItem:label.item delete:self.enableAddTitle andDeleteView:self.addView add:self.ownTitle andAddView:self.ownView];
    }
    
    [self setNeedsLayout];
}

- (BOOL)is:(NSMutableArray *)itemsArray ContainingItem:(YTNewsTopicItem *)item {
    
    for (YTNewsTopicItem *tempItem in itemsArray) {
        if ([item.tname isEqualToString:tempItem.tname]) return YES;
    }
    return NO;
}

- (void)changeNewsTitleItem:(YTNewsTopicItem *)item delete:(NSMutableArray *)deleteArray andDeleteView:(UIView *)deleteView add:(NSMutableArray *)addArray andAddView:(UIView *)addView {
    [deleteArray removeObject:item];
    for (UIView *view in deleteView.subviews) {
        JLog(@"deleteView.subviews:%zd",deleteView.subviews.count);
        JLog(@"self.ownTitle.count:%zd",self.ownTitle.count);
        if (![view isKindOfClass:[YTNewsTitleLabel class]]) {
            continue;
        }
        YTNewsTitleLabel *tempLabel = (YTNewsTitleLabel *)view;
        if ([tempLabel.text isEqualToString:item.tname]) {
            [view removeFromSuperview];
        }
    }
    [addArray addObject:item];
    [self addNewsTitleWithItem:item forView:addView];

}
- (void)layoutSubviews {
    [super layoutSubviews];
    // 计算拥有的frame
    CGFloat itemW = 60;
    CGFloat itemH = 30;
    NSUInteger maxCol = 4;
    NSUInteger ownNumber = self.ownTitle.count;
    
    CGFloat paddingX = (YTScreenSize.width - maxCol * itemW) / (maxCol + 1);
    CGFloat paddingY = 20;
    CGFloat ownViewH = (paddingY + itemH) * ((ownNumber + maxCol - 1) / maxCol) + itemH + paddingY;
    
    CGFloat ownX = 0;
    CGFloat ownY = 0;
    CGFloat ownW = YTScreenSize.width;
    CGFloat ownH = ownViewH;
    self.ownView.frame = CGRectMake(ownX, ownY, ownW, ownH);
    
    // 设置ownlabel
    self.ownLabel.frame = CGRectMake(0, 0, ownW, itemH);
    // 设置小标题
    for (NSUInteger i = 0; i < ownNumber; i++) {
        NSInteger row = i / maxCol;
        NSInteger col = i % maxCol;
        
        CGFloat itemX = paddingX + (paddingX + itemW) * col;
        CGFloat itemY = paddingY + (paddingY + itemH) * row + CGRectGetMaxY(self.ownLabel.frame);
        JLog(@"%zd",self.ownView.subviews.count);
        YTNewsTitleLabel *label = self.ownView.subviews[i + 1];
        label.frame = CGRectMake(itemX, itemY, itemW, itemH);
    }
    
    
    
    // 为拥有的frame
    NSUInteger addNumber = self.enableAddTitle.count;
    
    CGFloat addViewH = (paddingY + itemH) * ((addNumber + maxCol - 1) / maxCol) + itemH + paddingY;
    
    CGFloat addX = 0;
    CGFloat addY = CGRectGetMaxY(self.ownView.frame);
    CGFloat addW = ownW;
    CGFloat addH = addViewH;
    self.addView.frame = CGRectMake(addX, addY, addW, addH);
    // 设置ownlabel
    self.enableLabel.frame = CGRectMake(0, 0, ownW, itemH);
    // 设置小标题
    for (NSUInteger i = 0; i < addNumber; i++) {
        NSInteger row = i / maxCol;
        NSInteger col = i % maxCol;
        
        CGFloat itemX = paddingX + (paddingX + itemW) * col;
        CGFloat itemY = paddingY + (paddingY + itemH) * row + CGRectGetMaxY(self.enableLabel.frame);
        YTNewsTitleLabel *label = self.addView.subviews[i + 1];
        label.frame = CGRectMake(itemX, itemY, itemW, itemH);
    }

    
}
@end
