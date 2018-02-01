//
//  MBProgressHUD+Hud.h
//  YFSM
//
//  Created by mac on 2018/1/24.
//  Copyright © 2018年 wb. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Hud)
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;

+ (void)showHint:(NSString *)hint;
@end
