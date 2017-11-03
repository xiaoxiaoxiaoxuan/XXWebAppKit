//
//  XXWebViewController.m
//  ISWebViewFramework
//
//  Created by 王笑璇 on 2017/10/31.
//  Copyright © 2017年 wangxiaoxuan. All rights reserved.
//

#import "XXWebViewController.h"
#import "XXProgressView.h"
#import "WebErrorView.h"
#import "DocumentBrowserController.h"
#import "MJRefresh/MJRefresh.h"


@interface XXWebViewController ()<WKScriptMessageHandler, WKNavigationDelegate, UIScrollViewDelegate, UINavigationControllerDelegate, WKUIDelegate>

@property (assign, nonatomic) UIStatusBarStyle h5StatusBarStyle;

@end

@implementation XXWebViewController

- (XXWebView *)webView {
    if (!_webView) {
        _webView = [[XXWebView alloc] initWithFrame:self.view.bounds containerController:self];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownToRefreshPage)];
        header.lastUpdatedTimeLabel.hidden = YES;
        _webView.scrollView.mj_header = header;
        // 一开始禁用
        //        _webView.scrollView.mj_header.hidden = YES;
        //        _webView.scrollView.alwaysBounceVertical = NO;
        _webView.allowsBackForwardNavigationGestures = YES;
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)setURLString:(NSString *)URLString {
    if (URLString) {
        _URLString = URLString;
        [self loadSpecificURL:URLString];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:self.hide_nav animated:animated];
    if (self.hide_nav || [[UIApplication sharedApplication].delegate.window.rootViewController isKindOfClass:[self class]]) {
        if (@available(iOS 11.0, *)) {
            CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
            [[UIApplication sharedApplication].delegate window].rootViewController.additionalSafeAreaInsets = UIEdgeInsetsMake(-statusHeight, 0, 0, 0);
        } else {
            self.automaticallyAdjustsScrollViewInsets = !self.hide_nav;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView setUserScriptWithCookie:[UserAuthorization cookie]];
    [self addScriptUseOCMethods];
    // Do any additional setup after loading the view.
}

- (void)addScriptUseOCMethods {

}

- (void)setScriptMethod:(NSString *)method {
    [self.webView setScriptMessageWithName:method];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.h5StatusBarStyle;
}
- (void)setH5StatusBarStyle:(UIStatusBarStyle)h5StatusBarStyle {
    _h5StatusBarStyle = h5StatusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)pullDownToRefreshPage {
    [self.webView reload];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView.scrollView.mj_header endRefreshing];
    });
}

- (void)loadSpecificURL:(NSString *)urlString {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

- (void)loadHomePage {
    [self loadSpecificURL:self.URLString];

}


/**
 加载本地 HTML 文件
 @param name 文件名
 @param extension 扩展名
 @param subdirectory 文件夹
 */
- (void)loadLocationHTMLWithName:(NSString *)name andExtension:(NSString *)extension subdirectory:(NSString *)subdirectory {
    NSURL *filePath = [[NSBundle mainBundle] URLForResource:name withExtension:extension subdirectory:subdirectory];
    NSURLRequest *request = [NSURLRequest requestWithURL:filePath];
    [self.webView loadRequest:request];
}



#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    NSURLCredential *cred = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, cred);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"URL - %@", navigationAction.request.URL);
    
    NSURL *URL = navigationAction.request.URL;
    if ([self canResponseSystemActionURL:navigationAction.request.URL]) {
        decisionHandler(WKNavigationActionPolicyCancel);return;
    }
    if ([URL.absoluteString hasSuffix:@".pdf"]) {
        DocumentBrowserController *browser = [[DocumentBrowserController alloc] init];
        browser.documentURL = URL;
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:browser] animated:YES completion:nil];
        decisionHandler(WKNavigationActionPolicyCancel);return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
//    if (_needJumpToLogin) {
//        _needJumpToLogin = NO;
//        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[Tools AUTH_URL]]]];
//        return;
//    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    WebErrorView *errorView = [WebErrorView viewWithError:error];
    errorView.frame = webView.frame;
    errorView.ErrorViewTapBlock = ^{
        [self loadHomePage];
        self.h5StatusBarStyle = UIStatusBarStyleLightContent;
    };
    [webView addSubview:errorView];
    self.h5StatusBarStyle = UIStatusBarStyleDefault;
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"%s", __FUNCTION__);
}

- (BOOL)canResponseSystemActionURL:(NSURL *)URL {
    if ([URL.scheme isEqualToString:@"tel"]) {
        if ([[UIApplication sharedApplication] canOpenURL:URL]) {
            [[UIApplication sharedApplication] openURL:URL];
            return YES;
        }
    }
    return NO;
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {

}

#pragma mark - WKScriptMessageHandler 自定义交互
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%@ - %@", message.name, message.body);
    /*
     UIViewController *test = [UIViewController new];
     test.view.backgroundColor = [UIColor whiteColor];
     [self.navigationController pushViewController:test animated:YES];
     return;
     */
    // 方法名:message.name 方法参数:message.bod
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:", message.name]);
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector withObject:message.body];
    }
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
