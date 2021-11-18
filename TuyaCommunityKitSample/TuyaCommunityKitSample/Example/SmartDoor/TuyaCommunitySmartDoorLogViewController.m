//
//  TuyaCommunitySmartDoorLogViewController.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunitySmartDoorLogViewController.h"

@interface TuyaCommunitySmartDoorLogViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TuyaCommunitySmartDoorService *service;
@property (nonatomic, strong) NSArray<TuyaCommunitySmartDoorOpenRecordModel *> *models;

@end

@implementation TuyaCommunitySmartDoorLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    _service = [[TuyaCommunitySmartDoorService alloc] init];
    __weak __typeof(self) weakSelf = self;
    TuyaCommunityHouseModel *houseModel = TuyaCommunityManager.sharedInstance.currentHouseModel;
    [self.service getSmartDoorOpenRecordsWithCommunityId:houseModel.communityId
                                                  roomId:houseModel.roomId
                                                 success:^(NSArray<TuyaCommunitySmartDoorOpenRecordModel *> * _Nonnull models) {
        weakSelf.models = models;
        [weakSelf.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    TuyaCommunitySmartDoorOpenRecordModel *model = self.models[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate dateWithTimeIntervalSince1970:model.accessTime/1000.f]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",model.accessControlAddress];
    cell.detailTextLabel.text = dateString;
    return cell;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 40;
    }
    return _tableView;
}


@end
