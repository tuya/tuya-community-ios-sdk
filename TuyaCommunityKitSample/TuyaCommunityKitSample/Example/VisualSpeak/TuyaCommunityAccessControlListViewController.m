//
//
//  TuyaCommunityAccessControlListViewController.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//  
    

#import "TuyaCommunityAccessControlListViewController.h"
#import "TuyaCommunityAccessControlDetailViewController.h"

@interface TuyaCommunityAccessControlListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TuyaCommunityAccessControlService *service;
@property (nonatomic, strong) NSArray<TuyaCommunityAccessControlModel *> *accessControlList;

@end

@implementation TuyaCommunityAccessControlListViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self getAccessControlListData];
}

#pragma mark - layout

- (void)setupSubviews {
    self.title = @"access control";
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 40;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:self.tableView];
}

#pragma mark - data

- (void)getAccessControlListData {
    TuyaCommunityHouseModel *model = TuyaCommunityManager.sharedInstance.currentHouseModel;
    [self.service getAccessControlListWithCommunityId:model.communityId roomId:model.roomId success:^(NSArray<TuyaCommunityAccessControlModel *> * _Nonnull list) {
        self.accessControlList = list;
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"get access control list failure: %@", error.localizedDescription);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accessControlList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TuyaCommunityAccessControlModel *model = self.accessControlList[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = model.deviceName;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TuyaCommunityAccessControlModel *model = self.accessControlList[indexPath.row];

    [TuyaCommunityVisualSpeakManager.shareInstance loadConfigWithDeviceId:model.deviceId gatewayId:nil success:^{
        TuyaCommunityAccessControlDetailViewController *vc = [[TuyaCommunityAccessControlDetailViewController alloc] init];
        vc.accessControlModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"load config error: %@", error.localizedDescription);
    }];
}

#pragma mark - getters & setters & init members

- (TuyaCommunityAccessControlService *)service {
    if (!_service) {
        _service = [[TuyaCommunityAccessControlService alloc] init];
    }
    return _service;
}



@end
