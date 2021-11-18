//
//  TuyaCommunitySmartDoorViewController.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunitySmartDoorViewController.h"
#import "TuyaCommunitySmartDoorLogViewController.h"
#import "TuyaCommunityQrCodeViewController.h"

@interface TuyaCommunitySmartDoorViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TuyaCommunitySmartDoorService *service;
@property (nonatomic, strong) NSArray<TuyaCommunitySmartDoorInfoModel *> *models;/**<  datas */
@property (nonatomic, assign) NSTimeInterval currentTime;

@property (nonatomic, strong) UIButton *logButton;/**<  Log Button */
@property (nonatomic, strong) UIButton *qrCodeBtn;/**<  QRCode */

@end

@implementation TuyaCommunitySmartDoorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Smart Door";
    self.view.backgroundColor = UIColor.whiteColor;
    
    _logButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_logButton setTitle:@"Log" forState:UIControlStateNormal];
    [_logButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [_logButton addTarget:self action:@selector(onClickLog)
         forControlEvents:UIControlEventTouchUpInside];
    [_logButton sizeToFit];
    
    _qrCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_qrCodeBtn setTitle:@"QRCode" forState:UIControlStateNormal];
    [_qrCodeBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [_qrCodeBtn addTarget:self action:@selector(onClickQRCode)
         forControlEvents:UIControlEventTouchUpInside];
    [_qrCodeBtn sizeToFit];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithCustomView:self.logButton];
    
    self.navigationItem.rightBarButtonItems = @[
        [[UIBarButtonItem alloc] initWithCustomView:self.logButton],
        [[UIBarButtonItem alloc] initWithCustomView:self.qrCodeBtn],
    ];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    _service = [[TuyaCommunitySmartDoorService alloc] init];
    TuyaCommunityHouseModel *houseModel = TuyaCommunityManager.sharedInstance.currentHouseModel;
    __weak __typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [weakSelf.service getSmartDoorListWithCommunityId:houseModel.communityId
                                               roomId:houseModel.roomId
                                              success:^(NSArray<TuyaCommunitySmartDoorInfoModel *> * _Nonnull models) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        weakSelf.models = models;
        [weakSelf.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
}

- (void)onClickLog {
    [self.navigationController pushViewController:TuyaCommunitySmartDoorLogViewController.new
                                         animated:YES];
}

- (void)onClickQRCode {
    [self.navigationController pushViewController:TuyaCommunityQrCodeViewController.new
                                         animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    TuyaCommunitySmartDoorInfoModel *model = self.models[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = model.deviceName;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TuyaCommunitySmartDoorInfoModel *model = self.models[indexPath.row];
    [self openDoorWithModel:model];
}

- (void)openDoorWithModel:(TuyaCommunitySmartDoorInfoModel *)model {
    TuyaCommunityHouseModel *houseModel = TuyaCommunityManager.sharedInstance.currentHouseModel;
    __weak __typeof(self) weakSelf = self;
    [weakSelf.service openDoorWithCommunityId:houseModel.communityId roomId:houseModel.roomId deviceId:model.deviceId success:^(NSString * _Nonnull accessLogId) {
        weakSelf.currentTime = [[NSDate date] timeIntervalSince1970];
        [weakSelf getOpenReustWithLogId:accessLogId];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
}

- (void)getOpenReustWithLogId:(NSString *)logId {
    __weak __typeof(self) weakSelf = self;
    TuyaCommunityHouseModel *houseModel = TuyaCommunityManager.sharedInstance.currentHouseModel;
    [self.service checkOpenDoorResultWithCommunityId:houseModel.communityId accessLogId:logId success:^(TuyaCommunitySmartDoorOpenResult result) {
        switch (result) {
            case TuyaCommunitySmartDoorOpenResultOpening: {
                NSTimeInterval outTime = [[NSDate date] timeIntervalSince1970];
                if (outTime - self.currentTime > 3000.f) {
                    NSLog(@"Open Door Failure");
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = @"Open Door Failure.";
                    hud.label.numberOfLines = 0;
                    hud.removeFromSuperViewOnHide = YES;
                    hud.userInteractionEnabled = NO;
                    [hud hideAnimated:YES afterDelay:1.0];
                } else {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf getOpenReustWithLogId:logId];
                    });
                }
            }
                break;
            case TuyaCommunitySmartDoorOpenResultSuccess: {
                NSLog(@"Open Door Success");
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"Open Door Success.";
                hud.label.numberOfLines = 0;
                hud.removeFromSuperViewOnHide = YES;
                hud.userInteractionEnabled = NO;
                [hud hideAnimated:YES afterDelay:1.0];
                break;
            }
            case TuyaCommunitySmartDoorOpenResultFailure: {
                NSLog(@"Open Door Failure");
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"Open Door Failure.";
                hud.label.numberOfLines = 0;
                hud.removeFromSuperViewOnHide = YES;
                hud.userInteractionEnabled = NO;
                [hud hideAnimated:YES afterDelay:1.0];
                
            }
            default:
                break;
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"UITableViewCell"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 40;
    }
    return _tableView;
}

@end
