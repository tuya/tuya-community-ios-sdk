//
//  TuyaCommunitySelectHouseViewController.h
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    TuyaCommunitySelectHouseStepTypeCommunity = 0,
    TuyaCommunitySelectHouseStepTypeHouse = 1,
} TuyaCommunitySelectHouseStepType;


@interface TuyaCommunitySelectHouseViewController : UITableViewController;

@property (nonatomic, assign) TuyaCommunitySelectHouseStepType stepType;

@property (nonatomic, strong) TuyaCommunityModel *communityModel;

@property (nonatomic, copy) NSString *spaceTreeId;

@property (nonatomic, copy) NSString *houseName;

@end

NS_ASSUME_NONNULL_END
