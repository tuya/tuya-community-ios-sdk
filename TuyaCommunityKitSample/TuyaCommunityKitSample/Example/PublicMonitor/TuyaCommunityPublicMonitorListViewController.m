//
//  TYSQPublicMonitoringViewController.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityPublicMonitorListViewController.h"
#import "TuyaCommunityPublicMonitorDetailViewController.h"

@interface TuyaCommunityPublicMonitorListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TuyaCommunityPublicMonitorService *service;
@property (nonatomic, strong) NSArray<TuyaCommunityPublicMonitorModel *> *monitorList;

@end

@implementation TuyaCommunityPublicMonitorListViewController


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self getPublicMonitorListData];
}

#pragma mark - layout

- (void)setupSubviews {
    self.title = @"public monitor";
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 40;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:self.tableView];
}

#pragma mark - data

- (void)getPublicMonitorListData {
    TuyaCommunityHouseModel *model = TuyaCommunityManager.sharedInstance.currentHouseModel;
    [self.service getPublicMonitorListWithCommunityId:model.communityId roomId:model.roomId success:^(NSArray<TuyaCommunityPublicMonitorModel *> * _Nonnull list) {
        self.monitorList = list;
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"get public monitor list failure: %@", error.localizedDescription);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.monitorList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TuyaCommunityPublicMonitorModel *model = self.monitorList[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = model.deviceName;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TuyaCommunityPublicMonitorModel *model = self.monitorList[indexPath.row];

    [TuyaCommunityVisualSpeakManager.shareInstance loadConfigWithDeviceId:model.deviceId gatewayId:model.gatewayId success:^{
        TuyaCommunityPublicMonitorDetailViewController *vc = [[TuyaCommunityPublicMonitorDetailViewController alloc] init];
        vc.monitorModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - getters & setters & init members

- (TuyaCommunityPublicMonitorService *)service {
    if (!_service) {
        _service = [[TuyaCommunityPublicMonitorService alloc] init];
    }
    return _service;
}

@end
