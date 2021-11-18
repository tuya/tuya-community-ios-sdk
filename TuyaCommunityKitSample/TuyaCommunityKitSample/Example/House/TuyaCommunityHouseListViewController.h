//
//  TuyaCommunityHouseListViewController.h
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TuyaCommunityHouseListViewController : UITableViewController

@property (nonatomic, copy) NSArray<TuyaCommunityHouseModel *> *houseList;

@end

NS_ASSUME_NONNULL_END
