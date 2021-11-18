//
//  TuyaCommunityQrCodeViewController.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityQrCodeViewController.h"
#import "UIImage+TYQRCode.h"

@interface TuyaCommunityQrCodeViewController ()

@property (nonatomic, strong) UIImageView *qrCodeImageView;/**<  QRCode Image */

@property (nonatomic, strong) TuyaCommunitySmartDoorService *service;

@end

@implementation TuyaCommunityQrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    _qrCodeImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.qrCodeImageView];
    [self.qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(250);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(200);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"QR Code Can Control Entrance:";
    titleLabel.textColor = UIColor.blackColor;
    titleLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *doorTitleLabel = [[UILabel alloc] init];
    doorTitleLabel.textColor = UIColor.blackColor;
    doorTitleLabel.font = [UIFont systemFontOfSize:16];
    doorTitleLabel.numberOfLines = 0;
    
    UILabel *elevatorTitleLabel = [[UILabel alloc] init];
    elevatorTitleLabel.textColor = UIColor.blackColor;
    elevatorTitleLabel.font = [UIFont systemFontOfSize:16];
    elevatorTitleLabel.numberOfLines = 0;
    
    [self.view addSubview:titleLabel];
    [self.view addSubview:doorTitleLabel];
    [self.view addSubview:elevatorTitleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.qrCodeImageView.mas_bottom).offset(20);
        
    }];
    [doorTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(20);
    }];
    [elevatorTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(doorTitleLabel.mas_bottom).offset(20);
    }];
    
    
    TuyaCommunityHouseModel *houseModel = TuyaCommunityManager.sharedInstance.currentHouseModel;
    _service = [[TuyaCommunitySmartDoorService alloc] init];
    __weak __typeof(self) weakSelf = self;
    [_service getCommunityQrCodeWithCommunityId:houseModel.communityId roomId:houseModel.roomId success:^(TuyaCommunityQRCodeModel * _Nonnull model) {
        weakSelf.qrCodeImageView.image = [UIImage ty_qrCodeWithString:model.qrCodeUrl width:250];
        doorTitleLabel.text = [NSString stringWithFormat:@"door:%@",[model.accessDoorList componentsJoinedByString:@","]];
        elevatorTitleLabel.text = [NSString stringWithFormat:@"elevator:%@",[model.accessElevatorList componentsJoinedByString:@","]];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
}






@end
