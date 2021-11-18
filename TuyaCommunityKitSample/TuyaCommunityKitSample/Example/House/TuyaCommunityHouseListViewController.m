//
//  TuyaCommunityHouseListViewController.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityHouseListViewController.h"
#import "TuyaCommunityHouseCell.h"
#import "TuyaCommunityMemberListViewController.h"
#import "TuyaCommunitySelectHouseViewController.h"
#import "TuyaCommunityNavigationController.h"
#import "TuyaCommunityUserCertificationViewController.h"

@interface TuyaCommunityHouseListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) TuyaCommunityHouseManager *houseManager;

@property (nonatomic, strong) TuyaCommunityHouseMemberService *memberService;

@end

@implementation TuyaCommunityHouseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - Private Method

- (void)setupUI {
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"My house list";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add house"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                            action:@selector(addHouse)];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = [TuyaCommunityHouseCell cellHeight];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerClass:TuyaCommunityHouseCell.class forCellReuseIdentifier:@"Cell"];
}

- (void)addHouse {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(self) weakSelf = self;
    [self.memberService getUserCertificationInfoWithSuccess:^(TuyaCommunityUserCertificationInfoModel * _Nonnull result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        BOOL isCertified = result.userIdentificationStatus == TuyaCommunityUserCertificationStatusVerified;
        if (!isCertified) {
            TuyaCommunityUserCertificationViewController *vc = [TuyaCommunityUserCertificationViewController new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            return;
        }
        
        TuyaCommunitySelectHouseViewController *vc = [TuyaCommunitySelectHouseViewController new];
        vc.stepType = TuyaCommunitySelectHouseStepTypeCommunity;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        NSLog(@"%@", error);
    }];
}

- (void)deleteHouseAtIndexPath:(NSIndexPath *)indexPath {
    TuyaCommunityHouseModel *houseModel = self.houseList[indexPath.row];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(self) weakSelf = self;
    
    switch (houseModel.auditStatus) {
        case TuyaCommunityHouseAuditStatusPass: {
            [self.houseManager moveOutHouseWithCommunityId:houseModel.communityId
                                                roomUserId:houseModel.roomUserId
                                                   success:^{
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            } failure:^(NSError * _Nonnull error) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                NSLog(@"%@", error);
            }];
        }
            break;
        default: {
            [self.houseManager deleteHouseWithCommunityId:houseModel.communityId
                                                  houseId:houseModel.houseId
                                                  success:^{
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            } failure:^(NSError * _Nonnull error) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                NSLog(@"%@", error);
            }];
        }
            break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.houseList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TuyaCommunityHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.showDelete = YES;
    cell.model = self.houseList[indexPath.row];
    
    __weak __typeof(self) weakSelf = self;
    cell.deleteBlock = ^{
        [weakSelf deleteHouseAtIndexPath:indexPath];
    };
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TuyaCommunityMemberListViewController *vc = [TuyaCommunityMemberListViewController new];
    vc.houseModel = self.houseList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getter

- (TuyaCommunityHouseManager *)houseManager {
    if (!_houseManager) {
        _houseManager = [TuyaCommunityHouseManager new];
    }
    
    return _houseManager;
}

- (TuyaCommunityHouseMemberService *)memberService {
    if (!_memberService) {
        _memberService = [TuyaCommunityHouseMemberService new];
    }
    
    return _memberService;
}

@end
