//
//  TuyaCommunityRegisterViewController.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityRegisterViewController.h"
#import <Masonry/Masonry.h>
#import <TuyaSmartBaseKit/TuyaSmartBaseKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface TuyaCommunityRegisterViewController ()

@property (nonatomic, strong) UIButton *registerButton;

@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *vcodeTextField;


@end

@implementation TuyaCommunityRegisterViewController

#pragma mark - Lifecycle Method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - Private Method

- (void)setupUI {
    self.navigationItem.title = @"Register";
    self.view.backgroundColor = UIColor.whiteColor;

    self.accountTextField = [UITextField new];
    self.accountTextField.placeholder = @"Input here";
    self.accountTextField.borderStyle = UITextBorderStyleLine;
    self.accountTextField.leftViewMode = UITextFieldViewModeAlways;
    self.accountTextField.leftView = ({
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
        lbl.text = @" Account ";
        lbl;
    });
    [self.view addSubview:self.accountTextField];
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(100);
        make.height.mas_equalTo(40);
    }];
    
    UIView *vcodeContainer = [UIView new];
    vcodeContainer.layer.borderColor = UIColor.grayColor.CGColor;
    vcodeContainer.layer.borderWidth = 1;
    
    UIButton *sendVCode = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendVCode setAttributedTitle:({
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@" Send " attributes:@{
            NSForegroundColorAttributeName: UIColor.blueColor,
            NSFontAttributeName: [UIFont systemFontOfSize:14],
            NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
        }];
        attr;
    }) forState:UIControlStateNormal];
    [sendVCode addTarget:self action:@selector(sendVcode) forControlEvents:UIControlEventTouchUpInside];
    
    self.vcodeTextField = [UITextField new];
    self.vcodeTextField.placeholder = @"Input here";
    self.vcodeTextField.leftViewMode = UITextFieldViewModeAlways;
    self.vcodeTextField.leftView = ({
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
        lbl.text = @" Auth code ";
        lbl;
    });

    [self.view addSubview:vcodeContainer];
    [vcodeContainer addSubview:sendVCode];
    [vcodeContainer addSubview:_vcodeTextField];
    
    [vcodeContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountTextField.mas_bottom).offset(20);
        make.leading.offset(20);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    [_vcodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(0);
        make.top.bottom.offset(0);
    }];
    [sendVCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.vcodeTextField.mas_trailing).offset(15);
        make.trailing.offset(-10);
        make.top.bottom.offset(0);
    }];
    
    self.passwordTextField = [UITextField new];
    self.passwordTextField.placeholder = @"Input here";
    self.passwordTextField.borderStyle = UITextBorderStyleLine;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.leftView = ({
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
        lbl.text = @" Password ";
        lbl;
    });
    [self.view addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
        make.top.equalTo(vcodeContainer.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.registerButton.backgroundColor = UIColor.grayColor;
    [self.registerButton addTarget:self
                  action:@selector(didRegisterButtonPressed)
        forControlEvents:UIControlEventTouchUpInside];
    [self.registerButton setTitle:@"Register" forState:UIControlStateNormal];
    [self.registerButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.view addSubview:self.registerButton];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
}

- (void)sendVcode {
    NSString *phone =
    [self.accountTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (!phone.length)
        return;
    
    [[TuyaSmartUser sharedInstance] sendVerifyCodeWithUserName:phone
                                                        region:@""
                                                   countryCode:@"86"
                                                          type:1
                                                       success:^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"Send code succeed";
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:2];
    }
                                                       failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)didRegisterButtonPressed {
    NSString *phone =
    [self.accountTextField.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    NSString *vcode =
    [self.vcodeTextField.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    NSString *pwd =
    [self.passwordTextField.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    
    if (!phone.length || !vcode.length || !pwd.length)
        return;
    
    __weak typeof(self) wself = self;
    [[TuyaSmartUser sharedInstance] registerByPhone:@"86" phoneNumber:phone password:pwd code:vcode success:^{
        __strong typeof(wself) sself = wself;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"Register succeed";
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:2];
        hud.completionBlock = ^{
            [sself.navigationController popViewControllerAnimated:YES];
        };

    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
