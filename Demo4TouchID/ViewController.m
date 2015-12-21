//
//  ViewController.m
//  Demo4TouchID
//
//  Created by 杨育彬 on 15/12/14.
//  Copyright © 2015年 杨育彬. All rights reserved.
//

#import "ViewController.h"
#import "TouchIDTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self openTouchID];
}

- (void)openTouchID
{
    NSError *error = [TouchIDTool canSupportTouchID];
    if (!error) {
        
        __weak __typeof(self)weakSelf = self;
        
        [TouchIDTool openTouchIDWithTitle:@"TOUCH ME" success:^{
            NSLog(@"tool success");
        } enterPassword:^{
            [weakSelf showPasswordAlert];
        } failure:^(LAError *error) {
            NSLog(@"tool failure");
        }];
        
    } else {
        NSLog(@"%@",error.localizedDescription);
    }
}

- (void)showPasswordAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.secureTextEntry = YES;
        textField.placeholder = @"密码";
    }];
    
    UIAlertAction *touchIDAction = [UIAlertAction actionWithTitle:@"返回TouchID" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"返回TouchID");
        
        [self openTouchID];
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK");
        UITextField *passwordTextField = alert.textFields.firstObject;
        if ([passwordTextField.text isEqualToString:@"123"]) {
            NSLog(@"YES");
        }
        else {
            NSLog(@"NO");
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel");
    }];
    
    [alert addAction:touchIDAction];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}



@end
