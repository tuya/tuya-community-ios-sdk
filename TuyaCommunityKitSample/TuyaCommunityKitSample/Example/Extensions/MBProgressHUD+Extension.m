//
//  MBProgressHUD+Extension.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "MBProgressHUD+Extension.h"

@implementation MBProgressHUD (Extension)

+ (instancetype)showToasterWithText:(NSString *)text toView:(UIView *)view  {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.label.numberOfLines = 0;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    [hud hideAnimated:YES afterDelay:1.0];
    
    return hud;
}

@end
