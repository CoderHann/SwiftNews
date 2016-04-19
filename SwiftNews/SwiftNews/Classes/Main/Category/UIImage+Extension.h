//
//  UIImage+Extension.h
//  weibo
//
//  Created by roki on 15-10-18.
//  Copyright (c) 2015年 MACIOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  给提供的图片名返回一个可以伸缩的可变图片
 */
+ (instancetype)resizableImageFromImageName:(NSString *)imageName;

@end
