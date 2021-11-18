//
//  TuyaCommunityHouseCell.h
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TuyaCommunityHouseCell : UITableViewCell

@property (nonatomic, assign) BOOL showDelete;

@property (nonatomic, copy) void (^deleteBlock)(void);

@property (nonatomic, strong) TuyaCommunityHouseModel *model;

@property (nonatomic, strong) TuyaCommunityMemberModel *memberModel;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
