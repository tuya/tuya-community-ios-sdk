//
//  UIImage+TYQRCode.h
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (TYQRCode)

+ (UIImage *)ty_qrCodeWithString:(NSString *)str width:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
