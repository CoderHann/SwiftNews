//
//  YTNavigationController.m
//  SwiftNews
//
//  Created by roki on 15/11/6.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTNavigationController.h"

@interface YTNavigationController ()

@end

@implementation YTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
//    int i= 0;
//    for(UIView *view in self.navigationBar.subviews) {
//        view.userInteractionEnabled = YES;
//        JLog(@"%d,%@",i++,view);
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    if (self.viewControllers.count > 1) {
        self.tabBarController.tabBar.hidden = YES;
        
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    UIViewController *VC = [super popViewControllerAnimated:animated];
    if (self.viewControllers.count == 1) {
        self.tabBarController.tabBar.hidden = NO;
        
    }
    return VC;
}
@end
