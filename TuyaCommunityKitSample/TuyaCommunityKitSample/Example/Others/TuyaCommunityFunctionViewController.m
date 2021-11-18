//
//  TuyaCommunityFunctionViewController.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityFunctionViewController.h"
#import "TuyaCommunitySmartDoorViewController.h"
#import "TuyaCommunityVisitorViewController.h"
#import "TuyaCommunityAccessControlListViewController.h"
#import "TuyaCommunityPublicMonitorListViewController.h"

@interface TuyaCommunityFunctionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSDictionary<NSString *, NSString *> *viewControllerMap;

@property (nonatomic, copy) NSArray<Class> *viewControllerList;

@end

@implementation TuyaCommunityFunctionViewController

#pragma mark - Lifecycle Method

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self setupUI];
}

#pragma mark - Private Method

- (void)setupUI {
    self.navigationItem.title = @"Function";
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 40;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewControllerList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    Class cls = self.viewControllerList[indexPath.row];
    cell.textLabel.text = self.viewControllerMap[NSStringFromClass(cls)];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Class cls = self.viewControllerList[indexPath.row];
    
    [self.navigationController pushViewController:[cls new] animated:YES];
}

#pragma mark - Getter

- (NSArray *)viewControllerList {
    if (!_viewControllerList) {
        _viewControllerList = @[
            TuyaCommunitySmartDoorViewController.class,
            TuyaCommunityVisitorViewController.class,
            TuyaCommunityAccessControlListViewController.class,
            TuyaCommunityPublicMonitorListViewController.class
        ];
    }
    
    return _viewControllerList;
}

- (NSDictionary *)viewControllerMap {
    if (!_viewControllerMap) {
        _viewControllerMap = @{
            NSStringFromClass(TuyaCommunitySmartDoorViewController.class) : @"Smart Door",
            NSStringFromClass(TuyaCommunityVisitorViewController.class) : @"Visitors to traffic",
            NSStringFromClass(TuyaCommunityAccessControlListViewController.class) : @"Visual Speak",
            NSStringFromClass(TuyaCommunityPublicMonitorListViewController.class) : @"Public Monitor"
        };
    }
    
    return _viewControllerMap;
}

@end

