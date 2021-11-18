//
//  TuyaCommunitySelectHouseViewController.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunitySelectHouseViewController.h"
#import "TuyaCommunityAddHouseViewController.h"

@interface TuyaCommunitySelectHouseViewController ()

@property (nonatomic, strong) TuyaCommunityHouseManager *houseManager;

@property (nonatomic, copy) NSArray<TuyaCommunityListModel *> *communityList;

@property (nonatomic, copy) NSArray<TuyaCommunityHouseTreeModel *> *houseTreeList;

@end

@implementation TuyaCommunitySelectHouseViewController

#pragma mark - Lifecycle Method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self requestData];
}

#pragma mark - Private Method

- (void)setupUI {
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navigationItem.title =
    self.stepType == TuyaCommunitySelectHouseStepTypeCommunity ?
    @"Select community" :
    @"Select house";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 40;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.stepType == TuyaCommunitySelectHouseStepTypeCommunity ?
    self.communityList.count:
    1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stepType == TuyaCommunitySelectHouseStepTypeCommunity ?
    self.communityList[section].list.count :
    self.houseTreeList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (self.stepType == TuyaCommunitySelectHouseStepTypeCommunity) {
        TuyaCommunityModel *model = self.communityList[indexPath.section].list[indexPath.row];
        cell.textLabel.text = model.communityName;
    } else {
        TuyaCommunityHouseTreeModel *model = self.houseTreeList[indexPath.row];
        cell.textLabel.text = model.spaceTreeName;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    TuyaCommunityListModel *model = self.communityList[section];
    
    return model.city;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.stepType == TuyaCommunitySelectHouseStepTypeCommunity) {
        TuyaCommunityModel *model = self.communityList[indexPath.section].list[indexPath.row];
        TuyaCommunitySelectHouseViewController *vc = [TuyaCommunitySelectHouseViewController new];
        vc.stepType = TuyaCommunitySelectHouseStepTypeHouse;
        vc.communityModel = model;
        vc.spaceTreeId = model.communityId;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        TuyaCommunityHouseTreeModel *model = self.houseTreeList[indexPath.row];
        if (!model.hasMore) {
            TuyaCommunityAddHouseViewController *vc = [TuyaCommunityAddHouseViewController new];
            vc.communityModel = self.communityModel;
            vc.spaceTreeId = model.spaceTreeId;
            vc.houseName = [NSString stringWithFormat:@"%@%@", self.houseName?:@"", model.spaceTreeName];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        
        TuyaCommunitySelectHouseViewController *vc = [TuyaCommunitySelectHouseViewController new];
        vc.stepType = TuyaCommunitySelectHouseStepTypeHouse;
        vc.communityModel = self.communityModel;
        vc.spaceTreeId = model.spaceTreeId;
        vc.houseName = [NSString stringWithFormat:@"%@%@", self.houseName?:@"", model.spaceTreeName];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Data

- (void)requestData {
    __weak __typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.stepType == TuyaCommunitySelectHouseStepTypeCommunity) {
        [self.houseManager getCommunityListWithKeyword:@""
                                              latitude:0
                                             longitude:0
                                               success:^(NSArray<TuyaCommunityListModel *> * _Nonnull list) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            weakSelf.communityList = list;
            [weakSelf.tableView reloadData];
        } failure:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            NSLog(@"%@", error);
        }];
    } else {
        [self.houseManager getHouseTreeListWithTreeId:self.spaceTreeId
                                              success:^(NSArray<TuyaCommunityHouseTreeModel *> * _Nonnull list) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            weakSelf.houseTreeList = list;
            [weakSelf.tableView reloadData];
        } failure:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            NSLog(@"%@", error);
        }];
    }
}

#pragma mark - Getter

- (TuyaCommunityHouseManager *)houseManager {
    if (!_houseManager) {
        _houseManager = [TuyaCommunityHouseManager new];
    }
    
    return _houseManager;
}

@end
