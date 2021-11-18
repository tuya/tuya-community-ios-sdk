//
//  TuyaCommunityManager.h
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TuyaCommunityManager : NSObject

+ (instancetype)sharedInstance;

- (UIViewController *)mainViewController;

- (long long)currentHouseId;

- (void)updateCurrentHouseId:(long long)houseId;

- (TuyaCommunityHouse *)currentHouse;

- (TuyaCommunityHouseModel *)currentHouseModel;

@end

NS_ASSUME_NONNULL_END
