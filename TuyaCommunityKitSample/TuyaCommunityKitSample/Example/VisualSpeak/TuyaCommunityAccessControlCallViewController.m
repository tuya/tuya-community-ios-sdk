//
//
//  TuyaCommunityAccessControlCallViewController.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//  
    

#import "TuyaCommunityAccessControlCallViewController.h"
#import <TuyaSmartCameraKit/TuyaSmartCameraKit.h>

@interface TuyaCommunityAccessControlCallViewController () <TuyaSmartCameraDelegate, TuyaCommunityVisualSpeakManagerDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIButton *openDoorButton;
@property (nonatomic, strong) UIButton *acceptButton;
@property (nonatomic, strong) UIButton *hangUpButton;
@property (nonatomic, strong) UIButton *rejectButton;

@property (nonatomic, strong) TuyaCommunityAccessControlService *service;

@property (nonatomic, strong) TuyaSmartDevice *device;
@property (nonatomic, strong) id<TuyaSmartCameraType> camera;

@property (nonatomic, assign) BOOL isAcceptYourself;

@end

@implementation TuyaCommunityAccessControlCallViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.camera disConnect];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [self.camera disConnect];
    self.camera = nil;
}

#pragma mark - data

- (void)initData {

    [TuyaCommunityVisualSpeakManager.shareInstance loadConfigWithDeviceId:self.messageModel.deviceId gatewayId:nil success:^{
        [TuyaCommunityVisualSpeakManager.shareInstance addDelegate:self];
        
        self.device = [TuyaSmartDevice deviceWithDeviceId:self.messageModel.deviceId];

        self.camera = [TuyaSmartCameraFactory cameraWithP2PType:@(self.device.deviceModel.p2pType) deviceId:self.messageModel.deviceId delegate:self];
        [self.camera connectWithMode:TuyaSmartCameraConnectAuto];
        
        [self.view addSubview:self.camera.videoView];
        self.camera.videoView.backgroundColor = [UIColor lightGrayColor];
        self.camera.videoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width / 16 * 9);
        self.camera.videoView.center = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
        
        self.titleLabel.text = self.device.deviceModel.name;
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"load config failure: %@", error.localizedDescription);
        [self hide];
    }];
}

#pragma mark - layout

- (void)initView {
    self.view.backgroundColor = UIColor.blackColor;
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.subTitleLabel];
    [self.view addSubview:self.openDoorButton];
    [self.view addSubview:self.rejectButton];
    [self.view addSubview:self.hangUpButton];
    [self.view addSubview:self.acceptButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(88 + 20);
        make.centerX.offset(0);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.centerX.offset(0);
    }];
    [self.openDoorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.height.equalTo(@45);
        make.bottom.offset(-100);
    }];
    
    [self.rejectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.openDoorButton.mas_left).offset(-30);
        make.height.equalTo(@45);
        make.bottom.offset(-100);
    }];
    
    [self.hangUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rejectButton);
        make.height.equalTo(@45);
        make.top.equalTo(self.rejectButton.mas_bottom).offset(20);
    }];
    
    [self.acceptButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.openDoorButton.mas_right).offset(30);
        make.height.equalTo(@45);
        make.bottom.offset(-100);
    }];
}

#pragma mark - event response

- (void)clickOpenDoorButton {
    TuyaCommunityHouseModel *model = TuyaCommunityManager.sharedInstance.currentHouseModel;
    
    [self.service openDoorWithCommunityId:model.communityId roomId:model.roomId deviceId:self.messageModel.deviceId success:^(id  _Nonnull result) {
        [MBProgressHUD showToasterWithText:@"open the door successfully" toView:self.view];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"open door failure : %@", error.localizedDescription);
    }];
}

- (void)clickAcceptButton {
    [self.camera startTalk];
}

- (void)clickRejectButton {
    TuyaCommunityHouseModel *model = TuyaCommunityManager.sharedInstance.currentHouseModel;
    WEAKSELF_TYSDK
    [self.service rejectWithCommunityId:model.communityId roomId:self.messageModel.roomId deviceId:self.messageModel.deviceId sn:self.messageModel.sn success:^(id  _Nonnull result) {
        [weakSelf_TYSDK hide];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"reject failure:%@", error.localizedDescription);
        [weakSelf_TYSDK hide];
    }];
}

- (void)clickHangUpButton {
    [self.service hangUpWithDeviceId:self.messageModel.deviceId success:nil failure:nil];
    [self hide];
    self.isAcceptYourself = NO;
}

#pragma mark - TuyaCommunityVisualSpeakManagerDelegate

