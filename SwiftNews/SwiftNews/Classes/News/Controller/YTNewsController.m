//
//  YTNewsController.m
//  SwiftNews
//
//  Created by roki on 15/11/6.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTNewsController.h"
#import "YTCollectionViewCell.h"
#import "YTNewsTitleView.h"
#import "MBProgressHUD+MJ.h"
#import "YTNewsTitleButton.h"
#import "YTNewsAddTitleView.h"
#import "YTNewsItem.h"
#import "UMSocial.h"
#import "YTRequestURLTool.h"

@interface YTNewsController ()<YTNewsTitleViewDelegate,YTCollectionViewCellDelegate>
// 存储将要显示的item的索引
@property(nonatomic,assign) NSUInteger selectedCellIndex;
// 标题newsview
@property(nonatomic,weak) YTNewsTitleView *newsTitleView;
// 判断是否正在选择标题而滚动scrollview
@property(nonatomic,assign) BOOL isChooseTitle;

// 添加栏目标题控件
@property(nonatomic,weak) YTNewsAddTitleView *addTitleView;
@end

@implementation YTNewsController

- (YTNewsAddTitleView *)addTitleView {
    if (!_addTitleView) {
        YTNewsAddTitleView *view = [[YTNewsAddTitleView alloc] init];
        view.frame = CGRectMake(0, 0 - YTScreenSize.height, YTScreenSize.width, YTScreenSize.height - 64);
        view.hidden = YES;
        [self.view addSubview:view];
        _addTitleView = view;
    }
    return _addTitleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化界面基本设置
    [self setupBasicOperation];
//    
    // 设置顶部滚动条
    [self setupTitleScrollView];
    
    // 设置rightitem
    [self setupRightItem];
    
    // 接收通知
    [YTNotificationCenter addObserver:self selector:@selector(shareNewsNotification:) name:YTNewsShareNotification object:nil];
    
}
// 设置rightitem
- (void)setupRightItem {
    // 创建一个自定义的button
    UIButton *newsRightBtn = [[UIButton alloc] init];
//    newsRightBtn.backgroundColor = [UIColor colorWithRed:250.0/256 green:250.0/256 blue:250.0/256 alpha:0.5];
    [newsRightBtn setImage:[UIImage imageNamed:@"icotitlebar_personal_v5"] forState:UIControlStateNormal];
    [newsRightBtn setImage:[UIImage imageNamed:@"icotitlebar_putaway_v5"] forState:UIControlStateSelected];
    newsRightBtn.frame = CGRectMake(0, 0, 40, 40);
    [newsRightBtn addTarget:self action:@selector(newsTitleRightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    newsRightBtn.adjustsImageWhenHighlighted = NO;
    // 创建两个item并且一个是UIBarButtonSystemItemFixedSpace用来改善离屏幕的距离
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:newsRightBtn];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -15;
    // 添加
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:spacer,rightItem, nil];
    
    
}

// 设置顶部滚动条
- (void)setupTitleScrollView {
    
    YTNewsTitleView *view = [[YTNewsTitleView alloc] init];
    view.delegate = self;
    view.frame = CGRectMake(0, 0, YTScreenSize.width - 35, YTNewsTitleBtnH);
    JLog(@"%@",NSStringFromCGRect(view.frame));
    self.newsTitleView = view;
    [self.navigationController.navigationBar addSubview:view];
    
}

// 初始化界面基本设置
- (void)setupBasicOperation {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 设置item的size
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.itemSize = self.collectionView.size;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    // 设置scrollview的特性
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // 设置重用机制
    [self.collectionView registerClass:[YTCollectionViewCell class] forCellWithReuseIdentifier:YTCellReuseIdentifierID];
}

#pragma mark - 监听方法
- (void)newsTitleRightBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.newsTitleView.userInteractionEnabled = !btn.selected;
    if (btn.selected) {
        self.addTitleView.ownTitle = [NSMutableArray arrayWithArray:self.newsTitleView.userNewsTitleModels];
        self.addTitleView.enableAddTitle = [NSMutableArray arrayWithArray:self.newsTitleView.userNewsTitleEnableModels];
        self.addTitleView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.addTitleView.y = 64;
        }];

    } else {
        [self.newsTitleView updateNewsTitleWithItems:self.addTitleView.ownTitle];
        [self.newsTitleView updateDataBaseWithOwnTitle:self.addTitleView.ownTitle andEnableTitle:self.addTitleView.enableAddTitle];
        [UIView animateWithDuration:0.5 animations:^{
            self.addTitleView.y = 0 - YTScreenSize.height;
        }completion:^(BOOL finished) {
            self.addTitleView.hidden = YES;
        }];
    }

    
}

#pragma mark - 通知方法
- (void)shareNewsNotification:(NSNotification *)noti {
    NSString *info = noti.userInfo[YTNewsShareKey];
    //注意：分享到微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈、Facebook、Twitter、Instagram等平台需要参考各自的集成方法
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"564e8a26e0f55aaf2b00000f"
                                      shareText:info
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToRenren,UMShareToTencent,UMShareToFacebook,nil]
                                       delegate:self];

}


#pragma mark - YTNewsTitleDelegate 代理方法
- (void)newsTitleView:(YTNewsTitleView *)titleView DidClickedButton:(YTNewsTitleButton *)titleBtn {
    JLog(@"%@",titleBtn);
    // 0.
    // 1.切换collection的item
    CGPoint offset = CGPointMake(YTScreenSize.width * titleBtn.tag, 0);
    [self.collectionView setContentOffset:offset animated:NO];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:titleBtn.tag inSection:0];
    // 刷新数据
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)newsTitleViewDidFinishFirstLoad:(YTNewsTitleView *)titleView {
    [self.collectionView reloadData];
}

- (void)newsTitleViewDidUpdataNewsTitles:(YTNewsTitleView *)titleView {
    [self.collectionView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.newsTitleView updateFeedBack];
    });
    
    
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.newsTitleView.userNewsTitleModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JLog(@"cellForItemAtIndexPath%zd",indexPath.row);
    // 1.
    YTCollectionViewCell *cell = [YTCollectionViewCell cellWithCollectionView:collectionView andIndexPath:indexPath];
    // 1.1设置代理
    cell.delegate = self;
    // 2.传递模型
    cell.newsTopicItem = self.newsTitleView.userNewsTitleModels[indexPath.row];
    // 3.返回
    return cell;
}

#pragma mark <UICollectionViewDelegate> 代理方法
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    JLog(@"willDisplayCell%zd",indexPath.row);
    self.selectedCellIndex = indexPath.row;
}


#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    JLog(@"scrollViewDidEndScrollingAnimation");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    JLog(@"%@",[scrollView class]);
    if (![scrollView isKindOfClass:[UICollectionView class]]) return;
    JLog(@"scrollViewDidEndDecelerating");
    // 判断应该选择哪个标题
    JLog(@"scrollViewDidScroll%@",NSStringFromCGPoint(self.collectionView.contentOffset));
    NSUInteger index = (self.collectionView.contentOffset.x + YTScreenSize.width * 0.5) / YTScreenSize.width;
    JLog(@"index%zd",index);
    [self.newsTitleView didclickedNewsButtonAtIndex:index];
}
#pragma mark -其他方法
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    [YTNotificationCenter removeObserver:self];
}


@end
