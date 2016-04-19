//
//  YTNewsContentPhotoCell.h
//  SwiftNews
//
//  Created by roki on 15/11/16.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <UIKit/UIKit.h>
#define YTPhotoScale (900.0 / 600)
@class YTNewsContentPhoto;
static NSString *photoCellID = @"photoCell";

@interface YTNewsContentPhotoCell : UICollectionViewCell
@property(nonatomic,strong) YTNewsContentPhoto *photoItem;
/** 创建一个cell*/
+ (instancetype)photoCellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
 
@end
