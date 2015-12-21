//
//  TouchIDTool.m
//  Demo4TouchID
//
//  Created by 杨育彬 on 15/12/21.
//  Copyright © 2015年 杨育彬. All rights reserved.
//

#import "TouchIDTool.h"


@implementation TouchIDTool

+ (NSError *)canSupportTouchID
{
    //初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    //错误对象
    NSError* error = nil;
    
    if (![context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                [self showAlertViewErrorInfo:@"TouchID is not enrolled"];
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                [self showAlertViewErrorInfo:@"A passcode has not been set"];
                break;
            }
            default:
            {
                [self showAlertViewErrorInfo:@"A passcode has not been set"];
                break;
            }
        }
    }
    
    return error;
}

+ (void)openTouchIDWithTitle:(NSString *)title success:(successBlock)successBlock enterPassword:(enterPassword)enterPassword failure:(failureBlock)failureBlock
{
    //初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    //错误对象
    NSError* error = nil;
    NSString* result = title;
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success) {
                //验证成功，主线程处理UI
                successBlock();
            }
            else
            {
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"Authentication was cancelled by the system , error.code = %ld",error.code);
                        //切换到其他APP，系统取消验证Touch ID
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"Authentication was cancelled by the user , error.code = %ld",error.code);
                        //用户取消验证Touch ID
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        NSLog(@"User selected to enter custom password , error.code = %ld",error.code);
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                            enterPassword();
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                            failureBlock();
                        }];
                        break;
                    }
                }
            }
        }];
    }

}
+ (void)showAlertViewErrorInfo:(NSString *)info
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"失败" message:info delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
