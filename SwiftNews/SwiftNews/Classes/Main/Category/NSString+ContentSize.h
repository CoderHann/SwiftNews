//
//  NSString+ContentSize.h
//  weibo
//
//  Created by roki on 15/10/27.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ContentSize)
- (CGSize)sizeWithMaxSize:(CGSize)size withTextFont:(UIFont *)font;
@end
