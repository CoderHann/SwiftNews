//
//  UIBarButtonItem+Extension.m
//  weibo
//
//  Created by roki on 15-10-17.
//  Copyright (c) 2015年 MACIOS. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
+ (instancetype)barButtonItemWithTarget:(id)target action:(SEL)action andNormalBackImage:(NSString *)image andHighlightImage:(NSString *)highImage {
    // 添加左上角的item
    UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    // 设置图片
    [itemBtn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [itemBtn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [itemBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置尺寸
    itemBtn.size = itemBtn.currentBackgroundImage.size;
    return [[self alloc] initWithCustomView:itemBtn];

}
@end
