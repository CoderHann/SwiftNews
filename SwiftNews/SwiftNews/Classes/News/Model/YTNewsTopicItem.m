//
//  YTNewsTopicItem.m
//  SwiftNews
//
//  Created by roki on 15/11/7.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTNewsTopicItem.h"

@implementation YTNewsTopicItem
// decode方法
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.tname = [decoder decodeObjectForKey:@"tname"];
        self.tid = [decoder decodeObjectForKey:@"tid"];
    }
    return self;
}

// encode方法
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.tname forKey:@"tname"];
    [encoder encodeObject:self.tid forKey:@"tid"];
}
@end
