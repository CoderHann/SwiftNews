//
//  YTNewsContentBarTool.m
//  SwiftNews
//
//  Created by roki on 15/11/13.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTNewsContentBarTool.h"

@interface YTNewsContentBarTool()

// 返回按钮
@property(nonatomic,weak) UIButton *beforeBtn;
// 收藏按钮
@property(nonatomic,weak) UIButton *collectionBtn;
// 分享按钮
@property(nonatomic,weak) UIButton *shareBtn;

@end

@implementation YTNewsContentBarTool

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.beforeBtn = [self setBtnWithNormalImage:@"icotab_before_v5" andHighLightImage:@"icotab_beforepress_v5"];
        [self.beforeBtn addTarget:self action:@selector(clickedBeforeBtn) forControlEvents:UIControlEventTouchUpInside];
        self.collectionBtn = [self setBtnWithNormalImage:@"icofloat_collection_v5" andHighLightImage:nil];
        [self.collectionBtn setImage:[UIImage imageNamed:@"icofloat_collection-done_v5"] forState:UIControlStateSelected];
        [self.collectionBtn addTarget:self action:@selector(clickedCollectionBtn) forControlEvents:UIControlEventTouchUpInside];
        self.shareBtn = [self setBtnWithNormalImage:@"icotab_share_v5" andHighLightImage:@"icotab_sharepress_v5"];
        [self.shareBtn addTarget:self action:@selector(clickedShareBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)clickedBeforeBtn {
    JLog(@"clickedBeforeBtn");
    if ([self.delegate respondsToSelector:@selector(newsContentBarDidClickedBeforeBtn:)]) {
        [self.delegate newsContentBarDidClickedBeforeBtn:self];
    }
}
- (void)clickedCollectionBtn{
    JLog(@"clickedCollectionBtn");
    self.collectionBtn.selected = !self.collectionBtn.selected;
}
- (void)clickedShareBtn {
    JLog(@"clickedShareBtn");
    if ([self.delegate respondsToSelector:@selector(newsContentBarDidClickedShareBtn:)]) {
        [self.delegate newsContentBarDidClickedShareBtn:self];
    }
}
- (UIButton *)setBtnWithNormalImage:(NSString *)normal andHighLightImage:(NSString *)highLight {
    UIButton *btn = [[UIButton alloc] init];
    btn.contentMode = UIViewContentModeCenter;
    [btn setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highLight] forState:UIControlStateHighlighted];
    [self addSubview:btn];
    return btn;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat btnWidth = 50;
    CGFloat btnHeight = self.height;
    // beforeBtn
    CGFloat beforeX = 0;
    CGFloat beforeY = 0;
    CGFloat beforeW = btnWidth;
    CGFloat beforeH = btnHeight;
    self.beforeBtn.frame = CGRectMake(beforeX, beforeY, beforeW, beforeH);
    // shareBtn
    CGFloat shareW = 50;
    CGFloat shareH = btnHeight;
    CGFloat shareX = self.width - shareW;
    CGFloat shareY = 0;
    
    self.shareBtn.frame = CGRectMake(shareX, shareY, shareW, shareH);
    
    // collectionBtn
    CGFloat collectionW = btnWidth;
    CGFloat collectionH = btnHeight;
    CGFloat collectionX = self.width - collectionW - shareW;
    CGFloat collectionY = 0;
    
    self.collectionBtn.frame = CGRectMake(collectionX, collectionY, collectionW, collectionH);
}
@end
