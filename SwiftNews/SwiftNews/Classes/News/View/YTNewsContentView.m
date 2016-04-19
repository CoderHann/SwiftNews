//
//  YTNewsContentView.m
//  SwiftNews
//
//  Created by roki on 15/11/13.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTNewsContentView.h"
#import "YTNewsContentBarTool.h"

@interface YTNewsContentView() <UIGestureRecognizerDelegate,YTNewsContentBarToolDelegate>


@end

@implementation YTNewsContentView
- (YTNewsContentBarTool *)bottomTool {
    if (!_bottomTool) {
        YTNewsContentBarTool *tool = [[YTNewsContentBarTool alloc] init];
        [self addSubview:tool];
        _bottomTool = tool;
    }
    return _bottomTool;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 初始化
        [self setup];
        
        // 添加底部工具条
        [self setupBottomTool];
    }
    return self;
}

- (void)setupBottomTool {
    self.bottomTool.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.95];
    self.bottomTool.delegate = self;
}
- (void)setup {
    self.backgroundColor = YTRGBColor(230, 230, 230);
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(activeSwipeGesture:)];
    swipe.delegate = self;
    [self addGestureRecognizer:swipe];
}

/** 当发生清扫手势时调用*/
- (void)activeSwipeGesture:(UISwipeGestureRecognizer *)swipe {
    [UIView animateWithDuration:0.3 animations:^{
        self.x = YTScreenSize.width;
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }];
    
}
/** 询问tid*/
- (NSString *)askForTid {
    if ([self.delegate respondsToSelector:@selector(newsContentViewAskForTid:)]) {
        return [self.delegate newsContentViewAskForTid:self];
    }
    return nil;
}
#pragma mark -UISwipeGestureRecognizer 代理方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint touchPoint = [touch locationInView:touch.view];
    if (touchPoint.x > 40) return NO;
    return YES;
}


#pragma mark - YTNewsContentBarToolDelegate 代理
- (void)newsContentBarDidClickedBeforeBtn:(YTNewsContentBarTool *)tool {
    [self activeSwipeGesture:nil];
}

- (void)newsContentBarDidClickedShareBtn:(YTNewsContentBarTool *)tool {
    // 发送通知，分享新闻后调用下面的    
    [self activeSwipeGesture:nil];
}

// 分享了就会调用这个
- (void)sharedSomeNewsInfo {
    [self activeSwipeGesture:nil];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    // 工具条
    CGFloat bottomX = 0;
    CGFloat bottomY = YTScreenSize.height - 44;
    CGFloat bottomW = YTScreenSize.width;
    CGFloat bottomH = 44;
    self.bottomTool.frame = CGRectMake(bottomX, bottomY, bottomW, bottomH);
    
    
    
}
@end
