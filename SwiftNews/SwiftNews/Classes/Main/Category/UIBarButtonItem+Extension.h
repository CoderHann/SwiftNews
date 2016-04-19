//
//  UIBarButtonItem+Extension.h
//  weibo
//
//  Created by roki on 15-10-17.
//  Copyright (c) 2015年 MACIOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (instancetype)barButtonItemWithTarget:(id)target action:(SEL)action andNormalBackImage:(NSString *)image andHighlightImage:(NSString *)highImage;
@end
