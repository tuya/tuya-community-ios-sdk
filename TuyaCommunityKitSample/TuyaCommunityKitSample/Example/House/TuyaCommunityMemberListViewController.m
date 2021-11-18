//
//  TuyaCommunityMemberListViewController.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityMemberListViewController.h"
#import "TuyaCommunityManager.h"
#import "TuyaCommunityHouseCell.h"
#import "TuyaCommunityAddMemberViewController.h"

@interface TuyaCommunityMemberListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TuyaCommunityHouseMemberService *service;

@property (nonatomic, copy) NSArray<TuyaCommunityMemberModel *> *members;

@property (nonatomic, copy) NSArray<TuyaCommunityMemberModel *> *movedoutMembers;

@property (nonatomic, strong) TuyaCommunityCosoleView *consoleView;

@end

@implementation TuyaCommunityMemberListViewController

#pragma mark - Liefecycle Method

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestMemberList];
}

#pragma mark - Private Method

- (void)setupUI {
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"Member List";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add member"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(addMember)];

    self.consoleView = [TuyaCommunityCosoleView new];
    self.consoleView.title = @"Member detail's json:";
    [self.view addSubview:self.consoleView];
    [self.consoleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.bottom.equalTo(self.view).offset(-10);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(170);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.rowHeight = [TuyaCommunityHouseCell cellHeight];
    [self.tableView registerClass:TuyaCommunityHouseCell.class forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.consoleView.mas_top).offset(-5);
    }];
}

- (void)addMember {
    TuyaCommunityAddMemberViewController *vc = [TuyaCommunityAddMemberViewController new];
    vc.houseModel = self.houseModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Data

- (void)requestMemberList {
    __weak __typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [self.service getMemberListWithCommunityId:self.houseModel.communityId
                                       houseId:self.houseModel.houseId
                                       success:^(NSArray<TuyaCommunityMemberModel *> * _Nonnull list) {
        weakSelf.members = list;
        dispatch_group_leave(group);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self.service getMoveOutMemberListWithCommunityId:self.houseModel.communityId
                                              houseId:self.houseModel.houseId success:^(NSArray<TuyaCommunityMemberModel *> * _Nonnull list) {
        weakSelf.movedoutMembers = list;
        dispatch_group_leave(group);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.consoleView cleanContent];
        [weakSelf.tableView reloadData];
    });
}

- (void)requestMemberDetailWithMember:(TuyaCommunityMemberModel *)member {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(self) weakSelf = self;
    [self.service getMemberDetailWithCommunityId:self.houseModel.communityId
                                      roomUserId:member.roomUserId
                                         success:^(TuyaCommunityMemberModel * _Nonnull result) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        [strongSelf.consoleView updateContentWithModel:result];
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        NSLog(@"%@", error);
    }];
}

- (void)requestMovedoutMemberDetailWithMember:(TuyaCommunityMemberModel *)member {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(self) weakSelf = self;
    [self.service getMoveOutMemberDetailWithCommunityId:self.houseModel.communityId
                                             roomUserId:member.roomUserId
                                                success:^(TuyaCommunityMemberModel * _Nonnull result) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        [strongSelf.consoleView updateContentWithModel:result];
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        NSLog(@"%@", error);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.members.count : self.movedoutMembers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TuyaCommunityHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.showDelete = NO;
    NSArray *list = indexPath.section == 0 ? self.members : self.movedoutMembers;
    cell.memberModel = list[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? @"Members" : @"Moved out members";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            [self requestMemberDetailWithMember:self.members[indexPath.row]];
            break;
        case 1:
            [self requestMovedoutMemberDetailWithMember:self.movedoutMembers[indexPath.row]];
            break;
        default:
            break;
    }
}

#pragma mark - Getter

- (TuyaCommunityHouseMemberService *)service {
    if (!_service) {
        _service = [TuyaCommunityHouseMemberService new];
    }
    
    return _service;
}

@end
