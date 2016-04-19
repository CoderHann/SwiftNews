//
//  YTNewsTitleView.m
//  SwiftNews
//
//  Created by roki on 15/11/6.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTNewsTitleView.h"
#import "YTNewsTitleButton.h"
#import "AFNetworking.h"
#import "YTNewsTopicItem.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "YTNetRequestTool.h"
#import "YTRequestURLTool.h"
#define YTUserTitleTopicPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userTitleTopicPath.archive"]
#define YTUserEnableAddTitleTopicPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userTitleTopicEnableTopic.archive"]
#define YTLineUnderDistance 5

@interface YTNewsTitleView()<UIAlertViewDelegate>
/** 存放可以添加的标题模型*/
@property(nonatomic,strong) NSArray *enableAddNewsTopic;
/** 存放用户的标题模型*/
@property(nonatomic,strong) NSArray *newsBtnItem;
/** 选择的标题按钮*/
@property(nonatomic,weak) YTNewsTitleButton *selectedBtn;
/** 所有添加的的标题按钮*/
@property(nonatomic,strong) NSMutableArray *allUserAddBtn;
/** 下划线*/
@property(nonatomic,weak) UIView *underLine;
@property(nonatomic,assign) CGFloat lastSelectTitleBtnX;
@end

@implementation YTNewsTitleView
@synthesize newsBtnItem = _newsBtnItem;
@dynamic delegate;
#pragma mark - 懒加载
- (NSMutableArray *)allUserAddBtn {
    if (!_allUserAddBtn) {
        _allUserAddBtn = [[NSMutableArray alloc] init];
    }
    return _allUserAddBtn;
}
- (NSArray *)newsBtnItem {
    if (!_newsBtnItem) {
        _newsBtnItem = [[NSArray alloc] init];
    }
    return _newsBtnItem;
}

- (NSArray *)enableAddNewsTopic {
    if (!_enableAddNewsTopic) {
        _enableAddNewsTopic = [NSKeyedUnarchiver unarchiveObjectWithFile:YTUserEnableAddTitleTopicPath];
    }
    return _enableAddNewsTopic;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;

        // 发送网络请求获得新闻的topic
        [self loadTopicTitle];
        
        // 添加下划线
        [self addUnderLine];
    }
    return self;
}
/** 添加下划线*/
- (void)addUnderLine {
    UIView *view = [[UIView alloc] init];
    view.size = CGSizeMake(30, 2);
    view.centerX = YTNewsTitleBtnW * 0.5;
    view.y = YTNewsTitleBtnH - YTLineUnderDistance;
    view.backgroundColor = [UIColor redColor];
    self.underLine = view;
    [self addSubview:view];
}

/** 加载标题*/
- (void)loadTopicTitle {
    
    // 读取文件看看是否用户第一次打开文件
    NSArray *userTitleTopic = [NSKeyedUnarchiver unarchiveObjectWithFile:YTUserTitleTopicPath];
    
    // 判断
    if (userTitleTopic.count == 0) { // 没有打开过程序，需要默认的
        
        [MBProgressHUD showMessage:@"正在加载..." toView:[[UIApplication sharedApplication].windows firstObject]];
        // 网络加载标题
        [self getTopicTitle];
    }else { // 直接加载用户的设置
        self.newsBtnItem = userTitleTopic;
        
    }
}

/** 更新标题栏*/
- (void)updateNewsTitleWithItems:(NSArray *)items {
    [self setNewsBtnItem:items];
}

/** 更新反馈,当标题更改tableview刷新完数据后回调*/
- (void)updateFeedBack {
    [self clickedNewsBtn:[self.allUserAddBtn firstObject] byScrollView:NO];
}

