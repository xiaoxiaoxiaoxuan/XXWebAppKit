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
#import "XXFingerViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

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
        if (![rootVC isKindOfClass:[GesturePasswordViewController class]] || ![rootVC isKindOfClass:[XXFingerViewController class]]) {
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

#pragma mark ---- 手势或者指纹解锁
- (void)showPasswordVerifyViewController {
    
    // 是否启用指纹或者手势解锁
    if (!self.isOpenGestureOrSinger) {
        return ;
    }
    
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:GestureOrSingerPasswordStoreKey];

    // 未设置密码
    if (password == nil || password.length == 0) {
        if ([self isSupportFingerPrintWithError:nil] && self.isOpenSinger) {
            
            [self toSingerPageWithType:@""];
        } else {
            
            [self toGesturePageWithType:@""];
        }
        
        return ;
    }
    if ([password hasPrefix:GesturePasswordPrefix]) {
        // 已设置，验证密码
        [self toGesturePageWithType:@"verifyGesture"];
        return ;
    }
    if ([password hasPrefix:SingerPasswordPrefix]) {
        
        [self toSingerPageWithType:@"verifySinger"];
        return ;
    }
    
}

- (void)toGesturePageWithType:(NSString *)type {
    __weak typeof(self) weakSelf = self;
    if ([type isEqualToString:@"verifyGesture"]) {
        // 验证手势密码
        GesturePasswordViewController *vc = [GesturePasswordViewController showVerifyLockVCInVC:[[UIApplication sharedApplication].delegate.window rootViewController]
                                                                                 forgetPwdBlock:^{
                                                                                     NSLog(@"忘记密码");
                                                                                     [weakSelf fogetPwd];
                                                                                 } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                                                                                     NSLog(@"密码正确");
                                                                                     [lockVC dismiss:1.0f];
                                                                                 }];
        vc.phoneLabelText = [UserAuthorization phoneNum];
    } else {
        // 开启手势解锁
        GesturePasswordViewController *vc = [GesturePasswordViewController showSettingLockVCInVC:[[UIApplication sharedApplication].delegate.window rootViewController]
                                                                                    successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                                                                                        NSLog(@"密码设置成功");
                                                                                        [weakSelf setLoginSuccessStautsWithType:GesturePasswordPrefix andPwd:pwd];
                                                                                        [lockVC dismiss:1.0f];
                                                                                    } skipBlock:^{
                                                                                        [weakSelf setSkipStatus];
                                                                                    }];
        vc.phoneLabelText = [UserAuthorization phoneNum];
    }
}

- (void)toSingerPageWithType:(NSString *)type {
    __weak typeof(self) weakSelf = self;
    XXFingerViewController *fingerVC = [[XXFingerViewController alloc] init];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:fingerVC animated:YES completion:nil];
    if ([type isEqualToString:@"verifySinger"]) {
        // 验证指纹
        fingerVC.leftBottomBtn.hidden = YES;
        [fingerVC.rightBottomBtn setTitle:@"忘记密码" forState:(UIControlStateNormal)];
        fingerVC.rightBottomBtnActionBlock = ^(XXFingerViewController *vc){
            [weakSelf fogetPwd];
            [vc dissmissAnimated:YES];
        };
        fingerVC.singerResultBlock = ^(BOOL success, NSError *error, XXFingerViewController *vc) {
            if (success) {
                [vc dissmissAnimated:YES];
            } else {
                NSLog(@"指纹错误 %@", error);
            }
        };
    } else {
        // 开启指纹解锁
        [fingerVC.rightBottomBtn setTitle:@"跳过" forState:(UIControlStateNormal)];
        fingerVC.rightBottomBtnActionBlock = ^(XXFingerViewController *vc){
            [weakSelf setSkipStatus];
            [vc dissmissAnimated:YES];
        };
        fingerVC.singerResultBlock = ^(BOOL success, NSError *error, XXFingerViewController *vc) {
            if (success) {
                NSLog(@"指纹设置成功");
                [weakSelf setLoginSuccessStautsWithType:SingerPasswordPrefix andPwd:@""];
                [vc dissmissAnimated:YES];
            } else {
                NSLog(@"指纹错误 %@", error);
            }
        };
    }
    [fingerVC.leftBottomBtn setTitle:@"使用手势密码" forState:(UIControlStateNormal)];
    fingerVC.leftBottomBtnActionBlock = ^(XXFingerViewController *fingerVC){
        NSLog(@"左下按钮");
        [fingerVC dissmissAnimated:NO];
        [self toGesturePageWithType:@""];
    };
    
    
}

// 设置密码成功，存储密码
- (void)setLoginSuccessStautsWithType:(NSString *)type andPwd:(NSString *)pwd{
    pwd = [NSString stringWithFormat:@"%@%@", type, pwd];
    [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:GestureOrSingerPasswordStoreKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 跳过设置密码
- (void)setSkipStatus {
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:SkipGesturePwdSettingKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 忘记密码
- (void)fogetPwd {
    [UserAuthorization cleanUserInfo];
}

/**
 * 是否支持指纹
 */
- (BOOL)isSupportFingerPrintWithError:(NSError * __autoreleasing *)error {
    // 使用canEvaluatePolicy 判断设备支持状态
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        return NO;
    }
    
    if ([[[LAContext alloc] init] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:error]) {
        return YES;
    }
    
    return NO;
}


@end
