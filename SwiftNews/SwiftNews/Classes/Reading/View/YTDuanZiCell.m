//
//  YTDuanZiCell.m
//  SwiftNews
//
//  Created by roki on 15/11/16.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTDuanZiCell.h"
#import "YTDuanZiItem.h"
#import "YTDuanZiItemFrame.h"
#import "UIImageView+WebCache.h"

@interface YTDuanZiCell()

// share
@property(nonatomic,weak) UIButton *shareBtn;
// up
@property(nonatomic,weak) UIButton *upBtn;
// down
@property(nonatomic,weak) UIButton *downBtn;

@end

@implementation YTDuanZiCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

// 初始化控件
- (void)setup {
    
    self.detailTextLabel.font = YTDuanZiDigestFont;
    self.detailTextLabel.numberOfLines = 0;
    // 添加分享按钮
    UIButton *shareBtn = [[UIButton alloc] init];
    shareBtn.contentMode = UIViewContentModeCenter;
//    shareBtn.backgroundColor = [UIColor redColor];
    [shareBtn setImage:[UIImage imageNamed:@"duanzishare"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickedShareBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:shareBtn];
    self.shareBtn = shareBtn;
    
    // 赞
    UIButton *up = [[UIButton alloc] init];
    [up setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    up.titleLabel.font = [UIFont systemFontOfSize:12];
    up.contentMode = UIViewContentModeLeft;
    up.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [up setImage:[UIImage imageNamed:@"duanzi_up_selected"] forState:UIControlStateSelected];
    [up setImage:[UIImage imageNamed:@"duanzi_up"] forState:UIControlStateNormal];

    [self.contentView addSubview:up];
    self.upBtn = up;
    
    // 踩
    UIButton *down = [[UIButton alloc] init];
    [down setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    down.contentMode = UIViewContentModeLeft;
    down.titleLabel.font = [UIFont systemFontOfSize:12];
    down.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [down setImage:[UIImage imageNamed:@"duanzi_down_selected"] forState:UIControlStateSelected];
    [down setImage:[UIImage imageNamed:@"duanzi_down"] forState:UIControlStateNormal];
    [self.contentView addSubview:down];
    self.downBtn = down;
    
    
}
- (void)clickedShareBtn {
    if ([self.delegate respondsToSelector:@selector(duanZiCellDidClickedShareButton:)]) {
        [self.delegate duanZiCellDidClickedShareButton:self];
    }
}
+ (instancetype)duanZiCellWithTableView:(UITableView *)tableView {
    static NSString *duanZiID = @"duanZiCell";
    YTDuanZiCell *cell = [tableView dequeueReusableCellWithIdentifier:duanZiID];
    if (!cell) {
        cell = [[YTDuanZiCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:duanZiID];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}


- (void)setItemF:(YTDuanZiItemFrame *)itemF {
    _itemF = itemF;
    YTDuanZiItem *item = itemF.duanZi;
    
    // 详细内容
    self.detailTextLabel.text = item.digest;
    
    
    // imge
    if (item.imgsrc) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:item.imgsrc] placeholderImage:[UIImage imageNamed:@"defaultPlaceholder"]];
        
    } else {
        self.imageView.image = nil;
    }
    
    
    // share
    
    // 赞
    [self.upBtn setTitle:item.upTimes forState:UIControlStateNormal];
    
    // 踩
    [self.downBtn setTitle:item.downTimes forState:UIControlStateNormal];
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.y = 10;
    self.contentView.height -= 10;
    
    self.detailTextLabel.frame = self.itemF.digestF;
    self.imageView.frame = self.itemF.pixelF;
    self.shareBtn.frame = self.itemF.shareF;
    self.upBtn.frame = self.itemF.upTimesF;
    self.downBtn.frame = self.itemF.downTimesF;
}
//
//- (void)setFrame:(CGRect)frame {
//    CGRect temp = frame;
//    temp.
//}

@end
