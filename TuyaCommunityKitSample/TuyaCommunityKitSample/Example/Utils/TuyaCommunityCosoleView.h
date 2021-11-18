//
//  TuyaCommunityCosoleView.h
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TuyaCommunityCosoleView : UIView

//@property (nonatomic, strong, readonly) UILabel *titleLabel;
//
//@property (nonatomic, strong, readonly) UITextView *textView;

@property (nonatomic, copy) NSString *title;

- (void)updateContentWithModel:(NSObject *)model;

- (void)updateContentWithModels:(NSArray *)models;

- (void)cleanContent;

@end

NS_ASSUME_NONNULL_END
