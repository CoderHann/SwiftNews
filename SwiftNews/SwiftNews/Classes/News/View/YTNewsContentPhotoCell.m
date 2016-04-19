//
//  YTNewsContentPhotoCell.m
//  SwiftNews
//
//  Created by roki on 15/11/16.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTNewsContentPhotoCell.h"
#import "UIImageView+WebCache.h"
#import "YTNewsContentPhoto.h"

@interface YTNewsContentPhotoCell()
// imageView
@property(nonatomic,weak) UIImageView *photoImageView;

@end

@implementation YTNewsContentPhotoCell

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        _photoImageView = imageView;
        
    }
    return _photoImageView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 初始化imageView
        [self setupImageView];
//        self.backgroundColor = YTRandomColor;
    }
    return self;
}


- (void)setupImageView {
    
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.photoImageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
//    self.photoImageView.size = CGSizeMake(YTScreenSize.width, YTScreenSize.width * YTPhotoScale);
    self.photoImageView.size = self.frame.size;
}
/** 创建一个cell*/
+ (instancetype)photoCellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath {
    YTNewsContentPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[YTNewsContentPhotoCell alloc] init];
    }
    return cell;
}

- (void)setPhotoItem:(YTNewsContentPhoto *)photoItem {
    _photoItem = photoItem;
    // 清空上次的图片
    
    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:photoItem.imgurl] placeholderImage:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.photoImageView.centerY = self.centerY;
    self.photoImageView.x = 0;
//    JLog(@"%@",NSStringFromCGRect(self.photoImageView.frame));
}
@end
