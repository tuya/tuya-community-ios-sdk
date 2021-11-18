//
//  TuyaCommunityViewController.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityVisitorViewController.h"
#import "TuyaCommunityHouseListViewController.h"
#import "TuyaCommunityVisitorRecordViewController.h"
#import "TuyaCommunityVisitorDetailsViewController.h"

@interface TuyaCommunityVisitorViewController ()<UITextViewDelegate>

@property (nonatomic, strong) TuyaCommunityHouse *currentHouse;
@property (nonatomic, strong) TuyaCommunityHouseManager *houseManager;
@property (nonatomic, copy) NSArray<TuyaCommunityHouseModel *> *houseList;
@property (nonatomic, strong) UITextView *dataText;
@property (nonatomic, strong) TuyaCommunityVisitorService *requestService;
@property (nonatomic, strong) UILabel  *whetherDrivingLabel;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;

@end

@implementation TuyaCommunityVisitorViewController

#pragma mark - Lifecycle Method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self requestData];
}

#pragma mark - Private Method

- (void)setupUI {
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"Visitors to traffic";
    UIButton *generateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    generateBtn.backgroundColor = UIColor.blueColor;
    [generateBtn setTitle:@"Generate visitor access" forState:UIControlStateNormal];
    [generateBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [generateBtn addTarget:self action:@selector(didGenerateBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:generateBtn];
    [generateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.leading.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(35);
    }];

    UIButton *visitorRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    visitorRecordBtn.backgroundColor = UIColor.blueColor;
    [visitorRecordBtn setTitle:@"Visitors to record" forState:UIControlStateNormal];
    [visitorRecordBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [visitorRecordBtn addTarget:self action:@selector(didVisitorRecordBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:visitorRecordBtn];
    [visitorRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(generateBtn.mas_bottom).offset(10);
        make.leading.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(35);
    }];
    
    self.whetherDrivingLabel = [UILabel new];
    self.whetherDrivingLabel.textColor = UIColor.redColor;
    self.whetherDrivingLabel.numberOfLines = 3;
    self.whetherDrivingLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [self.view addSubview:self.whetherDrivingLabel];
    [self.whetherDrivingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.top.equalTo(visitorRecordBtn.mas_bottom).offset(20);
        make.trailing.equalTo(self.view).offset(-2);
    }];
}

#pragma mark - Data

- (void)requestData {
    long long houseId = TuyaCommunityManager.sharedInstance.currentHouseId;
    self.currentHouse = [TuyaCommunityHouse houseWithHouseId:houseId];
    [self.requestService getCarConfigWithCommunityId:self.currentHouse.houseModel.communityId success:^(BOOL hasCar) {
        self.whetherDrivingLabel.text = hasCar == YES ? @"Visitor management whether to drive query: open" : @"Visitor management whether to drive query: Didn't open";
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - Event

- (void)didVisitorRecordBtnPressed {
    TuyaCommunityVisitorRecordViewController *vc = [TuyaCommunityVisitorRecordViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didGenerateBtnPressed {
    
    long long houseId = TuyaCommunityManager.sharedInstance.currentHouseId;
    self.currentHouse = [TuyaCommunityHouse houseWithHouseId:houseId];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(self) weakSelf = self;
    [self.requestService getVisitorReasonListWithCommunityId:self.currentHouse.houseModel.communityId success:^(NSArray<TuyaCommunityVisitorReasonModel *> * _Nonnull list) {
        NSDate *nowDate = NSDate.date;
        int num = (arc4random() % 1000000);
        NSString *phoneNumberStr = [NSString stringWithFormat:@"18888%.6d", num];
        NSString *nameStr = [NSString stringWithFormat:@"zhagnsan-%.3d", num];
        [self.requestService createPassWithCommunityId:self.currentHouse.houseModel.communityId visitorName:nameStr visitorPhone:phoneNumberStr sex:1 visitorReason:list.firstObject.visitorReasonId startTime:(nowDate.timeIntervalSince1970 * 1000) endTime:(nowDate.timeIntervalSince1970 * 1000 + 60*60*60) visitorAddressId:self.currentHouse.houseModel.roomId driveCar:0 carNum:@"" visitorFrom:2 success:^(NSString * _Nonnull visitorId) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            NSLog(@"%@", visitorId);
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            TuyaCommunityVisitorDetailsViewController *vc = [TuyaCommunityVisitorDetailsViewController new];
            vc.visitorId = visitorId;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - Getter

- (TuyaCommunityHouseManager *)houseManager {
    if (!_houseManager) {
        _houseManager = [TuyaCommunityHouseManager new];
    }
    
    return _houseManager;
}

- (TuyaCommunityVisitorService *)requestService {
    if (!_requestService) {
        _requestService = TuyaCommunityVisitorService.new;
    }
    return _requestService;
}

@end
