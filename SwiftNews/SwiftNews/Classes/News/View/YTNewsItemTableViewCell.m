//
//  YTNewsItemTableViewCell.m
//  SwiftNews
//
//  Created by roki on 15/11/9.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTNewsItemTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "YTNewsItem.h"

@interface YTNewsItemTableViewCell()

// 分割线
@property(nonatomic,weak) UIView *separator;
// 评论数label
@property(nonatomic,weak) UILabel *replyCountLabel;
@end

@implementation YTNewsItemTableViewCell
#pragma mark -懒加载进行初始化一些控件
- (UIView *)separator {
    if (!_separator) {
        UIView *separator = [[UIView alloc] init];
        [self addSubview:separator];
        _separator = separator;
    }
    return _separator;
}

- (UILabel *)replyCountLabel {
    if (!_replyCountLabel) {
        UILabel *replyView = [[UILabel alloc] init];
        [self addSubview:replyView];
        _replyCountLabel = replyView;
    }
    return _replyCountLabel;
}
// xib/文件的调用
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}
// 代码创建会调用这个
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // setup
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
/** 初始化*/
- (void)setup {
    JLog(@"setup");
    // 设置content的背景色
    self.contentView.backgroundColor = YTRGBColor(247, 247, 247);
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    // 设置文字属性]
    // 默认适配宽屏幕的iPhone
    self.textLabel.font = [UIFont systemFontOfSize:17];
    self.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    // 屏幕320一下的
    if (YTScreenSize.width <= 320) {
        JLog(@"%f",YTScreenSize.width);
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
    }
    self.textLabel.numberOfLines = 0;
    self.detailTextLabel.textColor = [UIColor grayColor];
    self.detailTextLabel.numberOfLines = 0;
    // 设置cell的分割线属性
    self.separator.backgroundColor = YTRGBColor(225, 225, 225);
    self.separator.size = CGSizeMake(YTScreenSize.width, 1);
    
    // 评论数label
    self.replyCountLabel.font = [UIFont systemFontOfSize:9];
    self.replyCountLabel.textColor = [UIColor grayColor];
}

// 返回新闻条的cell
+ (instancetype)newsItemCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"newsItemCell";
    YTNewsItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YTNewsItemTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setNewsItem:(YTNewsItem *)newsItem {
    _newsItem = newsItem;
    // 设置数据
    // 1.图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:newsItem.imgsrc] placeholderImage:[UIImage imageNamed:@"newsPlaceholder"]];
    // 2.标题
    self.textLabel.text = newsItem.title;
    
    // 3.描述
    self.detailTextLabel.text = newsItem.digest;
    
    // 4.评论数
    self.replyCountLabel.text = [NSString stringWithFormat:@"%ld评论",newsItem.replyCount];
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat margin = 8;
    // image
    CGFloat imageX = margin;
    CGFloat imageY = margin;
    CGFloat imageW = 92;
    CGFloat imageH = 74;
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    // textlabel
    CGFloat textX = CGRectGetMaxX(self.imageView.frame) + margin;
    CGFloat textY = self.imageView.y;
    CGSize textS = [self.newsItem.title sizeWithMaxSize:CGSizeMake(YTScreenSize.width - textX - margin, MAXFLOAT) withTextFont:self.textLabel.font];
    self.textLabel.frame = (CGRect){{textX,textY},textS};
    
    // detailLabel
    CGFloat detailX = textX;
    CGFloat detailY = CGRectGetMaxY(self.textLabel.frame) + margin;
    CGSize detailS = [self.newsItem.digest sizeWithMaxSize:CGSizeMake(YTScreenSize.width - detailX - margin, 50) withTextFont:self.detailTextLabel.font];
    self.detailTextLabel.frame = (CGRect){{detailX ,detailY},detailS};
    
    // separator
    self.separator.x = 0;
    self.separator.y = self.height - self.separator.height;
    
    // 评论数
    CGSize replyS = [self.replyCountLabel.text sizeWithMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) withTextFont:self.replyCountLabel.font];
    CGFloat replyX = YTScreenSize.width - replyS.width - margin;
    CGFloat replyY = CGRectGetMaxY(self.imageView.frame) - replyS.height;
    self.replyCountLabel.frame = (CGRect){{replyX,replyY},replyS};
    
}
@end
