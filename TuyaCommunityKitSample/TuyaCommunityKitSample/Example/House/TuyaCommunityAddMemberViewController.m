//
//  TuyaCommunityAddMemberViewController.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityAddMemberViewController.h"

@interface TuyaCommunityAddMemberViewController ()

@property (nonatomic, strong) TuyaCommunityHouseMemberService *service;

@property (nonatomic, strong) TuyaCommunityCosoleView *consoleView;

@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, strong) UITextField *memberTypeTextField;

@property (nonatomic, strong) UITextField *phoneTextField;

@end

@implementation TuyaCommunityAddMemberViewController

#pragma mark - Lifecycle Method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self requestMemberTypeList];
}

#pragma mark - Private Method

- (void)setupUI {
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"Add member";
    
    self.consoleView = [TuyaCommunityCosoleView new];
    self.consoleView.title = @"Member type list:";
    [self.view addSubview:self.consoleView];
    [self.consoleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(100);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
    
    UILabel *nameTipsLabel = [UILabel new];
    nameTipsLabel.textColor = UIColor.lightGrayColor;
    nameTipsLabel.font = [UIFont systemFontOfSize:15];
    nameTipsLabel.text = @"Name:";
    [self.view addSubview:nameTipsLabel];
    [nameTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.width.mas_equalTo(50);
        make.top.equalTo(self.consoleView.mas_bottom).offset(30);
        make.height.mas_equalTo(20);
    }];
    
    self.nameTextField = [UITextField new];
    self.nameTextField.borderStyle = UITextBorderStyleLine;
    self.nameTextField.textColor = UIColor.blackColor;
    self.nameTextField.placeholder = @"Input member's name";
    self.nameTextField.text = @"TuyaCommunitySDK Tester";
    self.nameTextField.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.leading.equalTo(nameTipsLabel.mas_trailing).offset(5);
        make.centerY.equalTo(nameTipsLabel.mas_centerY);
        make.trailing.equalTo(self.view).offset(-20);
    }];
    
    UILabel *memberTypeTipsLabel = [UILabel new];
    memberTypeTipsLabel.textColor = UIColor.lightGrayColor;
    memberTypeTipsLabel.font = [UIFont systemFontOfSize:15];
    memberTypeTipsLabel.text = @"Type code:";
    [self.view addSubview:memberTypeTipsLabel];
    [memberTypeTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.width.mas_equalTo(80);
        make.top.equalTo(nameTipsLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    self.memberTypeTextField = [UITextField new];
    self.memberTypeTextField.borderStyle = UITextBorderStyleLine;
    self.memberTypeTextField.textColor = UIColor.blackColor;
    self.memberTypeTextField.placeholder = @"Input dictTypeCode";
    self.memberTypeTextField.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.memberTypeTextField];
    [self.memberTypeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.leading.equalTo(memberTypeTipsLabel.mas_trailing).offset(5);
        make.centerY.equalTo(memberTypeTipsLabel.mas_centerY);
        make.trailing.equalTo(self.view).offset(-20);
    }];
    
    UILabel *phoneTipsLabel = [UILabel new];
    phoneTipsLabel.textColor = UIColor.lightGrayColor;
    phoneTipsLabel.font = [UIFont systemFontOfSize:15];
    phoneTipsLabel.text = @"Phone:";
    [self.view addSubview:phoneTipsLabel];
    [phoneTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.width.mas_equalTo(50);
        make.top.equalTo(memberTypeTipsLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    self.phoneTextField = [UITextField new];
    self.phoneTextField.borderStyle = UITextBorderStyleLine;
    self.phoneTextField.textColor = UIColor.blackColor;
    self.phoneTextField.placeholder = @"Input phone";
    self.phoneTextField.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.leading.equalTo(phoneTipsLabel.mas_trailing).offset(5);
        make.centerY.equalTo(phoneTipsLabel.mas_centerY);
        make.trailing.equalTo(self.view).offset(-20);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = UIColor.blueColor;
    [button setTitle:@"Add member" forState:UIControlStateNormal];
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
    __weak __typeof(self) weakSelf = self;
    [self.service addMemberWithCommunityId:self.houseModel.communityId
                                    roomId:self.houseModel.roomId
                                  realName:self.nameTextField.text
                                       sex:TuyaCommunityGenderTypeMale
                               phoneNumber:self.phoneTextField.text
                                  userType:self.memberTypeTextField.text
                                      role:TuyaCommunityMemberRoleMember
                                expireTime:nil
                                   success:^(NSString * _Nonnull roomUserId) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }
                                   failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - Data

- (void)requestMemberTypeList {
    __weak __typeof(self) weakSelf = self;
    [self.service getMemberTypeListWithRoomId:self.houseModel.roomId
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


@end
