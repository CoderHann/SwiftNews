//
//  YTDuanZiItemFrame.m
//  SwiftNews
//
//  Created by roki on 15/11/16.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTDuanZiItemFrame.h"
#import "YTDuanZiItem.h"

@implementation YTDuanZiItemFrame
- (void)setDuanZi:(YTDuanZiItem *)duanZi {
    _duanZi = duanZi;
    
    // 计算frame
    // 内容
    CGFloat padding = 10;
    
    CGFloat digestX = padding;
    CGFloat digestY = padding;
    CGSize digestS = [duanZi.digest sizeWithMaxSize:CGSizeMake(YTScreenSize.width - 2 * padding, MAXFLOAT) withTextFont:YTDuanZiDigestFont];
    self.digestF = (CGRect){{digestX,digestY},digestS};
    
    
    // image
    if (duanZi.imgsrc) {
        CGFloat pixelX = digestX;
        CGFloat pixelY = CGRectGetMaxY(self.digestF) + padding;
        CGFloat pixelW = YTScreenSize.width - 2 * padding;
        CGFloat pixelH = duanZi.imageSize.height;
        self.pixelF = CGRectMake(pixelX, pixelY, pixelW, pixelH);
    }else {
        self.pixelF = CGRectZero;
    }
    
    
    // 分享，点赞等
    
    
    CGFloat shareW = 44;
    CGFloat shareH = 44;
    CGFloat shareX = YTScreenSize.width - shareW - padding;
    CGFloat shareY = MAX(CGRectGetMaxY(self.pixelF), CGRectGetMaxY(self.digestF));
    
    self.shareF = CGRectMake(shareX, shareY, shareW, shareH);
    
    //
    CGFloat downW = 60;
    CGFloat downH = 44;
    CGFloat downX = shareX - padding - downW;
    CGFloat downY = shareY;
    
    self.downTimesF = CGRectMake(downX, downY, downW, downH);
    
    //
    CGFloat upW = 60;
    CGFloat upH = 44;
    CGFloat upX = downX - padding - upW;
    CGFloat upY = shareY;
    
    self.upTimesF = CGRectMake(upX, upY, upW, upH);
    
    // cell height
    self.cellHeight = CGRectGetMaxY(self.upTimesF);
    
}

@end
