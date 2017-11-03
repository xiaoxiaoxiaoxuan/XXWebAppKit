//
//  DocumentBrowserController.m
//  iSee
//
//  Created by Xiangyang on 2017/10/12.
//  Copyright © 2017年 itouzi. All rights reserved.
//

#import "DocumentBrowserController.h"
#import <WebKit/WebKit.h>

@interface DocumentBrowserController ()
@property (strong, nonatomic) WKWebView *webView;
@end

@implementation DocumentBrowserController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:self.documentURL]];
    self.webView = webView;
    
//    UIButton *back = [UIButton buttonWithTitle:@"关闭" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16]];
    UIButton *back = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [back setTitle:@"关闭" forState:(UIControlStateNormal)];
    [back setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    back.titleLabel.font = [UIFont systemFontOfSize:16];
    [back addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
