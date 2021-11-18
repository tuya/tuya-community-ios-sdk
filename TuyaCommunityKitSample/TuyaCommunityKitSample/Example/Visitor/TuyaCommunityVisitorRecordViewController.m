//
//  TuyaCommunityVisitorRecordViewController.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityVisitorRecordViewController.h"
#import "TuyaCommunityVisitorRecordCell.h"
#import "TuyaCommunityVisitorDetailsViewController.h"

@interface TuyaCommunityVisitorRecordViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) TuyaCommunityVisitorService *requestService;
@property (nonatomic, strong) TuyaCommunityHouse *currentHouse;
@property (nonatomic, strong) NSArray<TuyaCommunityVisitorModel *>*visitorRecordLists;


@end

@implementation TuyaCommunityVisitorRecordViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self requestData];
}

#pragma mark - layout

- (void)setupUI {
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"VisitorRecord";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.estimatedRowHeight = 36;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView registerClass:TuyaCommunityVisitorRecordCell.class forCellReuseIdentifier:@"cell"];
}

#pragma mark - data

- (void)requestData {
    long long houseId = TuyaCommunityManager.sharedInstance.currentHouseId;
    self.currentHouse = [TuyaCommunityHouse houseWithHouseId:houseId];
    [self.requestService getVisitorRecordListWithCommunityId:self.currentHouse.houseModel.communityId roomId:self.currentHouse.houseModel.roomId pageNo:1 pageSize:100 success:^(TuyaCommunityVisitorRecordListModel * _Nonnull result) {
        NSLog(@"%@",result.data);
        self.visitorRecordLists = result.data;
        [self.tableView reloadData];
     } failure:^(NSError * _Nonnull error) {
         NSLog(@"%@",error);
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.visitorRecordLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TuyaCommunityVisitorRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.visitorRecordLists[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TuyaCommunityVisitorModel *model = self.visitorRecordLists[indexPath.row];
    TuyaCommunityVisitorDetailsViewController *vc = [TuyaCommunityVisitorDetailsViewController new];
    vc.visitorId = model.visitorId;
    vc.visitorStatusStr = model.visitorStatusStr;
    vc.visitorStatus = model.visitorStatus;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - event response
#pragma mark - custom delegate
#pragma mark - notification
#pragma mark - public methods
#pragma mark - private methods

#pragma mark - Getter

- (TuyaCommunityVisitorService *)requestService {
    if (!_requestService) {
        _requestService = TuyaCommunityVisitorService.new;
    }
    return _requestService;
}

@end
