//
//  UIImage+Extension.m
//  weibo
//
//  Created by roki on 15-10-18.
//  Copyright (c) 2015年 MACIOS. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
/**
 *  给提供的图片名返回一个可以伸缩的可变图片
 */
+ (instancetype)resizableImageFromImageName:(NSString *)imageName {
    UIImage *normalImage = [UIImage imageNamed:imageName];
    CGFloat width = normalImage.size.width * 0.5;
    CGFloat height = normalImage.size.height * 0.5;
    return [normalImage resizableImageWithCapInsets:UIEdgeInsetsMake(height, width, height, width)];
    
}
@end
