//
//  TuyaCommunityPublicMonitorDetailViewController.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityPublicMonitorDetailViewController.h"
#import <TuyaSmartCameraKit/TuyaSmartCameraKit.h>

@interface TuyaCommunityPublicMonitorDetailViewController () <TuyaSmartCameraDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) TuyaSmartDevice *device;
@property (nonatomic, strong) id<TuyaSmartCameraType> camera;

@end

@implementation TuyaCommunityPublicMonitorDetailViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self addNotification];
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

    [TuyaCommunityVisualSpeakManager.shareInstance loadConfigWithDeviceId:self.monitorModel.deviceId gatewayId:self.monitorModel.gatewayId success:^{
        
        self.device = [TuyaSmartDevice deviceWithDeviceId:self.monitorModel.deviceId];
        
        self.camera = [TuyaSmartCameraFactory cameraWithP2PType:@(self.device.deviceModel.p2pType) deviceId:self.monitorModel.deviceId delegate:self];
        [self.camera connectWithMode:TuyaSmartCameraConnectAuto];
        
        [self.view addSubview:self.camera.videoView];
        self.camera.videoView.backgroundColor = [UIColor lightGrayColor];
        self.camera.videoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width / 16 * 9);
        self.camera.videoView.center = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"load config failure: %@", error.localizedDescription);
    }];
}

#pragma mark - layout

- (void)initView {
    self.view.backgroundColor = UIColor.blackColor;
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.subTitleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(88 + 20);
        make.centerX.offset(0);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.centerX.offset(0);
    }];
    
    self.titleLabel.text = self.monitorModel.deviceName;
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
    self.subTitleLabel.text = @"connected";
}

- (void)cameraDidStopPreview:(id<TuyaSmartCameraType>)camera {
    NSLog(@"stop preview");
}

// error callback
- (void)camera:(id<TuyaSmartCameraType>)camera didOccurredErrorAtStep:(TYCameraErrorCode)errStepCode specificErrorCode:(NSInteger)errorCode {
    NSLog(@"errorCode: %ld", errorCode);
}

#pragma mark - notification

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onReceiveBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onReceiveEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)onReceiveEnterForeground {
    [self.camera connectWithMode:TuyaSmartCameraConnectAuto];
}

- (void)onReceiveBackground {
    [self.camera disConnect];
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

@end
