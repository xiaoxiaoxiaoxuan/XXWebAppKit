//
//  CLLockMainView.h
//  CoreLock
//
//  Created by 冯成林 on 15/4/28.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLLockMainView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMarginC;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewTopMoveC;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTopMarginC;


@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;


@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;


@end
