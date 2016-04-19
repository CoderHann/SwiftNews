//
//  YTNewsContentForPhoto.m
//  SwiftNews
//
//  Created by roki on 15/11/16.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTNewsContentItemForPhoto.h"
#import "YTRequestURLTool.h"
#import "YTNewsItem.h"
#import "YTNetRequestTool.h"
#import "YTNewsContentForPhoto.h"
#import "YTNewsContentPhoto.h"
#import "MJExtension.h"
#import "YTNewsContentPhotoCell.h"
#import "YTNewsContentPhotoCell.h"
#import "YTNewsContentBarTool.h"
#import "YTDataBaseManager.h"

@interface YTNewsContentForPhoto()<UICollectionViewDataSource,UICollectionViewDelegate>
// collection
@property(nonatomic,weak) UICollectionView *collectionView;

/** 存放photoset模型*/
@property(nonatomic,strong) YTNewsContentItemForPhoto *newsPhotoItem;

/** 是否正在向右隐藏页面*/
@property(nonatomic,assign) BOOL isHideToRight;
/** 存放描述总体*/
@property(nonatomic,weak) UIView *descView;
/** 标题label*/
@property(nonatomic,weak) UILabel *titleLabel;
/** 存放当前数目的label*/
@property(nonatomic,weak) UILabel *nowNumberLabel;
/** 存放详细的描述*/
@property(nonatomic,weak) UITextView *detailView;

@end
@implementation YTNewsContentForPhoto
@synthesize newsPhotoItem = _newsPhotoItem;
- (YTNewsContentItemForPhoto *)newsPhotoItem {
    if (!_newsPhotoItem) {
        _newsPhotoItem = [[YTNewsContentItemForPhoto alloc] init];
    }
    return _newsPhotoItem;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置collectionView
        [self setupCollectionView];
        
        // 设置下面的描述
        [self setupDesc];
        
        // 注册item
        [self.collectionView registerClass:[YTNewsContentPhotoCell class] forCellWithReuseIdentifier:photoCellID];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        self.bottomTool.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    }
    return self;
}
/** 存放imageView*/
- (void)setupCollectionView {
    // 定义一个布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(YTScreenSize.width, YTScreenSize.width * YTPhotoScale);
//    flowLayout.itemSize = CGSizeMake(200, YTScreenSize.width * YTPhotoScale);
//    flowLayout.itemSize = self.collectionView.frame.size;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collection.pagingEnabled = YES;
    collection.showsHorizontalScrollIndicator = NO;
    collection.showsVerticalScrollIndicator = NO;
    collection.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
//    collection.bounces = NO;
    collection.dataSource = self;
    collection.delegate = self;
    self.collectionView = collection;
    [self addSubview:collection];
}
/** 由uiview整天加上label和textview子控件*/
- (void)setupDesc {
    UIView *view = [[UIView alloc] init];
    self.descView = view;
    // 添加标题label
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.font = [UIFont boldSystemFontOfSize:15];
    descLabel.textColor = [UIColor whiteColor];
    [view addSubview:descLabel];
    self.titleLabel = descLabel;
    
    // 添加数目标题
    UILabel *numberLabel = [[UILabel alloc] init];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.font = [UIFont systemFontOfSize:13];
    numberLabel.textColor = [UIColor whiteColor];
    [view addSubview:numberLabel];
    self.nowNumberLabel = numberLabel;
    
    // 添加detailView
    UITextView *textView = [[UITextView alloc] init];
    textView.backgroundColor = [UIColor clearColor];
    textView.textColor = [UIColor whiteColor];
    textView.font = [UIFont systemFontOfSize:14];
    textView.editable = NO;
    [view addSubview:textView];
    self.detailView = textView;
    
    [self addSubview:view];
}

- (void)setItem:(YTNewsItem *)item {
    super.item = item;
    
    self.collectionView.contentOffset = CGPointZero;
    // 网络请求开始
    [self loadPhotoWithItem:item];
    
}

