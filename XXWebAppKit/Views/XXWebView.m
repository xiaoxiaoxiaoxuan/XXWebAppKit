//
//  XXWebView.m
//  ISWebViewFramework
//
//  Created by 王笑璇 on 2017/10/31.
//  Copyright © 2017年 wangxiaoxuan. All rights reserved.
//

#import "XXWebView.h"

@implementation ISeeWebKitSupport

+ (instancetype)sharedSupport {
    static ISeeWebKitSupport *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [ISeeWebKitSupport new];
    });
    return  _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _processPool = [WKProcessPool new];
    }
    return self;
}

@end

#pragma mark - ISeeWebView
@interface XXWebView ()

@property (strong, nonatomic) UIViewController *contaierVc;

@end

@implementation XXWebView

- (void)setUserScriptWithCookie:(NSString *)cookie {
    NSString *source = [NSString stringWithFormat:@"document.cookie = '%@';", cookie ?: @""];
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:source
                                                      injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                   forMainFrameOnly:NO];
    [self.configuration.userContentController removeAllUserScripts];
    [self.configuration.userContentController addUserScript:userScript];
}

- (void)setScriptMessageWithName:(NSString *)name {
    id<WKScriptMessageHandler> vc = (id)self.contaierVc;
    [self.configuration.userContentController addScriptMessageHandler:vc name:name];
}

- (instancetype)initWithFrame:(CGRect)frame containerController:(UIViewController *)viewController {
    NSLog(@"%@", viewController);
    WKUserContentController *userContent = [[WKUserContentController alloc] init];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = userContent;
    config.processPool = [ISeeWebKitSupport sharedSupport].processPool;
    
    self = [super initWithFrame:frame configuration:config];
    if (self) {
        self.contaierVc = viewController;
        
    }
    return self;
}

@end
