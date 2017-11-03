//
//  PasswordVerifyManager.m
//  iSee
//
//  Created by Xiangyang on 2017/9/27.
//  Copyright © 2017年 itouzi. All rights reserved.
//

#import "PasswordVerifyManager.h"
#import <UIKit/UIKit.h>
#import "XXWebViewHeader.h"
#import "UserAuthorization.h"
#import "GesturePasswordViewController.h"

@implementation PasswordVerifyManager


+ (instancetype)sharedManger {
    static PasswordVerifyManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PasswordVerifyManager alloc] init];
        manager.seconds_between = 60; // 默认60秒
        [[NSNotificationCenter defaultCenter] addObserver:manager selector:@selector(showPasswordVerifyViewController) name:LoginSucessNotification object:nil];
    });
    return manager;
}

- (void)handleGesturePasswordViewController {
    // 是否需要展示手势密码
    if ([PasswordVerifyManager sharedManger].needShowGesturePassword) {
        UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
        while (rootVC.presentedViewController) {
            rootVC = rootVC.presentedViewController;
        }
        // 如果手势密码未展示，则展示
        if (![rootVC isKindOfClass:[GesturePasswordViewController class]]) {
            [self showPasswordVerifyViewController];
        }
    }
}

- (BOOL)needShowGesturePassword {
    BOOL hasLogin = [UserAuthorization hasLogin];
    // 未登录
    if (!hasLogin) {
        return NO;
    }
    
    // 是否已跳过手势密码
    NSString *skip = [[NSUserDefaults standardUserDefaults] objectForKey:SkipGesturePwdSettingKey];
    if (skip) {
        return NO;
    }
    
    // 第一次展示
    if (!self.lastResignTime) {
        return YES;
    }
    
    // 间隔时间超过60s
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.lastResignTime];
    if (interval > self.seconds_between) {
        return YES;
    }
    return NO;
}

#pragma mark ---- 手势解锁
- (void)showPasswordVerifyViewController {
    if (!self.isOpenGesture) {
        return ;
    }
    
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:GesturePasswordStoreKey];
    if (password && password.length && [password hasPrefix:GesturePasswordPrefix]) {
        // 已设置，验证密码
        GesturePasswordViewController *vc = [GesturePasswordViewController showVerifyLockVCInVC:[[UIApplication sharedApplication].delegate.window rootViewController]
                                                                                 forgetPwdBlock:^{
                                                                                     NSLog(@"忘记密码");
                                                                                     [UserAuthorization cleanUserInfo];
                                                                                 } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                                                                                     NSLog(@"密码正确");
                                                                                     [lockVC dismiss:1.0f];
                                                                                 }];
        vc.phoneLabelText = [UserAuthorization phoneNum];
        return;
    } else {
        // 未设置，设置密码
        GesturePasswordViewController *vc = [GesturePasswordViewController showSettingLockVCInVC:[[UIApplication sharedApplication].delegate.window rootViewController]
                                                                                    successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                                                                                        NSLog(@"密码设置成功");
                                                                                        pwd = [NSString stringWithFormat:@"%@%@", GesturePasswordPrefix, pwd];
                                                                                        [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:GesturePasswordStoreKey];
                                                                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                        [lockVC dismiss:1.0f];
                                                                                    } skipBlock:^{
                                                                                        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:SkipGesturePwdSettingKey];
                                                                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                    }];
        vc.phoneLabelText = [UserAuthorization phoneNum];
        return;
    }
}


@end
