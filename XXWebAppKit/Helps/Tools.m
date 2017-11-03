//
//  Tools.m
//  iSee
//
//  Created by Xiangyang on 2017/10/10.
//  Copyright © 2017年 itouzi. All rights reserved.
//

#import "Tools.h"
#import <WebKit/WebKit.h>
#import "XXWebViewHeader.h"

@implementation Tools

+ (void)clearCache {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    
    // iOS9 以上使用WKWebsiteDataStore清除与对应url相关的cookies,磁盘内存缓存,持久化存储WebSQL, 数据库IndexedDB,本地存储
    if (DEVICE_SYSTEM_VERSION >= 9.0) {
        NSSet *webDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateSince = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:webDataTypes modifiedSince:dateSince completionHandler:^{
            NSLog(@"清除cookie完成");
        }];
        
    } else {
        // iOS8 cache & cookie
        NSError *errors;
        NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES)[0];
        NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
        [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
        NSString *cookiesFolderPath = [libraryDir stringByAppendingString:@"/Cookies"];
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}

+ (void)setCookieToCookieStorage:(NSString *)cookie withUrl:(NSString *)urlStr {

    // 塞入本地存储的cookie
    NSArray *keyValue = [cookie componentsSeparatedByString:@"="];
    if (keyValue.count == 2) {
        NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:@{NSHTTPCookieName:keyValue.firstObject,
                                                                          NSHTTPCookieValue:keyValue.lastObject,
                                                                          NSHTTPCookieDomain:urlStr,
                                                                          NSHTTPCookiePath:@"/",
                                                                          NSHTTPCookieExpires:[NSDate distantFuture]
                                                                          }];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
}


@end
