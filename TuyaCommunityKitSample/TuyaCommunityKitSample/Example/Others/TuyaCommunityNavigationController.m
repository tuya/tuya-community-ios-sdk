//
//  TuyaCommunityNavigationController.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityNavigationController.h"

@interface TuyaCommunityNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation TuyaCommunityNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.enabled = YES;
    self.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - Override Method

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.hidesBottomBarWhenPushed = self.viewControllers.count >= 1;
    
    [super pushViewController:viewController animated:animated];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    viewControllers.lastObject.hidesBottomBarWhenPushed = self.viewControllers.count > 1;
    
    [super setViewControllers:viewControllers animated:animated];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.viewControllers.count == 1 ? NO : YES;
}


@end
