//
//  TuyaCommunityHouseInfoView.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityHouseInfoView.h"
#import "TuyaCommunityManager.h"

@interface TuyaCommunityHouseInfoView ()

@property (nonatomic, strong) UILabel *houseIdLabel;

@property (nonatomic, strong) TuyaCommunityCosoleView *consoleView;

@end

@implementation TuyaCommunityHouseInfoView

#pragma mark - Init Method

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

#pragma mark - Private Method

- (void)setupUI {
    UILabel *houseIdTipLabel = [UILabel new];
    houseIdTipLabel.font = [UIFont systemFontOfSize:15];
    houseIdTipLabel.text = @"current house id:";
    houseIdTipLabel.textColor = UIColor.lightGrayColor;
    [self addSubview:houseIdTipLabel];
    [houseIdTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.leading.top.equalTo(self);
    }];
    
    self.houseIdLabel = [UILabel new];
    self.houseIdLabel.font = [UIFont systemFontOfSize:15];
    self.houseIdLabel.text = [NSString stringWithFormat:@"%lld", TuyaCommunityManager.sharedInstance.currentHouseId];
    self.houseIdLabel.textColor = UIColor.blackColor;
    [self addSubview:self.houseIdLabel];
    [self.houseIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(houseIdTipLabel.mas_trailing).offset(10);
        make.height.mas_equalTo(30);
        make.top.equalTo(self);
    }];
    
    self.consoleView = [TuyaCommunityCosoleView new];
    self.consoleView.title = @"current house json:";
    [self addSubview:self.consoleView];
    [self.consoleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(houseIdTipLabel.mas_bottom).offset(5);
        make.leading.centerX.equalTo(self);
        make.height.mas_equalTo(170);
    }];
}

#pragma mark - Public Method

- (void)reloadData {
    self.houseIdLabel.text = [NSString stringWithFormat:@"%lld", TuyaCommunityManager.sharedInstance.currentHouseId];
    [self.consoleView updateContentWithModel:self.model];
}

@end
