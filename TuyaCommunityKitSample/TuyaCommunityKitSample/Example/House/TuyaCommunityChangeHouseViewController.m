//
//  TuyaCommunityChangeHouseViewController.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityChangeHouseViewController.h"
#import "TuyaCommunityHouseCell.h"

@interface TuyaCommunityChangeHouseViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation TuyaCommunityChangeHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - Private Method

- (void)setupUI {
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"Change house";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.rowHeight = [TuyaCommunityHouseCell cellHeight];
    [self.tableView registerClass:TuyaCommunityHouseCell.class forCellReuseIdentifier:@"Cell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.houseList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TuyaCommunityHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.showDelete = NO;
    cell.model = self.houseList[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *data = @{}.mutableCopy;
    data[@"house"] = self.houseList[indexPath.row];
    [NSNotificationCenter.defaultCenter postNotificationName:@"ChangeHouse" object:nil userInfo:data.copy];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