/** 更新本地数据*/
- (void)updateDataBaseWithOwnTitle:(NSMutableArray *)own andEnableTitle:(NSMutableArray *)enable {
    self.enableAddNewsTopic = enable;
    // 归档
    // 把用户数据存储起来
    [NSKeyedArchiver archiveRootObject:self.newsBtnItem toFile:YTUserTitleTopicPath];
    
    // 将未添加的也存起来
    [NSKeyedArchiver archiveRootObject:self.enableAddNewsTopic toFile:YTUserEnableAddTitleTopicPath];
}
// 从写newsBtnItem的Set方法
- (void)setNewsBtnItem:(NSArray *)newsBtnItem {
    // 清空
    for (YTNewsTitleButton *btn in self.allUserAddBtn) {
        [btn removeFromSuperview];
    }
    [self.allUserAddBtn removeAllObjects];
    
    
    _newsBtnItem = newsBtnItem;
    // 根据count需要设置自己的contentsize
    NSUInteger count = newsBtnItem.count;
    self.contentSize = CGSizeMake(count * YTNewsTitleBtnW, YTNewsTitleBtnH);
    // 添加allUserAddBtn和子控件
    for (NSUInteger i = 0; i < count; i++) {
        YTNewsTitleButton *newsBtn = [[YTNewsTitleButton alloc] init];
        //        label.backgroundColor = YTRandomColor;
        newsBtn.topic = newsBtnItem[i];
        [newsBtn addTarget:self action:@selector(clickedNewsBtn:byScrollView:) forControlEvents:UIControlEventTouchUpInside];
        // 绑定tag设置collection的item
        newsBtn.tag = i;
        if (i == 0) {
            newsBtn.selected = YES;
            self.selectedBtn = newsBtn;
        }
        [self.allUserAddBtn addObject:newsBtn];
        [self addSubview:newsBtn];
        
    }
    // 告诉代理更新标题完成，需要进行刷新列表
    if ([self.delegate respondsToSelector:@selector(newsTitleViewDidUpdataNewsTitles:)]) {
        [self.delegate newsTitleViewDidUpdataNewsTitles:self];
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    JLog(@"layoutSubviews%zd",self.subviews.count);
    for (NSUInteger i = 0; i < self.allUserAddBtn.count; i++) {
        YTNewsTitleButton *btn = self.allUserAddBtn[i];
        btn.size = CGSizeMake(YTNewsTitleBtnW , YTNewsTitleBtnH);
        btn.y = 2;
        btn.x = btn.width * i;
    }
}
#pragma mark - 监听方法
/** 点击了btn*/
- (void)clickedNewsBtn:(YTNewsTitleButton *)btn byScrollView:(BOOL)isScroll{

    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
    // 设置下划线的frame
    [self changeUnderLineByBtn:btn];
    JLog(@"btn%@",NSStringFromCGRect(btn.frame));
    if (!isScroll) { // 如果不是滚动的就调用下面的
        // 告诉代理按钮被点了
        if ([self.delegate respondsToSelector:@selector(newsTitleView:DidClickedButton:)]) {
            [self.delegate newsTitleView:self DidClickedButton:btn];
        }
    }
    
    JLog(@"点击了%@",btn.titleLabel.text);
    
}
/** 点击了第index个按钮*/
- (void)didclickedNewsButtonAtIndex:(NSUInteger)index {
    [self clickedNewsBtn:self.allUserAddBtn[index] byScrollView:YES];
}
/** 当点了其他按钮将下划线放到合适位置*/
- (void)changeUnderLineByBtn:(YTNewsTitleButton *)btn {
    JLog(@"titleViewOffset%@",NSStringFromCGPoint(self.contentOffset));
    JLog(@"titleViewOffset%@",NSStringFromCGRect(btn.frame));
    CGFloat btnX = btn.x;
    CGPoint offset = self.contentOffset;
    CGFloat width = self.width;
    CGFloat result = btnX - offset.x;
    
    if (result < 0) {
        offset.x += result;
//        self.contentOffset = offset;
    } else if (result > width) {
        offset.x += result;
//        self.contentOffset = offset;
    }
    self.lastSelectTitleBtnX = btnX;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentOffset = offset;
        CGFloat width = [btn.topic.tname sizeWithMaxSize:CGSizeMake(100, 0) withTextFont:btn.titleLabel.font].width;
        //        self.underLine.x = btn.x + (btn.width - width) * 0.5;
        //        self.underLine.y = btn.height - YTLineUnderDistance;
        //        self.underLine.width = width;
        self.underLine.width = width;
        self.underLine.y = btn.height - YTLineUnderDistance;
        self.underLine.centerX = btn.centerX;
    }];

}
// 用户所有有标题对象
- (NSArray *)userNewsTitleModels {
    return self.newsBtnItem;
}
// 用户所有的可以添加的标题模型
- (NSArray *)userNewsTitleEnableModels {
    return self.enableAddNewsTopic;
}
/** 发送网络请求获得新闻的topic*/
- (void)getTopicTitle {
    JLog(@"getTopicTitle");
//    // manager
//    AFHTTPRequestOperationManager *mg = [AFHTTPRequestOperationManager manager];
    
    // 请求参数
    NSString *urlStr = [YTRequestURLTool requestURLForTopics];
    [YTNetRequestTool GET:urlStr withParameters:nil success:^(NSDictionary *json) {
        JLog(@"success");
        NSArray *topicArray = json[@"tList"];
        // 获取默认的话题在plist中
        NSString *path = [[NSBundle mainBundle] pathForResource:@"topic.plist" ofType:nil];
        NSArray *needTopics = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *topics = [NSMutableArray array];
        for (NSString *topic in needTopics) {
            for (NSDictionary *netTopic in topicArray) {
                
                if ([topic isEqualToString:netTopic[@"tname"]]) {
                    [topics addObject:[YTNewsTopicItem objectWithKeyValues:netTopic]];
                    break;
                }
            }
        }
        
        // 没有打开过程序，需要默认的
        self.newsBtnItem = [topics subarrayWithRange:NSMakeRange(0, 12)];
        // 获得的总话题放入enableAddNewsTopic
        self.enableAddNewsTopic = [topics subarrayWithRange:NSMakeRange(12, topics.count - 12)];
        // 把用户数据存储起来
        [NSKeyedArchiver archiveRootObject:self.newsBtnItem toFile:YTUserTitleTopicPath];
        
        // 将未添加的也存起来
        [NSKeyedArchiver archiveRootObject:self.enableAddNewsTopic toFile:YTUserEnableAddTitleTopicPath];
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows firstObject]];
        [MBProgressHUD showSuccess:@""];
        if ([self.delegate respondsToSelector:@selector(newsTitleViewDidFinishFirstLoad:)]) {
            [self.delegate newsTitleViewDidFinishFirstLoad:self];
        }
        
    } error:^(NSError *error) {
        JLog(@"error%@",error);
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows firstObject]];
        [MBProgressHUD showError:@"网络不给力..."];
        
        // 处理错误
        [self dealError];
    }];
    
}
- (void)dealError {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络太不给力了，是否要重试？" message:@"123456" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
    [alert show];
    
}

