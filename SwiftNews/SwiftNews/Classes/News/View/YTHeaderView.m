//
//  YTHeaderView.m
//  SwiftNews
//
//  Created by roki on 15/11/11.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTHeaderView.h"
#import "UIImageView+WebCache.h"
#import "YTNewsItem.h"
#import "YTPageControl.h"

@interface YTHeaderView()<UIScrollViewDelegate>
// scrollView显示图片用的
@property(nonatomic,weak) UIScrollView *scrollView;
@property(nonatomic,weak) YTPageControl *pageCtrl;
@property(nonatomic,weak) UILabel *titleLabel;
@end

@implementation YTHeaderView

#pragma mark -初始化

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        // 添加scrollView
        [self setupScrollView];
        // 添加pagecontrol
        [self setupPageCtrl];
        // 添加label
        [self setupTitleLabel];
        // 其他
        self.contentView.backgroundColor = YTRGBColor(247, 247, 247);
    }
    return self;
}
#pragma mark - 创建scrollView

/** 添加TitleLabel*/
- (void)setupTitleLabel {
    UILabel *title = [[UILabel alloc] init];
//    title.backgroundColor = [UIColor redColor];
    title.font = [UIFont systemFontOfSize:13];
    self.titleLabel = title;
    [self addSubview:title];
}

/** 添加scrollView*/
- (void)setupScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [self.contentView addSubview:scrollView];
}
/** 添加PageCtrl*/
- (void)setupPageCtrl {
    YTPageControl *pageCtrl = [[YTPageControl alloc] init];
//    pageCtrl.backgroundColor = YTRandomColor;
    
    pageCtrl.hidesForSinglePage = YES;
    UIImage *currentImage = [UIImage imageNamed:@"headerPageCtrlSelected"];
    UIImage *image = [UIImage imageNamed:@"headerPageCtrl"];
    [pageCtrl setValue:currentImage forKey:@"_currentPageImage"];
    [pageCtrl setValue:image forKey:@"_pageImage"];
    
    pageCtrl.currentPageIndicatorTintColor = [UIColor orangeColor];
    self.pageCtrl = pageCtrl;
    [self addSubview:pageCtrl];
}
/** 根据提供的模型设置headerView*/
+ (instancetype)headerViewWithNewsItems:(NSArray *)items andReuseIdentifier:(NSString *)reuseIdentifier {
    YTHeaderView *headerView = [[self alloc] initWithReuseIdentifier:reuseIdentifier];
    headerView.items = items;
    return headerView;
}
// 在items的set方法中做一些设置
- (void)setItems:(NSArray *)items {
    _items = items;
    NSUInteger count = items.count;
    self.pageCtrl.numberOfPages = count;
    for (NSUInteger i = 0; i < count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.scrollView addSubview:imageView];
        YTNewsItem *item = items[i];
        if (i == 0) {
            self.titleLabel.text = item.title;
        }
        [imageView sd_setImageWithURL:[NSURL URLWithString:item.imgsrc] placeholderImage:[UIImage imageNamed:@"newsPlaceholder"]];
    }
}

#pragma mark -UIScrollViewDelegate 代理方法
// 当正在滚动的时候检测是否更换pageCtrl
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint offset = self.scrollView.contentOffset;
    JLog(@"scrollViewDidScroll%@",NSStringFromCGPoint(offset));
    CGFloat scrollWidth = self.scrollView.width;
    NSUInteger pageCount = (offset.x +  scrollWidth * 0.5) / scrollWidth;
    self.pageCtrl.currentPage = pageCount;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint offset = self.scrollView.contentOffset;
    CGFloat scrollWidth = self.scrollView.width;
    NSUInteger pageCount = offset.x / scrollWidth;
    YTNewsItem *item = self.items[pageCount];
    self.titleLabel.text = item.title;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    // contentView
    CGFloat contentX = 0;
    CGFloat contentY = 0;
    CGFloat contentW = YTScreenSize.width;
    CGFloat contentH = 150;
    self.contentView.frame = CGRectMake(contentX, contentY, contentW, contentH);
    
    // scrollview
    self.scrollView.frame = self.contentView.bounds;
    // 设置scrollview的子控件
    NSUInteger count = self.scrollView.subviews.count;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * count,0);
    CGFloat imageY = 0;
    CGFloat imageW = self.scrollView.width;
    CGFloat imageH = self.scrollView.height;
    for (NSUInteger i = 0;i < count;i++) {
        UIImageView *image = self.scrollView.subviews[i];
        CGFloat imageX = i * imageW;
        image.frame = CGRectMake(imageX, imageY, imageW, imageH);
    }
    // pagecontrol
//    for (NSUInteger i = 0; i < self.pageCtrl.subviews.count; i++) {
//        JLog(@"%@",self.pageCtrl.subviews[i]);
//    }
    CGFloat pageW = YTPageControlW * (self.pageCtrl.numberOfPages * 2 + 1);
    CGFloat pageH = 20;
    CGFloat pageX = self.width - pageW;
    CGFloat pageY = self.height - pageH;
    self.pageCtrl.frame = CGRectMake(pageX, pageY, pageW, pageH);
//    for (NSUInteger i = 0; i < self.pageCtrl.subviews.count; i++) {
//        JLog(@"%@",self.pageCtrl.subviews[i]);
//    }
    // 设置textlabel
    CGFloat textX = 0;
    CGFloat textY = CGRectGetMaxY(self.contentView.frame);
    CGFloat textW = 250;
    CGFloat textH = 20;
    self.titleLabel.frame = CGRectMake(textX, textY, textW, textH);
    
}
@end
