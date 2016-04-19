//
//  YTVideoItem.m
//  SwiftNews
//
//  Created by roki on 15/11/17.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTVideoItem.h"
#import "MJExtension.h"

@implementation YTVideoItem
@dynamic description;
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"desc" : @"description"};
}


- (void)setPlayCount:(NSString *)playCount {
    CGFloat count = [playCount floatValue];
    if (count < 10000) {
        _playCount = playCount;
    } else {
        count = count / 10000.0;
        _playCount = [NSString stringWithFormat:@"%.1fw",count];
    }
}

- (void)setLength:(NSString *)length {
    int hour,minute,second;
    int allSeconds = [length intValue];
    hour = allSeconds / 3600;
    minute = allSeconds % 3600 / 60;
    second = allSeconds % 3600 % 60;
    if (hour != 0) {
        _length = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,second];
    } else {
        _length = [NSString stringWithFormat:@"%02d:%02d",minute,second];
    }
}


@end
