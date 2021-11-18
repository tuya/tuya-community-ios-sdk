//
//  TuyaCommunityImagePicker.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityImagePicker.h"

@interface TuyaCommunityImagePicker () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, copy) void (^compeletion)(UIImage * _Nullable originalImage);

@end

@implementation TuyaCommunityImagePicker

- (void)dealloc {
    NSLog(@"%@ dealloc", self.class);
}

- (void)showInViewController:(UIViewController *)viewController
                 compeletion:(void (^)(UIImage * _Nullable originalImage))compeletion {
    self.compeletion = compeletion;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];

    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"Choose from Album"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
        [self imagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary viewController:viewController];
    }];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    if (![self isIPhoneSimuLator]) {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
            [self imagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera viewController:viewController];
        }];
        [alert addAction:cameraAction];
    }
   
    [alert addAction:albumAction];
    [alert addAction:cancelAction];
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
                   viewController:(UIViewController *)viewController {
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = sourceType;
    objc_setAssociatedObject(imagePickerController, @"imagePicker", self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [viewController presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.compeletion) self.compeletion(originalImage);
        self.compeletion = nil;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        self.compeletion = nil;
    }];
}

#pragma mark - Getter

- (BOOL)isIPhoneSimuLator {
    return TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1;
}

@end
