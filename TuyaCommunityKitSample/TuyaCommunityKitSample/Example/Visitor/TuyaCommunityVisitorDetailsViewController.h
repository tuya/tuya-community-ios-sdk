//
//  TuyaCommunityVisitorDetailsViewController.h
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface TuyaCommunityVisitorDetailsViewController : UIViewController

@property (nonatomic, strong) NSString *visitorId;
@property (nonatomic, strong) NSString *visitorStatusStr;
@property (nonatomic, assign) TuyaCommunityVisitorStatus visitorStatus;

@end

NS_ASSUME_NONNULL_END
