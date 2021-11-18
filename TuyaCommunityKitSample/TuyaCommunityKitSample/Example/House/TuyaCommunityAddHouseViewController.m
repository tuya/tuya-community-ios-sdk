//
//  TuyaCommunityAddHouseViewController.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityAddHouseViewController.h"

@interface TuyaCommunityAddHouseViewController ()

@property (nonatomic, strong) TuyaCommunityHouseMemberService *service;

@property (nonatomic, strong) TuyaCommunityHouseManager *houseManager;

@property (nonatomic, strong) TuyaCommunityCosoleView *consoleView;

@property (nonatomic, strong) UITextField *memberTypeTextField;

@end

@implementation TuyaCommunityAddHouseViewController

#pragma mark - Lifecycle Method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self requestMemberTypeList];
}

#pragma mark - Private Method

- (void)setupUI {
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"Add house";
    
    self.consoleView = [TuyaCommunityCosoleView new];
    self.consoleView.title = @"Member type list:";
    [self.view addSubview:self.consoleView];
    [self.consoleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(100);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
    
    UILabel *communityLabel = [UILabel new];
    communityLabel.numberOfLines = 0;
    communityLabel.textColor = UIColor.blackColor;
    communityLabel.font = [UIFont systemFontOfSize:15];
    communityLabel.text = [NSString stringWithFormat:@"Community name: %@", self.communityModel.communityName];
    [self.view addSubview:communityLabel];
    [communityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.consoleView.mas_bottom).offset(30);
    }];
    
    UILabel *houseNameLabel = [UILabel new];
    houseNameLabel.numberOfLines = 0;
    houseNameLabel.textColor = UIColor.blackColor;
    houseNameLabel.font = [UIFont systemFontOfSize:15];
    houseNameLabel.text =
    [NSString stringWithFormat:@"House name: %@", self.houseName];
    [self.view addSubview:houseNameLabel];
    [houseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
        make.top.equalTo(communityLabel.mas_bottom).offset(10);
    }];

    UILabel *memberTypeTipsLabel = [UILabel new];
    memberTypeTipsLabel.textColor = UIColor.lightGrayColor;
    memberTypeTipsLabel.font = [UIFont systemFontOfSize:15];
    memberTypeTipsLabel.text = @"Type code:";
    [self.view addSubview:memberTypeTipsLabel];
    [memberTypeTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.width.mas_equalTo(80);
        make.top.equalTo(houseNameLabel.mas_bottom).offset(30);
        make.height.mas_equalTo(20);
    }];

    self.memberTypeTextField = [UITextField new];
    self.memberTypeTextField.borderStyle = UITextBorderStyleLine;
    self.memberTypeTextField.textColor = UIColor.blackColor;
    self.memberTypeTextField.placeholder = @"Input dictTypeCode";
    self.memberTypeTextField.font = [UIFont systemFontOfSize:15];
    self.memberTypeTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:self.memberTypeTextField];
    [self.memberTypeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.leading.equalTo(memberTypeTipsLabel.mas_trailing).offset(5);
        make.centerY.equalTo(memberTypeTipsLabel.mas_centerY);
        make.trailing.equalTo(self.view).offset(-20);
    }];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = UIColor.blueColor;
    [button setTitle:@"Add house" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(35);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);
        } else {
            make.bottom.equalTo(self.view).offset(-10);
        }
    }];
}

- (void)didButtonPressed {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(self) weakSelf = self;
    [self.houseManager addHouseWithName:self.houseName
                            communityId:self.communityModel.communityId
                                 roomId:self.spaceTreeId
                               userType:self.memberTypeTextField.text
                             expireTime:nil
                                success:^(TuyaCommunityHouseModel * _Nonnull result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - Data

- (void)requestMemberTypeList {
    __weak __typeof(self) weakSelf = self;
    [self.service getMemberTypeListWithRoomId:self.spaceTreeId
                                      success:^(NSArray<TuyaCommunityMemberTypeModel *> * _Nonnull list) {
        [weakSelf.consoleView updateContentWithModels:list];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - Getter

- (TuyaCommunityHouseMemberService *)service {
    if (!_service) {
        _service = [TuyaCommunityHouseMemberService new];
    }
    
    return _service;
}

- (TuyaCommunityHouseManager *)houseManager {
    if (!_houseManager) {
        _houseManager = [TuyaCommunityHouseManager new];
    }
    
    return _houseManager;
}

@end
