//
//  TuyaCommunityImagePicker.h
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TuyaCommunityImagePicker : NSObject

- (void)showInViewController:(UIViewController *)viewController
                 compeletion:(void (^)(UIImage * _Nullable originalImage))compeletion;

@end

NS_ASSUME_NONNULL_END
