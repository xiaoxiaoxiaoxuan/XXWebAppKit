//
//  XXWebViewController.h
//  ISWebViewFramework
//
//  Created by 王笑璇 on 2017/10/31.
//  Copyright © 2017年 wangxiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXWebView.h"
#import "MJRefresh.h"
#import "UserAuthorization.h"
#import "PasswordVerifyManager.h"
#import "XXWebViewHeader.h"
#import "Tools.h"

@interface XXWebViewController : UIViewController

@property (strong, nonatomic) XXWebView *webView;
@property (copy, nonatomic) NSString *URLString;
@property (assign, nonatomic) BOOL hide_nav;

/**
 * 点击通知加载推送中的url
 * @param urlString url链接
 */
- (void)loadSpecificURL:(NSString *)urlString;

/**
 * 点击加载主页
 */
- (void)loadHomePage;

/**
 * 设置状态栏字体颜色
 * @param h5StatusBarStyle UIStatusBarStyle
 */
- (void)setH5StatusBarStyle:(UIStatusBarStyle)h5StatusBarStyle;

/**
 * 添加自定义 JS 交互方法
 */
- (void)addScriptUseOCMethods;

/**
 加载本地 HTML 文件
 @param name 文件名
 @param extension 扩展名
 @param subdirectory 文件夹
 */
- (void)loadLocationHTMLWithName:(NSString *)name andExtension:(NSString *)extension subdirectory:(NSString *)subdirectory;

@end
