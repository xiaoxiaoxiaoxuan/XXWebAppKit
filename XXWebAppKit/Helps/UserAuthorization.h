//
//  UserAuthorization.h
//  iSee
//
//  Created by Xiangyang on 2017/9/25.
//  Copyright © 2017年 itouzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAuthorization : NSObject

+ (BOOL)hasLogin;                       // 是否登录
+ (NSString *)userID;                   // 用户id
+ (NSString *)userToken;                // 用户token
+ (void)setCookie:(NSString *)cookie;   // 设置cookie
+ (NSString *)cookie;                   // cookie
+ (void)setPhoneNum:(NSString *)phoneNum; // 手机号保存本地
+ (NSString *)phoneNum;                 // phoneNum
+ (void)cleanUserInfo;                  // 退出登录清空用户相关信息，手势密码、uuid、cookie等

@end

@interface UserAccount : NSObject

+ (instancetype)sharedAccount;

@end
