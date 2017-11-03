//
//  CoreLockConst.h
//  CoreLock
//
//  Created by 成林 on 15/4/24.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#ifndef _CoreLockConst_H_
#define _CoreLockConst_H_


#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]


/*
 *  背景色
 */ 
#define CoreLockViewBgColor [UIColor redColor]

/*
 *  外环线条颜色：默认
 */
#define CoreLockCircleLineNormalColor RGB_HEX(0xf1e7ce)


/*
 *  外环线条颜色：选中
 */
#define CoreLockCircleLineSelectedColor RGB_HEX(0xd1af5d)


/*
 *  实心圆
 */
#define CoreLockCircleLineSelectedCircleColor RGB_HEX(0xd1af5d)

#define RGB_HEX(hexColor) [UIColor colorWithRed:(((hexColor >> 16) & 0xFF))/255.0f         \
green:(((hexColor >> 8) & 0xFF))/255.0f          \
blue:((hexColor & 0xFF))/255.0f                 \
alpha:1]

#define CLSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define CLSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

/*
 *  实心圆
 */
#define CoreLockLockLineColor RGB_HEX(0xd1af5d)



/*
 *  警示文字颜色
 */
#define CoreLockWarnColor rgba(254,82,92,1)



/** 选中圆大小比例 */
extern const CGFloat CoreLockArcWHR;



/** 选中圆大小的线宽 */
extern const CGFloat CoreLockArcLineW;


/** 密码存储Key */
extern NSString *const CoreLockPWDKey;


/** 最低设置密码数目 */
extern const NSUInteger CoreLockMinItemCount;



/*
 *  设置密码
 */

/** 设置密码提示文字：第一次 */
extern NSString *const CoreLockPWDTitleFirst;


/** 设置密码提示文字：确认 */
extern NSString *const CoreLockPWDTitleConfirm;


/** 设置密码提示文字：再次密码不一致 */
extern NSString *const CoreLockPWDDiffTitle;


/** 设置密码提示文字：设置成功 */
extern NSString *const CoreLockPWSuccessTitle;



/*
 *  验证密码
 */

/** 验证密码：普通提示文字 */
extern NSString *const CoreLockVerifyNormalTitle;


/** 验证密码：密码错误 */
extern NSString *const CoreLockVerifyErrorPwdTitle;



/** 验证密码：验证成功 */
extern NSString *const CoreLockVerifySuccesslTitle;



/*
 *  修改密码
 */
/** 修改密码：普通提示文字 */
extern NSString *const CoreLockModifyNormalTitle;

#endif
