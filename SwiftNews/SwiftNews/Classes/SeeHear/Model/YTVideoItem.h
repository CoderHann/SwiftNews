//
//  YTVideoItem.h
//  SwiftNews
//
//  Created by roki on 15/11/17.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTVideoItem : NSObject
/** */
@property(nonatomic,copy) NSString *title;
/** */
@property(nonatomic,copy) NSString *desc;
/** */
@property(nonatomic,copy) NSString *mp4_url;
/** */
@property(nonatomic,copy) NSString *playCount;
/** */
@property(nonatomic,copy) NSString *cover;
/** */
@property(nonatomic,copy) NSString *length;


//"replyCount": 0,
//"videosource": "新媒体",
//"mp4Hd_url": null,
//"cover": "http://vimg1.ws.126.net/image/snapshot/2015/11/U/9/VB7P3MMU9.jpg",
//"title": "Sori Na练习室《HoodGoCrazy》",
//"playCount": 10550,
//"replyBoard": "video_bbs",
//"replyid": "B7P3LM1E008535RB",
//"description": "编舞帅炸了",
//"mp4_url": "http://flv2.bn.netease.com/videolib3/1511/18/zSRcb6322/SD/zSRcb6322-mobile.mp4",
//"length": 85,
//"playersize": 1,
//"m3u8Hd_url": null,
//"vid": "VB7P3LM1E",
//"m3u8_url": "http://flv2.bn.netease.com/videolib3/1511/18/zSRcb6322/SD/movie_index.m3u8",
//"ptime": "2015-11-18 11:07:12"
@end
