//
//  YTSeeHearCell.m
//  SwiftNews
//
//  Created by roki on 15/11/17.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTSeeHearCell.h"
#import "YTVideoItem.h"
#import "UIImageView+WebCache.h"


@interface YTSeeHearCell()

@property (weak, nonatomic) IBOutlet UILabel *videoTitle;

@property (weak, nonatomic) IBOutlet UILabel *videoDesc;
@property (weak, nonatomic) IBOutlet UIImageView *videoIconView;
@property (weak, nonatomic) IBOutlet UIImageView *playIcon;

@property (weak, nonatomic) IBOutlet UIButton *videoPlayCount;
@property (weak, nonatomic) IBOutlet UIButton *videoLength;
- (IBAction)shareVideo:(UIButton *)sender;

@end

@implementation YTSeeHearCell


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    JLog(@"seehearcell  setup");
//    self.contentView.backgroundColor = [UIColor greenColor];
    self.videoIconView.contentMode = UIViewContentModeScaleAspectFill;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (instancetype)seeHearCellWithTableView:(UITableView *)tableView {
    static NSString *seeHearCellID = @"seehearcell";
    YTSeeHearCell *cell = [tableView dequeueReusableCellWithIdentifier:seeHearCellID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YTSeeHearCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)setItem:(YTVideoItem *)item {
    _item = item;
    
    self.videoTitle.text = item.title;
    
    self.videoDesc.text = item.desc;
    
    [self.videoIconView sd_setImageWithURL:[NSURL URLWithString:item.cover] placeholderImage:[UIImage imageNamed:@"defaultPlaceholder"]];
    [self.videoLength setTitle:item.length forState:UIControlStateNormal];
    
    [self.videoPlayCount setTitle:item.playCount forState:UIControlStateNormal];
    
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.y = 5;
    self.contentView.height -= 5;
}
- (IBAction)shareVideo:(UIButton *)sender {
    JLog(@"shareVideo");
    if ([self.delegate respondsToSelector:@selector(seeHearCellDidClickedShareButton:)]) {
        [self.delegate seeHearCellDidClickedShareButton:self];
    }

}


@end
