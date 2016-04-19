//
//  YTNewsItem.m
//  SwiftNews
//
//  Created by roki on 15/11/9.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTNewsItem.h"
#import "MJExtension.h"

@implementation YTNewsItem
- (void)setImgextra:(NSArray *)imgextra {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in imgextra) {
        [array addObject:dict[@"imgsrc"]];
    }
    _imgextra = array;
}
@end
