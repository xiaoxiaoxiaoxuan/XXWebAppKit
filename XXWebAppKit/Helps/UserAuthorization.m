//
//  UserAuthorization.m
//  iSee
//
//  Created by Xiangyang on 2017/9/25.
//  Copyright © 2017年 itouzi. All rights reserved.
//

#import "UserAuthorization.h"
#import "XXWebViewHeader.h"
#import "Tools.h"
//#import "MainViewController+JSBridgeMethod.h"

@implementation UserAuthorization

+ (BOOL)hasLogin {
    if ([UserAuthorization cookie].length) {
        return YES;
    }
    return NO;
}

+ (NSString *)userID {
    return @"userid";
}


+ (NSString *)userToken {
    return @"userToken";
}

+ (void)setCookie:(NSString *)cookie {
    NSData *cookieData = [cookie dataUsingEncoding:NSUTF8StringEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:cookieData forKey:SyncronizeLoginCookie];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)cookie {
    NSData *cookieData = [[NSUserDefaults standardUserDefaults] objectForKey:SyncronizeLoginCookie];
    if (cookieData) {
        NSString *cookie = [[NSString alloc] initWithData:cookieData encoding:NSUTF8StringEncoding];
        if (cookie && cookie.length) {
            return cookie;
        }
    }
    return nil;
}

+ (void)setPhoneNum:(NSString *)phoneNum {
    [[NSUserDefaults standardUserDefaults] setObject:phoneNum forKey:@"phoneNum"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)phoneNum {
    NSString *phoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNum"];
    return phoneNum ?: @"";
}

+ (void)cleanUserInfo {
    // 清理 WKWebView 缓存
    [Tools clearCache];
    // 移除手势密码
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GestureOrSingerPasswordStoreKey];
    // 移除用户uuid,即登录凭证
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phoneNum"];
    // 跳过手势密码key
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SkipGesturePwdSettingKey];
    // 移除cookie
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SyncronizeLoginCookie];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end


@implementation UserAccount

+ (instancetype)sharedAccount {
    static UserAccount *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserAccount alloc] init];
    });
    return instance;
}

@end
