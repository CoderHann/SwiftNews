//
//  YTTabBarViewController.m
//  SwiftNews
//
//  Created by roki on 15/11/6.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTTabBarViewController.h"
#import "YTNewsController.h"
#import "YTNavigationController.h"
#import "YTReadingController.h"
#import "YTSeeHearController.h"
#import "YTProfileViewController.h"

@interface YTTabBarViewController ()

@end

@implementation YTTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
//    
//    // 添加子控制器
//    YTNewsController *news = [[YTNewsController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
//    [self addChildViewController:news WithTitle:@"新闻" normalImage:@"tabbar_icon_news_normal" andSelected:@"tabbar_icon_news_highlight"];
//    YTReadingController *reading = [[YTReadingController alloc] init];
//    [self addChildViewController:reading WithTitle:@"阅读" normalImage:@"tabbar_icon_reader_normal" andSelected:@"tabbar_icon_reader_highlight"];
//    YTSeeHearController *seeHear = [[YTSeeHearController alloc] init];
//    [self addChildViewController:seeHear WithTitle:@"视听" normalImage:@"tabbar_icon_media_normal" andSelected:@"tabbar_icon_media_highlight"];
//    YTProfileViewController *profile = [[YTProfileViewController alloc] init];
//    [self addChildViewController:profile WithTitle:@"我" normalImage:@"tabbar_icon_me_normal" andSelected:@"tabbar_icon_me_highlight"];
    
    
    // 添加子控制器
    YTNewsController *news = [[YTNewsController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    [self addChildViewController:news WithTitle:@"新闻" normalImage:@"tabbar_icon_home" andSelected:@"tabbar_icon_home_selected"];
    YTReadingController *reading = [[YTReadingController alloc] init];
    [self addChildViewController:reading WithTitle:@"阅读" normalImage:@"tabbar_icon_read" andSelected:@"tabbar_icon_read_selected"];
    YTSeeHearController *seeHear = [[YTSeeHearController alloc] init];
    [self addChildViewController:seeHear WithTitle:@"视听" normalImage:@"tabbar_icon_video" andSelected:@"tabbar_icon_video_selected"];
    YTProfileViewController *profile = [[YTProfileViewController alloc] init];
    [self addChildViewController:profile WithTitle:@"我" normalImage:@"tabbar_icon_profile" andSelected:@"tabbar_icon_profile_selected"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addChildViewController:(UIViewController *)childController WithTitle:(NSString *)title normalImage:(NSString *)normal andSelected:(NSString *)selected {
    // 设置tabbar的标题
    childController.tabBarItem.title = title;
    
    // 设置tabbar的普通图片
    [childController.tabBarItem setImage:[UIImage imageNamed:normal]];
    
    // 设置tabbar的高亮图片
    [childController.tabBarItem setSelectedImage:[[UIImage imageNamed:selected] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    // 设置普通状态下的字体属性
    NSMutableDictionary *normalAttr = [NSMutableDictionary dictionary];
    normalAttr[NSForegroundColorAttributeName] = [UIColor grayColor];
    [childController.tabBarItem setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    // selected
    NSMutableDictionary *selectedAttr = [NSMutableDictionary dictionary];
    selectedAttr[NSForegroundColorAttributeName] = [UIColor redColor];
    [childController.tabBarItem setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
    
    // 使用导航栏包装好装入tabbar
    YTNavigationController *nav = [[YTNavigationController alloc] initWithRootViewController:childController];
    [self addChildViewController:nav];
}

@end
