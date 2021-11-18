//
//  TuyaCommunityTabBarController.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityTabBarController.h"
#import "TuyaCommunityNavigationController.h"
#import "TuyaCommunityViewController.h"
#import "TuyaCommunityFunctionViewController.h"

@interface TuyaCommunityTabBarController ()

@property (nonatomic, copy, readonly) NSDictionary *classMap;

@end

@implementation TuyaCommunityTabBarController

#pragma mark - Lifecycle Method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildViewControllers];
}

#pragma mark - Private Method

- (void)setupChildViewControllers {
    NSArray *keys = @[@"House", @"Function"];
    NSDictionary *classMap = self.classMap;
    for (NSString *string in keys) {
        Class cls = classMap[string];
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:string image:nil tag:0];
        UINavigationController *nav = [[TuyaCommunityNavigationController alloc]initWithRootViewController:[cls new]];
        nav.tabBarItem = tabBarItem;
        [self addChildViewController:nav];
        
    }
}

#pragma mark - Getter

- (NSDictionary *)classMap {
    return @{
        @"House": TuyaCommunityViewController.class,
        @"Function": TuyaCommunityFunctionViewController.class
    };
}


@end
