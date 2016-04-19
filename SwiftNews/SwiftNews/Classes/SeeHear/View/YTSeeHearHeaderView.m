//
//  YTSeeHearHeaderView.m
//  SwiftNews
//
//  Created by roki on 15/11/17.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTSeeHearHeaderView.h"
#import "YTCategoryVideoItem.h"
#import "YTVideoHeaderBtn.h"


@interface YTSeeHearHeaderView()
/** 存放所有按钮*/
@property(nonatomic,strong) NSMutableArray *headerBtns;
/** 存放所有分割线*/
@property(nonatomic,strong) NSMutableArray *dividers;

@end
@implementation YTSeeHearHeaderView

- (NSMutableArray *)headerBtns {
    if (!_headerBtns) {
        _headerBtns = [[NSMutableArray alloc] init];
    }
    return _headerBtns;
}

- (NSMutableArray *)dividers {
    if (!_dividers) {
        _dividers = [[NSMutableArray alloc] init];
    }
    return _dividers;
}

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.contentView.backgroundColor = [UIColor clearColor];
    
}

- (void)setCategories:(NSArray *)categories {
    if (_categories.count) return;
    _categories = categories;
    
    for (NSUInteger i = 0; i < categories.count; i++) {
        YTCategoryVideoItem *category = categories[i];
        // 创建btn
        [self setupHeaderBtn:category];
        
        if (i != 0) {
            // 创建分割线
            [self setupDivider];
        }
    }
    [self setNeedsLayout];
}
/** 创建btn*/
- (void)setupHeaderBtn:(YTCategoryVideoItem *)category {
    YTVideoHeaderBtn *btn = [[YTVideoHeaderBtn alloc] init];
    btn.category = category;
    [btn addTarget:self action:@selector(headerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    [self.headerBtns addObject:btn];

}
/** 创建分割线*/
- (void)setupDivider {
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = YTRGBColor(237, 237, 237);
    [self.contentView addSubview:divider];
    [self.dividers addObject:divider];
}
- (void)headerBtnClicked:(YTVideoHeaderBtn *)btn {
    if ([self.delegate respondsToSelector:@selector(seeHearHeaderView:didClickedCategoryBtn:)]) {
        [self.delegate seeHearHeaderView:self didClickedCategoryBtn:btn];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 设置按钮的frame
    NSUInteger btnCount = self.headerBtns.count;
    CGFloat dividerW = 1;
    
    CGFloat btnH = self.contentView.height;
    CGFloat btnW = (YTScreenSize.width - btnCount * dividerW) / btnCount;
    CGFloat btnY = 0;
    
    for (NSUInteger i = 0; i < btnCount; i++) {
        CGFloat btnX = i * (btnW + dividerW);
        YTVideoHeaderBtn *btn = self.headerBtns[i];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
    }
    
    // 设置分割线
    
    CGFloat dividerH = btnH;
    CGFloat dividerY = 0;
    for (NSUInteger i = 0; i < self.dividers.count; i++) {
        CGFloat dividerX = btnW + i * (dividerW + btnW);
        UIView *divider = self.dividers[i];
        divider.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH);
    }
}
@end
