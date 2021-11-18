//
//  TuyaCommunityViewController.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityViewController.h"
#import "TuyaCommunityHouseListViewController.h"
#import "TuyaCommunityManager.h"
#import "TuyaCommunityHouseInfoView.h"
#import "TuyaCommunityChangeHouseViewController.h"
#import "TuyaCommunityAccessControlCallViewController.h"

@interface TuyaCommunityViewController () <TuyaCommunityHouseManagerDelegate, TuyaCommunityVisualSpeakManagerDelegate>

@property (nonatomic, strong) TuyaCommunityHouse *currentHouse;

@property (nonatomic, strong) TuyaCommunityHouseManager *houseManager;

@property (nonatomic, strong) TuyaCommunityHouseInfoView *houseInfoView;

@property (nonatomic, copy) NSArray<TuyaCommunityHouseModel *> *houseList;

@end

@implementation TuyaCommunityViewController

#pragma mark - Lifecycle Method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(changeHouseWithNotification:)
                                               name:@"ChangeHouse"
                                             object:nil];
    [self setupUI];
    [self requestHouseList];
   
    
    [TuyaCommunityVisualSpeakManager.shareInstance addDelegate:self];
}

#pragma mark - Private Method

- (void)setupUI {
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"House";
    
    UIButton *houseListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    houseListBtn.backgroundColor = UIColor.blueColor;
    [houseListBtn setTitle:@"House management" forState:UIControlStateNormal];
    [houseListBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [houseListBtn addTarget:self action:@selector(didHouseListBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:houseListBtn];
    [houseListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.leading.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(35);
    }];
    
    UIButton *changeHouseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeHouseBtn.backgroundColor = UIColor.blueColor;
    [changeHouseBtn setTitle:@"Change house" forState:UIControlStateNormal];
    [changeHouseBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [changeHouseBtn addTarget:self action:@selector(didChangeHouseBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeHouseBtn];
    [changeHouseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(houseListBtn.mas_bottom).offset(10);
        make.leading.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(35);
    }];
        
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.backgroundColor = UIColor.blueColor;
    [logoutBtn setTitle:@"Logout" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(didLogoutBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(35);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);
        } else {
            make.bottom.equalTo(self.view).offset(-10);
        }
    }];
    
    self.houseInfoView = [TuyaCommunityHouseInfoView new];
    [self.view addSubview:self.houseInfoView];
    [self.houseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
        make.top.equalTo(changeHouseBtn.mas_bottom).offset(30);
        make.bottom.equalTo(logoutBtn.mas_top).offset(-10);
    }];
}

#pragma mark - Data

- (void)requestHouseList {
    __weak __typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.houseManager getHouseListWithSuccess:^(NSArray<TuyaCommunityHouseModel *> * _Nonnull list) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.houseList = list;
        if (list.count > 0) {
            int index = -1;
            for (int i = 0; i < list.count; i++) {
                TuyaCommunityHouseModel *model = list[i];
                if (model.houseId == TuyaCommunityManager.sharedInstance.currentHouseId) index = i;
            }
            
            index = index != -1 ? index : 0;
            TuyaCommunityHouseModel *model = list[index];
            [TuyaCommunityManager.sharedInstance updateCurrentHouseId:model.houseId];
            [strongSelf requestHouseDetail];
        } else {
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"current account has no house.";
            hud.label.numberOfLines = 0;
            hud.removeFromSuperViewOnHide = YES;
            hud.userInteractionEnabled = NO;
            [hud hideAnimated:YES afterDelay:1.0];
        }
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        NSLog(@"%@", error);
    }];
}

- (void)requestHouseDetail {
    long long houseId = TuyaCommunityManager.sharedInstance.currentHouseId;
    self.currentHouse = [TuyaCommunityHouse houseWithHouseId:houseId];
    
    __weak __typeof(self) weakSelf = self;
    [self.currentHouse getHouseDetailWithSuccess:^(TuyaCommunityHouseModel * _Nonnull result) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        strongSelf.houseInfoView.model = result;
        [strongSelf.houseInfoView reloadData];
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        NSLog(@"%@", error);
    }];
}

#pragma mark - Event

- (void)changeHouseWithNotification:(NSNotification *)notification {
    TuyaCommunityHouseModel *model = notification.userInfo[@"house"];
    [TuyaCommunityManager.sharedInstance updateCurrentHouseId:model.houseId];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestHouseDetail];
}

- (void)didHouseListBtnPressed {
    TuyaCommunityHouseListViewController *vc = [TuyaCommunityHouseListViewController new];
    vc.houseList = self.houseList;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didChangeHouseBtnPressed {
    TuyaCommunityChangeHouseViewController *vc = [TuyaCommunityChangeHouseViewController new];
    vc.houseList = self.houseList;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didLogoutBtnPressed {
    [TuyaSmartUser.sharedInstance loginOut:^{
        UIViewController *vc = TuyaCommunityManager.sharedInstance.mainViewController;
        UIApplication.sharedApplication.keyWindow.rootViewController = vc;
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - TuyaCommunityHouseManagerDelegate

- (void)houseManager:(TuyaCommunityHouseManager *)houseManager didAddHouse:(TuyaCommunityHouseModel *)house {
    [self requestHouseList];
}

- (void)houseManager:(TuyaCommunityHouseManager *)houseManager didRemoveHouse:(long long)houseId {
    [self requestHouseList];
}

#pragma mark - TuyaCommunityVisualSpeakManagerDelegate

- (void)receiveDeviceMessageWithMessageModel:(TuyaCommunityVisualSpeakDeviceMessageModel *)messageModel {
    // cross house is not recommended
    if (![TuyaCommunityManager.sharedInstance.currentHouseModel.roomId isEqualToString:messageModel.roomId]) {
        return;
    }
    
    if (messageModel.type == TuyaCommunityVisualSpeakCommunicationTypeCalling) {
        TuyaCommunityAccessControlCallViewController *vc = [[TuyaCommunityAccessControlCallViewController alloc] init];
        vc.messageModel = messageModel;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - Getter

- (TuyaCommunityHouseManager *)houseManager {
    if (!_houseManager) {
        _houseManager = [TuyaCommunityHouseManager new];
        _houseManager.delegate = self;
    }
    
    return _houseManager;
}

@end
