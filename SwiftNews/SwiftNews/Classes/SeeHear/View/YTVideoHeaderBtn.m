//
//  YTVideoHeaderBtn.m
//  SwiftNews
//
//  Created by roki on 15/11/18.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTVideoHeaderBtn.h"
#import "YTCategoryVideoItem.h"
#import "UIImageView+WebCache.h"
@implementation YTVideoHeaderBtn

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 初始化
        [self setup];
    }
    return self;
}
/** 按钮初始化*/
- (void)setup {
//    self.imageView.backgroundColor = [UIColor redColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    self.titleLabel.backgroundColor = [UIColor purpleColor];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor whiteColor];
}


- (void)setCategory:(YTCategoryVideoItem *)category {
    _category = category;
    [self setTitle:category.title forState:UIControlStateNormal];
    UIImageView *imageView = [[UIImageView alloc] init];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:category.imgsrc] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self setImage:imageView.image forState:UIControlStateNormal];
    }];
    
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGFloat margin = 5;
    
    CGFloat titleW = 30;
    CGFloat titleH = 20;
    CGFloat titleX = (contentRect.size.width - titleW) / 2;
    CGFloat titleY = contentRect.size.height - titleH - margin;
    
    return CGRectMake(titleX, titleY, titleW, titleH);

}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat margin = 5;
    
    CGFloat imageW = 30;
    CGFloat imageH = 30;
    CGFloat imageX = (contentRect.size.width - imageW) / 2;
    CGFloat imageY = margin;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}
@end
