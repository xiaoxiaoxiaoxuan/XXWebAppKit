//
//  WebErrorView.m
//  iSee
//
//  Created by Xiangyang on 2017/10/11.
//  Copyright © 2017年 itouzi. All rights reserved.
//

#import "WebErrorView.h"

@implementation WebErrorView

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}

+ (instancetype)viewWithError:(NSError *)error {
    WebErrorView *errorView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    errorView.codeLabel.text = [NSString stringWithFormat:@"code=%zd", error.code];
    return errorView;;
}

- (void)tap:(UITapGestureRecognizer *)gesture {
    NSLog(@"tap");
    [self removeFromSuperview];
    if (self.ErrorViewTapBlock) {
        self.ErrorViewTapBlock();
    }
}

@end
