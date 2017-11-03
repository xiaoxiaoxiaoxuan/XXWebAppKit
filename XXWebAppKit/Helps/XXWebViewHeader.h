//
//  XXWebViewHeader.h
//  ISWebViewFramework
//
//  Created by 王笑璇 on 2017/10/31.
//  Copyright © 2017年 wangxiaoxuan. All rights reserved.
//

#ifndef XXWebViewHeader_h
#define XXWebViewHeader_h

// ===========================设备==================================
#define DEVICE_SYSTEM_VERSION           [[[UIDevice currentDevice] systemVersion] floatValue]
// ===========================设备==================================

// ===========================通知==================================
#define LoginSucessNotification         @"LoginSucessNotification"
#define LogoutNotification              @"LogoutNotification"
#define UserCookieUpdateNotification    @"UserCookieUpdateNotification"
#define NeedPasswordVefiryNotification  @"NeedPasswordVefiryNotification"
// ===========================通知==================================

// ==========================KEY===================================
#define SyncronizeLoginCookie           @"SyncronizeLoginCookie"
#define GesturePasswordStoreKey         @"GesturePasswordStoreKey"
#define SkipGesturePwdSettingKey        @"SkipGesturePwdSettingKey"
#define GesturePasswordPrefix           @"GesturePasswordPrefix"
// ==========================KEY===================================

#endif /* XXWebViewHeader_h */
