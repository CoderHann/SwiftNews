//
//  YTNewsContentForPhoto.h
//  SwiftNews
//
//  Created by roki on 15/11/16.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTNewsContentItemForPhoto : NSObject
/** 所有的照片*/
@property(nonatomic,strong) NSArray *photos;
/** 图片组标题*/
@property(nonatomic,copy) NSString *setname;
/** 图片webURl*/
@property(nonatomic,copy) NSString *url;

@end
