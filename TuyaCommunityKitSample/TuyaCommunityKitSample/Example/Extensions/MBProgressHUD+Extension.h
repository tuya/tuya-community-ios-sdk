//
//  MBProgressHUD+Extension.h
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (Extension)

+ (instancetype)showToasterWithText:(NSString *)text toView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