- (void)setNewsPhotoItem:(YTNewsContentItemForPhoto *)newsPhotoItem {
    _newsPhotoItem = newsPhotoItem;
    self.titleLabel.text = newsPhotoItem.setname;
    self.nowNumberLabel.text = [NSString stringWithFormat:@"1/%zd",newsPhotoItem.photos.count];
    self.detailView.text = [[newsPhotoItem.photos firstObject] imgtitle];
}
- (void)loadPhotoWithItem:(YTNewsItem *)item {
    // 网路请求工具
    NSString *url = [YTRequestURLTool requestURLWithSetID:item.photosetID];
    JLog(@"%@",url);
    // 首先去数据库中查看是否有缓存
    NSData *newsContent = [YTDataBaseManager newsContentTitleWithUrl:url];
    if (newsContent) { // 有缓存
        NSDictionary *json = [NSKeyedUnarchiver unarchiveObjectWithData:newsContent];
        
        [self reloadCollectionView:json];
        
    } else {
        [YTNetRequestTool GET:url withParameters:nil success:^(NSDictionary *json) {
            // 存储到数据库
            NSString *tid = [self askForTid];
            if (tid) {
                [YTDataBaseManager saveNewsTitleWithTid:tid url:url andData:[NSKeyedArchiver archivedDataWithRootObject:json]];
            }
            // 刷新
            [self reloadCollectionView:json];
            
        } error:^(NSError *error) {
             JLog(@"error:%@",error);
         }];
    }
}
- (void)reloadCollectionView:(NSDictionary *)json {
    // 获取得到的图片数据-》模型
    YTNewsContentItemForPhoto *newsPhoto = [YTNewsContentItemForPhoto objectWithKeyValues:json];
    self.newsPhotoItem = newsPhoto;
    [self.collectionView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat collectX = 0;
    CGFloat collectY = 0;
    CGFloat collectW = YTScreenSize.width;
    CGFloat collectH = YTPhotoScale * collectW;
    self.collectionView.frame = CGRectMake(collectX, collectY, collectW, collectH);
    self.collectionView.center = self.center;
    
    // 描述信息
    CGFloat descW = YTScreenSize.width;
    CGFloat descH = 100;
    CGFloat descX = 0;
    CGFloat descY = YTScreenSize.height - self.bottomTool.height - descH;
//    self.descView.backgroundColor = [UIColor redColor];
    self.descView.frame = CGRectMake(descX, descY, descW, descH);
    
    // title
    CGFloat titleX = 10;
    CGFloat titleY = 0;
    CGFloat titleW = YTScreenSize.width - 80;
    CGFloat titleH = 30;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
//    self.titleLabel.backgroundColor = [UIColor greenColor];
    // numberlabel
    
    CGFloat numberY = 0;
    CGFloat numberW = 70;
    CGFloat numberH = titleH;
    CGFloat numberX = YTScreenSize.width - numberW;
    self.nowNumberLabel.frame = CGRectMake(numberX, numberY, numberW, numberH);
    
    // textView
    CGFloat textX = 10;
    CGFloat textY = titleH;
    CGFloat textW = YTScreenSize.width - 2 * textX;
    CGFloat textH = descH - titleH;
    self.detailView.frame = CGRectMake(textX, textY, textW, textH);
    
    
}
#pragma mark - YTNewsContentBarToolDelegate 代理
- (void)newsContentBarDidClickedShareBtn:(YTNewsContentBarTool *)tool {
    // 发送通知给控制器，分享新闻
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[YTNewsShareKey] = [NSString stringWithFormat:@"%@-%@",self.newsPhotoItem.setname,self.newsPhotoItem.url];
    [YTNotificationCenter postNotificationName:YTNewsShareNotification object:nil userInfo:info];
    [super sharedSomeNewsInfo];
}


#pragma mark -collectionView datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    JLog(@"%zd",self.newsPhotoItem.photos.count);
    return self.newsPhotoItem.photos.count;
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YTNewsContentPhotoCell *cell = [YTNewsContentPhotoCell photoCellWithCollectionView:collectionView forIndexPath:indexPath];
    YTNewsContentPhoto *photo = self.newsPhotoItem.photos[indexPath.row];
    cell.photoItem = photo;
    
    return cell;
    
}

#pragma mark -scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isHideToRight) return;
    JLog(@"scrollViewDidScroll");
    CGPoint offset = scrollView.contentOffset;
    if (offset.x < 0) {
        self.isHideToRight = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.x = YTScreenSize.width;
            
        } completion:^(BOOL finished) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            self.hidden = YES;
            self.isHideToRight = NO;
        }];

    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    NSUInteger number = (offset.x + YTScreenSize.width * 0.5) / YTScreenSize.width;
    self.nowNumberLabel.text = [NSString stringWithFormat:@"%zd/%zd",number + 1,self.newsPhotoItem.photos.count];
    self.detailView.text = [[self.newsPhotoItem.photos objectAtIndex:number] imgtitle];
    
}
@end
