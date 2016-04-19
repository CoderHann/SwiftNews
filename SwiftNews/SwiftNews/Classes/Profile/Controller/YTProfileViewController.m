//
//  YTProfileViewController.m
//  SwiftNews
//
//  Created by roki on 15/11/6.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTProfileViewController.h"

@interface YTProfileViewController ()

@end

@implementation YTProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 中间标题
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor redColor];
    titleLabel.text =@"我";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.size = [titleLabel.text sizeWithMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) withTextFont:titleLabel.font];
    self.navigationItem.titleView = titleLabel;
    
    UILabel *tint = [[UILabel alloc] init];
//    tint.backgroundColor = [UIColor blackColor];
    tint.centerY = self.view.centerY;
    tint.x = (YTScreenSize.width - 300) * 0.5;
    tint.size = CGSizeMake(300, 50);
    tint.text = @"该栏目将会在下次更新时展现，敬请期待！";
    tint.textAlignment = NSTextAlignmentCenter;
    tint.textColor = [UIColor grayColor];
    tint.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:tint];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
