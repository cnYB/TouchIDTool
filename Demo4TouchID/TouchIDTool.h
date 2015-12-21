//
//  TouchIDTool.h
//  Demo4TouchID
//
//  Created by 杨育彬 on 15/12/21.
//  Copyright © 2015年 杨育彬. All rights reserved.
//  TouchID工具类

#import <UIKit/UIKit.h>

#import <LocalAuthentication/LocalAuthentication.h>

typedef void (^successBlock)();
typedef void (^failureBlock)();
typedef void (^enterPassword)();

@interface TouchIDTool : NSObject

/**
 *  检测设备TouchID是否能够使用
 */
+ (NSError *)canSupportTouchID;

/**
 *  打开TouchID
 *
 *  @param title         标题
 *  @param successBlock  成功回调
 *  @param enterPassword 输入密码回调
 *  @param failureBlock  失败回调
 */
+ (void)openTouchIDWithTitle:(NSString *)title success:(successBlock)successBlock enterPassword:(enterPassword)enterPassword failure:(failureBlock)failureBlock;

@end
