//
//  TuyaCommunityManager.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityManager.h"
#import "TuyaCommunityLoginViewController.h"
#import "TuyaCommunityTabBarController.h"
#import <TuyaSmartBaseKit/TuyaSmartBaseKit.h>

NSString *const TYCommunityHouseKey = @"TYCommunityHouseKey";

@interface TuyaCommunityManager ()

@property (nonatomic, strong) UIViewController *loginViewController;

@property (nonatomic, strong) TuyaCommunityTabBarController *tabBarController;

@property (nonatomic, assign) long long currentHouseId;

@property (nonatomic, assign, readonly) BOOL isLogin;

@end

@implementation TuyaCommunityManager

#pragma mark - Init Method

+ (instancetype)sharedInstance {
    static TuyaCommunityManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [self new];
    });
    
    return _sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        NSNumber *value = [NSUserDefaults.standardUserDefaults objectForKey:TYCommunityHouseKey];
        self.currentHouseId = [value longLongValue];
    }
    
    return self;
}

#pragma mark - Public Method

- (void)updateCurrentHouseId:(long long)houseId {
    self.currentHouseId = houseId;
}

#pragma mark - Setter & Getter

- (void)setCurrentHouseId:(long long)currentHouseId {
    _currentHouseId = currentHouseId;
    
    [NSUserDefaults.standardUserDefaults setObject:@(currentHouseId)
                                            forKey:TYCommunityHouseKey];
}


- (BOOL)isLogin {
    return TuyaSmartUser.sharedInstance.isLogin;
}

- (UIViewController *)mainViewController {
    return self.isLogin ? self.tabBarController : self.loginViewController;
}

- (UIViewController *)loginViewController {
    if (!_loginViewController) {
        _loginViewController = [[UINavigationController alloc] initWithRootViewController:[TuyaCommunityLoginViewController new]];
    }
    
    return _loginViewController;
}

- (TuyaCommunityTabBarController *)tabBarController {
    if (!_tabBarController) {
        _tabBarController = [TuyaCommunityTabBarController new];
    }
    
    return _tabBarController;
}

- (TuyaCommunityHouse *)currentHouse {
    return [TuyaCommunityHouse houseWithHouseId:self.currentHouseId];
}

- (TuyaCommunityHouseModel *)currentHouseModel {
    return self.currentHouse.houseModel;
}

@end
