//
//  Tools.h
//  iSee
//
//  Created by Xiangyang on 2017/10/10.
//  Copyright © 2017年 itouzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

// 清理cookie & cache
+ (void)clearCache;

// 存储cookie到storage
+ (void)setCookieToCookieStorage:(NSString *)cookie withUrl:(NSString *)urlStr;

@end
