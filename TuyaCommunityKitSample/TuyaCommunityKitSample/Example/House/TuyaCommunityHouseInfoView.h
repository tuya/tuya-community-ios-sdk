//
//  TuyaCommunityHouseInfoView.h
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TuyaCommunityHouseInfoView : UIView

@property (nonatomic, strong) TuyaCommunityHouseModel *model;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
