//
//  PasswordVerifyManager.h
//  iSee
//
//  Created by Xiangyang on 2017/9/27.
//  Copyright © 2017年 itouzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PasswordVerifyManager : NSObject

+ (instancetype)sharedManger;

- (void)handleGesturePasswordViewController;

- (void)showPasswordVerifyViewController;

@property (nonatomic, assign) BOOL isOpenGesture; // 项目是否开启手势解锁
@property (strong, nonatomic) NSDate *lastResignTime;       // 上次锁屏或进入后台时间
@property (assign, nonatomic) BOOL hasLogin;
@property (nonatomic, assign) NSInteger seconds_between; // 进入后台多久，下次进来需要解锁，默认60秒


@end
