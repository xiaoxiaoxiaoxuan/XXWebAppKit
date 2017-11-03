//
//  WebErrorView.h
//  iSee
//
//  Created by Xiangyang on 2017/10/11.
//  Copyright © 2017年 itouzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebErrorView : UIView

+ (instancetype)viewWithError:(NSError *)error;

@property (copy, nonatomic) void(^ErrorViewTapBlock)(void);
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

@end
