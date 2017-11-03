//
//  MainViewController.m
//  XXWebAppKitDemo
//
//  Created by 王笑璇 on 2017/11/3.
//  Copyright © 2017年 wangxiaoxuan. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [PasswordVerifyManager sharedManger].isOpenGesture = YES;
    [PasswordVerifyManager sharedManger].seconds_between = 10;
    [self loadLocationHTMLWithName:@"test" andExtension:@"html" subdirectory:@"html"];
    
    // Do any additional setup after loading the view.
}

- (void)addScriptUseOCMethods {
    [super addScriptUseOCMethods];
    
    [self.webView setScriptMessageWithName:@"loginSuccess"]; // 登录成功
    [self.webView setScriptMessageWithName:@"logout"]; // 登出
    [self.webView setScriptMessageWithName:@"setData"]; // 存储
    [self.webView setScriptMessageWithName:@"getData"]; // 读取
    [self.webView setScriptMessageWithName:@"setCookie"]; // 存cookie
    [self.webView setScriptMessageWithName:@"clearCache"]; // 清除本地缓存
}

- (void)loginSuccess:(NSDictionary *)param {
    [PasswordVerifyManager sharedManger].hasLogin = YES;
    [UserAuthorization setPhoneNum:param[@"uuid"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginSucessNotification object:nil];
}

- (void)logout:(NSDictionary *)param {
    [PasswordVerifyManager sharedManger].hasLogin = NO;
    // webView userScript 移除原来的cookie
    [self.webView.configuration.userContentController removeAllUserScripts];
    // 清空用户信息
    [UserAuthorization cleanUserInfo];
    // 发送登出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:LogoutNotification object:nil];
}

- (void)setData:(NSDictionary *)param {
    [[NSUserDefaults standardUserDefaults] setObject:param[@"key"] forKey:param[@"value"]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getData:(NSDictionary *)param {
    return [[NSUserDefaults standardUserDefaults] objectForKey:param[@"key"]];
}

- (void)setCookie:(NSDictionary *)param {
    NSString *cookieKey = param[@"key"];
    NSString *cookieValue = param[@"value"];
    NSString *cookie = [[NSString stringWithFormat:@"%@=%@", cookieKey, cookieValue] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    [UserAuthorization setCookie:cookie];
    
    // 用户登录成功或切换账号了，此时通知 webView 更新 userScript
    NSLog(@"cookie:%@", cookie);
    [self.webView setUserScriptWithCookie:[UserAuthorization cookie]];
}

- (void)setStatusBarStyle:(NSDictionary *)param {
    self.h5StatusBarStyle = [param[@"txtColor"] integerValue] == 0 ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

- (void)share:(NSDictionary *)param {
    
}

- (void)showUmengShare:(NSDictionary *)param {
    
}

- (void)showGesturePwdPage:(NSDictionary *)param {
    
}

- (void)isGesturePwdEnabled:(NSDictionary *)param {
    
}

- (void)clearCache {
    [Tools clearCache];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
