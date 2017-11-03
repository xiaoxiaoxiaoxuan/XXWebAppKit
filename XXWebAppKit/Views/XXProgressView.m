//
//  XXProgressView.m
//  ISWebViewFramework
//
//  Created by 王笑璇 on 2017/10/31.
//  Copyright © 2017年 wangxiaoxuan. All rights reserved.
//

#import "XXProgressView.h"

@implementation XXProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.trackTintColor = [UIColor clearColor];
    self.progressTintColor = [UIColor greenColor];
}

- (void)setEstimatedProgress:(float)estimatedProgress {
    _estimatedProgress = estimatedProgress;
    if (estimatedProgress == 1) {
        self.hidden = YES;
        [self setProgress:0 animated:NO];
    } else {
        self.hidden = NO;
        [self setProgress:estimatedProgress animated:NO];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
