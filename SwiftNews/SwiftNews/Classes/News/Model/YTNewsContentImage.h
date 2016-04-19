//
//  YTNewsContentImage.h
//  SwiftNews
//
//  Created by roki on 15/11/13.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTNewsContentImage : NSObject
/** 在body中的标签*/
@property(nonatomic,copy) NSString *ref;
/** 图片的url*/
@property(nonatomic,copy) NSString *src;
/** 图片的size Str*/
@property(nonatomic,copy) NSString *pixel;
/** 图片的size*/
@property(nonatomic,assign) CGSize size;

@end