- (void)receiveDeviceMessageWithMessageModel:(TuyaCommunityVisualSpeakDeviceMessageModel *)messageModel {
    if (![messageModel.deviceId isEqualToString:self.messageModel.deviceId]) { return; }
    
    switch (messageModel.type) {
        case 6:
            if (!self.isAcceptYourself) {
                [self hide];
            }
            break;
        case 3:
        case 4:
        case 5: 
            [self hide];
            break;
        default:
            break;
    }
}

#pragma mark - TuyaSmartCameraDelegate

- (void)cameraDidConnected:(id<TuyaSmartCameraType>)camera {
    NSLog(@"connect");
    [self.camera startPreview];
}

- (void)cameraDisconnected:(id<TuyaSmartCameraType>)camera {
    NSLog(@"camera disconnected");
}

- (void)cameraDidBeginPreview:(id<TuyaSmartCameraType>)camera {
    NSLog(@"begin preview");
    self.acceptButton.hidden = NO;
}

- (void)cameraDidStopPreview:(id<TuyaSmartCameraType>)camera {
    NSLog(@"stop preview");
}

- (void)cameraDidBeginTalk:(id<TuyaSmartCameraType>)camera {
    NSLog(@"begin talk");
    [self.service acceptWithDeviceId:self.messageModel.deviceId success:nil failure:nil];
    self.subTitleLabel.text = @"connected";
    self.isAcceptYourself = YES;
    self.acceptButton.hidden = YES;
    self.rejectButton.hidden = YES;
    self.hangUpButton.hidden = NO;
}

- (void)cameraDidStopTalk:(id<TuyaSmartCameraType>)camera {
    NSLog(@"stop talk");
}

// error callback
- (void)camera:(id<TuyaSmartCameraType>)camera didOccurredErrorAtStep:(TYCameraErrorCode)errStepCode specificErrorCode:(NSInteger)errorCode {
    NSLog(@"errorCode: %ld", errorCode);
}

#pragma mark - private methords

- (void)hide {
    
    [self.camera stopTalk];
    [self.camera stopPreview];
    [self.camera disConnect];
    self.camera = nil;
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - getters & setters & init members

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = UIColor.whiteColor;
        _subTitleLabel.alpha = 0.6;
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _subTitleLabel.text = @"connecting ...";
    }
    return _subTitleLabel;
}

- (UIButton *)openDoorButton {
    if (!_openDoorButton) {
        UIButton *make = [UIButton buttonWithType:UIButtonTypeCustom];
        make.backgroundColor = UIColor.blueColor;
        make.titleLabel.textColor = UIColor.whiteColor;
        make.titleLabel.font = [UIFont systemFontOfSize:16];
        [make setTitle:@"open door" forState:UIControlStateNormal];
        [make addTarget:self action:@selector(clickOpenDoorButton) forControlEvents:UIControlEventTouchUpInside];
        _openDoorButton = make;
    }
    return _openDoorButton;
}

- (UIButton *)rejectButton {
    if (!_rejectButton) {
        UIButton *make = [UIButton buttonWithType:UIButtonTypeCustom];
        make.backgroundColor = UIColor.blueColor;
        make.titleLabel.textColor = UIColor.whiteColor;
        make.titleLabel.font = [UIFont systemFontOfSize:16];
        [make setTitle:@"reject" forState:UIControlStateNormal];
        [make addTarget:self action:@selector(clickRejectButton) forControlEvents:UIControlEventTouchUpInside];
        _rejectButton = make;
    }
    return _rejectButton;
}

- (UIButton *)hangUpButton {
    if (!_hangUpButton) {
        UIButton *make = [UIButton buttonWithType:UIButtonTypeCustom];
        make.backgroundColor = UIColor.blueColor;
        make.titleLabel.textColor = UIColor.whiteColor;
        make.titleLabel.font = [UIFont systemFontOfSize:16];
        [make setTitle:@"hang up" forState:UIControlStateNormal];
        [make addTarget:self action:@selector(clickHangUpButton) forControlEvents:UIControlEventTouchUpInside];
        make.hidden = YES;
        _hangUpButton = make;
    }
    return _hangUpButton;
}

- (UIButton *)acceptButton {
    if (!_acceptButton) {
        UIButton *make = [UIButton buttonWithType:UIButtonTypeCustom];
        make.backgroundColor = UIColor.blueColor;
        make.titleLabel.textColor = UIColor.whiteColor;
        make.titleLabel.font = [UIFont systemFontOfSize:16];
        [make setTitle:@"accept" forState:UIControlStateNormal];
        [make addTarget:self action:@selector(clickAcceptButton) forControlEvents:UIControlEventTouchUpInside];
        make.hidden = YES;
        _acceptButton = make;
    }
    return _acceptButton;
}

- (TuyaCommunityAccessControlService *)service {
    if (!_service) {
        _service = [[TuyaCommunityAccessControlService alloc] init];
    }
    return _service;
}
@end
