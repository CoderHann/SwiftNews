//
//  YTNewsItemPhotoCell.m
//  SwiftNews
//
//  Created by roki on 15/11/12.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTNewsItemPhotoCell.h"
#import "UIImageView+WebCache.h"
#import "YTNewsItem.h"
#define YTNewsPhotoImageNumber 3
@interface YTNewsItemPhotoCell()
// 分割线
@property(nonatomic,weak) UIView *separator;
// 评论数label
@property(nonatomic,weak) UILabel *replyCountLabel;
/** 存放image的uiview*/
@property(nonatomic,weak) UIView *imagesView;
/** 存放实际的image数量*/
@property(nonatomic,strong) NSMutableArray *imageViewSrc;
@end

@implementation YTNewsItemPhotoCell
#pragma mark -懒加载进行初始化一些控件
- (NSMutableArray *)imageViewSrc {
    if (!_imageViewSrc) {
        _imageViewSrc = [[NSMutableArray alloc] init];
    }
    return _imageViewSrc;
}
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

- (UIView *)imagesView {
    if (!_imagesView) {
        UIView *images = [[UIView alloc] init];
        
        [self addSubview:images];
        _imagesView = images;
        [self addImagesView];
    }
    return _imagesView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
- (void)addImagesView {
    // 添加三个imageView
    for (NSUInteger i = 0; i < YTNewsPhotoImageNumber; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        imageView.clipsToBounds = YES;
        [_imagesView addSubview:imageView];
    }
}
/** 初始化*/
- (void)setup {
    JLog(@"setup");
    // 设置content的背景色
    self.contentView.backgroundColor = YTRGBColor(247, 247, 247);
    
    // 设置文字属性]
    // 默认适配宽屏幕的iPhone
    self.textLabel.font = [UIFont systemFontOfSize:17];
    
    // 屏幕320一下的
    if (YTScreenSize.width <= 320) {
        self.textLabel.font = [UIFont systemFontOfSize:15];
        
    }

    // 设置cell的分割线属性
    self.separator.backgroundColor = YTRGBColor(225, 225, 225);
    self.separator.size = CGSizeMake(YTScreenSize.width, 1);
    
    // 评论数label
    self.replyCountLabel.font = [UIFont systemFontOfSize:9];
    self.replyCountLabel.textColor = [UIColor grayColor];
    
    // 设置imagesView
//    self.imagesView.backgroundColor = [UIColor redColor];
}

// 返回新闻条的cell
+ (instancetype)newsItemCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"newsItemPhotoCell";
    YTNewsItemPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YTNewsItemPhotoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (void)setNewsItem:(YTNewsItem *)newsItem {
    _newsItem = newsItem;
    // 设置数据
    // 1.图片
    [self.imageViewSrc removeAllObjects];
    [self.imageViewSrc addObject:newsItem.imgsrc];
    [self.imageViewSrc addObjectsFromArray:newsItem.imgextra];
    JLog(@"imageViewSrc%zd",self.imageViewSrc.count);
    JLog(@"subviews%zd",self.imagesView.subviews.count);
    for (NSUInteger i = 0; i < self.imageViewSrc.count; i++) {
        UIImageView *imageView = self.imagesView.subviews[i];
        [imageView sd_setImageWithURL:self.imageViewSrc[i] placeholderImage:[UIImage imageNamed:@"newsPlaceholder"]];
    }
    // 2.标题
    self.textLabel.text = newsItem.title;
    // 4.评论数
    self.replyCountLabel.text = [NSString stringWithFormat:@"%ld评论",newsItem.replyCount];
    
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat margin = 8;
    
    // textlabel
    CGFloat textX = margin;
    CGFloat textY = margin;
    CGSize textS = [self.newsItem.title sizeWithMaxSize:CGSizeMake(YTScreenSize.width - textX - margin, MAXFLOAT) withTextFont:self.textLabel.font];
    self.textLabel.frame = (CGRect){{textX,textY},textS};
    
    // 评论数
    CGSize replyS = [self.replyCountLabel.text sizeWithMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) withTextFont:self.replyCountLabel.font];
    CGFloat replyX = YTScreenSize.width - replyS.width - margin;
    CGFloat replyY = 0;
    self.replyCountLabel.frame = (CGRect){{replyX,replyY},replyS};
    self.replyCountLabel.centerY = self.textLabel.centerY;

    // 图片
    CGFloat imagesX = margin;
    CGFloat imagesY = CGRectGetMaxY(self.textLabel.frame) + margin;
    CGFloat imagesW = YTScreenSize.width - 2 * margin;
    CGFloat imagesH = 75;
    self.imagesView.frame = CGRectMake(imagesX, imagesY, imagesW, imagesH);
    NSUInteger count = self.imageViewSrc.count;
    CGFloat imageW = (imagesW - margin) / count;
    CGFloat imageH = imagesH;
    CGFloat imageY = 0;
    
    for (NSUInteger i = 0; i < count; i++) {
        UIImageView *imageView = self.imagesView.subviews[i];
        CGFloat imageX = (imageW + margin * 0.5) * i;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    }
    // separator
    self.separator.x = 0;
    self.separator.y = self.height - self.separator.height;
    
    
}

@end
