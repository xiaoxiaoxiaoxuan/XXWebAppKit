//
//  XXFingerViewController.h
//  XXWebAppKitDemo
//
//  Created by 王笑璇 on 2017/11/7.
//  Copyright © 2017年 wangxiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FingerPrintDelegate <NSObject>

- (void)doSuccess;

- (void)doFailed:(NSError *)error;

@optional
- (void)doFingerChange;

@end

@interface XXFingerViewController : UIViewController

@property (nonatomic ,weak) id<FingerPrintDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *leftBottomBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBottomBtn;

@property (nonatomic, copy) void (^leftBottomBtnActionBlock)(XXFingerViewController *vc);
@property (nonatomic, copy) void (^rightBottomBtnActionBlock)(XXFingerViewController *vc);

@property (nonatomic, copy) void (^singerResultBlock)(BOOL success, NSError *error, XXFingerViewController *vc);

- (void)dissmissAnimated:(BOOL)animated;

@end
