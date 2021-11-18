//
//  TuyaCommunityVisitorDetailsViewController.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityVisitorDetailsViewController.h"

@interface TuyaCommunityVisitorDetailsViewController ()

@property (nonatomic, strong) UILabel  *visitorStatusLabel;
@property (nonatomic, strong) UILabel  *visitorNameLabel;
@property (nonatomic, strong) UILabel  *visitorAddressLabel;
@property (nonatomic, strong) UILabel  *visitorPhoneLabel;
@property (nonatomic, strong) UILabel  *visitorCarNumLabel;
@property (nonatomic, strong) TuyaCommunityVisitorService *requestService;
@property (nonatomic, strong) TuyaCommunityHouse *currentHouse;
@end

@implementation TuyaCommunityVisitorDetailsViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self requestData];

}

#pragma mark - layout

- (void)setupUI {
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"VisitorDetails";
    
    self.visitorStatusLabel = [UILabel new];
    self.visitorStatusLabel.textColor = UIColor.redColor;
    self.visitorStatusLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    [self.view addSubview:self.visitorStatusLabel];
    [self.visitorStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.leading.equalTo(self.view).offset(20);
    }];
    self.visitorStatusLabel.text = [NSString stringWithFormat:@"visitorStatusStr: %@",self.visitorStatusStr];
    
    self.visitorNameLabel = [UILabel new];
    self.visitorNameLabel.textColor = UIColor.blackColor;
    self.visitorNameLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.visitorNameLabel];
    [self.visitorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.top.equalTo(self.visitorStatusLabel.mas_bottom).offset(20);
        make.trailing.equalTo(self.view).offset(-20);
    }];
    
    self.visitorAddressLabel = [UILabel new];
    self.visitorAddressLabel.textColor = UIColor.blackColor;
    self.visitorAddressLabel.numberOfLines = 2;
    self.visitorAddressLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.visitorAddressLabel];
    [self.visitorAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.top.equalTo(self.visitorNameLabel.mas_bottom).offset(20);
        make.trailing.equalTo(self.view).offset(-20);
    }];
    
    self.visitorPhoneLabel = [UILabel new];
    self.visitorPhoneLabel.textColor = UIColor.blackColor;
    self.visitorPhoneLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.visitorPhoneLabel];
    [self.visitorPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.top.equalTo(self.visitorAddressLabel.mas_bottom).offset(20);
        make.trailing.equalTo(self.view).offset(-20);
    }];
    
    self.visitorCarNumLabel = [UILabel new];
    self.visitorCarNumLabel.textColor = UIColor.blackColor;
    self.visitorCarNumLabel.numberOfLines = 2;
    self.visitorCarNumLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.visitorCarNumLabel];
    [self.visitorCarNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.top.equalTo(self.visitorPhoneLabel.mas_bottom).offset(20);
        make.trailing.equalTo(self.view).offset(-2);
    }];
    
    
    if (self.visitorStatus == TuyaCommunityVisitorStatusWait) {
        UIButton *disinviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        disinviteBtn.backgroundColor = UIColor.blueColor;
        [disinviteBtn setTitle:@"delete invite" forState:UIControlStateNormal];
        [disinviteBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [disinviteBtn addTarget:self action:@selector(didDisinviteBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:disinviteBtn];
        [disinviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.view).offset(20);
            make.trailing.equalTo(self.view).offset(-20);
            make.top.equalTo(self.visitorCarNumLabel.mas_bottom).offset(50);
            make.centerX.equalTo(self.view);
            make.height.mas_equalTo(35);
        }];
    }
}

#pragma mark - data

- (void)requestData {
    
    long long houseId = TuyaCommunityManager.sharedInstance.currentHouseId;
    self.currentHouse = [TuyaCommunityHouse houseWithHouseId:houseId];
    __weak __typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestService getVisitorPassInfoWithCommunityId:self.currentHouse.houseModel.communityId visitorId:self.visitorId success:^(TuyaCommunityVisitorInfoModel * _Nonnull infoModel) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        if (infoModel.visitorStatus  == TuyaCommunityVisitorStatusWait) {
            strongSelf.visitorStatusLabel.text = @"visitorStatusStr：Not visit";
        }
        strongSelf.visitorNameLabel.text = [NSString stringWithFormat:@"visitorName: %@",infoModel.visitorName];
        strongSelf.visitorAddressLabel.text = [NSString stringWithFormat:@"visitorAddress: %@",infoModel.visitorAddress];
        strongSelf.visitorPhoneLabel.text = [NSString stringWithFormat:@"visitorPhone: %@",infoModel.visitorPhone];
        strongSelf.visitorCarNumLabel.text = [NSString stringWithFormat:@"LicensePlateNumber: %@",infoModel.carNum.length > 0 ? infoModel.carNum:@"No license plate has been configured"];
    }failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        NSLog(@"%@", error);
    }];
}

#pragma mark - Event

- (void)didDisinviteBtnPressed {
    long long houseId = TuyaCommunityManager.sharedInstance.currentHouseId;
    self.currentHouse = [TuyaCommunityHouse houseWithHouseId:houseId];
    __weak __typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestService deletePassWithCommunityId:self.currentHouse.houseModel.communityId visitorId:self.visitorId success:^(BOOL rs) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        if (rs) {
            strongSelf.visitorStatusLabel.text = @"delete invite success";
        }
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        NSLog(@"%@", error);
    }];
}

#pragma mark - Getter

- (TuyaCommunityVisitorService *)requestService {
    if (!_requestService) {
        _requestService = TuyaCommunityVisitorService.new;
    }
    return _requestService;
}


@end
