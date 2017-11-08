//
//  XXFingerViewController.m
//  XXWebAppKitDemo
//
//  Created by 王笑璇 on 2017/11/7.
//  Copyright © 2017年 wangxiaoxuan. All rights reserved.
//

#import "XXFingerViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface XXFingerViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *fingerImg;
@property (weak, nonatomic) IBOutlet UILabel *tinkLabel;

@end

@implementation XXFingerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.fingerImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlertWithResult)]];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showAlertWithResult];
}

- (IBAction)gotoGesAction:(id)sender {
    if (_leftBottomBtnActionBlock) {
        _leftBottomBtnActionBlock(self);
    }
}
- (IBAction)skipAction:(id)sender {
    if (_rightBottomBtnActionBlock) {
        _rightBottomBtnActionBlock(self);
    }
}

- (void)dissmissAnimated:(BOOL)animated {
    [self dismissViewControllerAnimated:animated completion:nil];
}

- (void)showAlertWithResult {
    
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"解锁";
    
    LAPolicy policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    
    [context evaluatePolicy:policy
            localizedReason:@"登录" reply:^(BOOL success, NSError *error) {
                if (_singerResultBlock) {
                    _singerResultBlock(success, error, self);
                }
            }];
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
