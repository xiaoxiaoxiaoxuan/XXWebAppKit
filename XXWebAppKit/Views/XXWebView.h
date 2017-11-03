//
//  XXWebView.h
//  ISWebViewFramework
//
//  Created by 王笑璇 on 2017/10/31.
//  Copyright © 2017年 wangxiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ISeeWebKitSupport : NSObject

+ (instancetype)sharedSupport;
@property (nonatomic, strong,readonly) WKProcessPool *processPool;  // 多个 WKWebView 之间共享cookie

@end

@interface XXWebView : WKWebView

- (instancetype)initWithFrame:(CGRect)frame containerController:(UIViewController *)viewController;

- (void)setUserScriptWithCookie:(NSString *)cookie;

- (void)setScriptMessageWithName:(NSString *)name;

@end