#pragma mark - uialertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        
        [self loadTopicTitle];
    }
}
// 首次加载进行同步请求初始化
- (void)getTopicTitle2 {
    
    // 1.获得url
    NSURL *getTopicUrl = [NSURL URLWithString:@"http://c.3g.163.com/nc/topicset/ios/subscribe/manage/listspecial.html"];
    
    // 2.设置请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:getTopicUrl];
    
    // 3.利用nsurlconnection发送请求
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) { // 请求出错
        JLog(@"error");
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow];
        [MBProgressHUD showError:@"网络不给力..."];
    }else { // 成功请求
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSArray *topicArray = responseObject[@"tList"];
        // 获取默认的话题在plist中
        NSString *path = [[NSBundle mainBundle] pathForResource:@"topic.plist" ofType:nil];
        NSArray *needTopics = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *topics = [NSMutableArray array];
        for (NSString *topic in needTopics) {
            for (NSDictionary *netTopic in topicArray) {
                
                if ([topic isEqualToString:netTopic[@"tname"]]) {
                    [topics addObject:[YTNewsTopicItem objectWithKeyValues:netTopic]];
                    break;
                }
            }
        }
        // 获得的总话题放入enableAddNewsTopic
        self.enableAddNewsTopic = topics;
        // 没有打开过程序，需要默认的
        self.newsBtnItem = [topics subarrayWithRange:NSMakeRange(0, 12)];
        // 把用户数据存储起来
        [NSKeyedArchiver archiveRootObject:self.newsBtnItem toFile:YTUserTitleTopicPath];
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow];
        [MBProgressHUD showSuccess:@""];
        
    }
    
    
    
}

@end
