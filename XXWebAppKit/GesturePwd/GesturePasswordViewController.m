//
//  GesturePasswordViewController.m
//  iSee
//
//  Created by Xiangyang on 2017/9/25.
//  Copyright © 2017年 itouzi. All rights reserved.
//

#import "GesturePasswordViewController.h"
#import "PasswordVerifyManager.h"
#import "UserAuthorization.h"

@interface GesturePasswordViewController ()

@end

@implementation GesturePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 记录当前时间
    [PasswordVerifyManager sharedManger].lastResignTime = [NSDate date];
}


@end
