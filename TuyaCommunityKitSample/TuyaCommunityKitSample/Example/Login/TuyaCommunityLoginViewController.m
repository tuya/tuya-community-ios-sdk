//
//  TuyaCommunityLoginViewController.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityLoginViewController.h"
#import <Masonry/Masonry.h>
#import <TuyaSmartBaseKit/TuyaSmartBaseKit.h>
#import "TuyaCommunityManager.h"
#import "TuyaCommunityRegisterViewController.h"

@interface TuyaCommunityLoginViewController ()

@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) UITextField *accountTextField;

@property (nonatomic, strong) UITextField *pwdTextField;

@end

@implementation TuyaCommunityLoginViewController

#pragma mark - Lifecycle Method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - Private Method

- (void)setupUI {
    self.navigationItem.title = @"Login";
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
        make.top.offset(100);
        make.height.mas_equalTo(40);
    }];
    
    self.pwdTextField = [UITextField new];
    self.pwdTextField.placeholder = @"Input here";
    self.pwdTextField.borderStyle = UITextBorderStyleLine;
    self.pwdTextField.leftViewMode = UITextFieldViewModeAlways;
    self.pwdTextField.leftView = ({
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
        lbl.text = @" Password ";
        lbl;
    });
    [self.view addSubview:self.pwdTextField];
    [self.pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.accountTextField.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
    }];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.backgroundColor = UIColor.grayColor;
    [self.loginBtn addTarget:self
                  action:@selector(didLoginButtonPressed)
        forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn setTitle:@"Click to Login" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.view addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.pwdTextField.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [registerButton addTarget:self
                  action:@selector(didRegisterButtonPressed)
        forControlEvents:UIControlEventTouchUpInside];
    [registerButton setAttributedTitle:({
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@"Register" attributes:@{
            NSForegroundColorAttributeName: UIColor.grayColor,
            NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
        }];
        attrStr;
    }) forState:UIControlStateNormal];
    [registerButton setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
    [self.view addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];

}

#pragma mark - Event

- (void)didLoginButtonPressed {
    NSString *phoneNumber = self.accountTextField.text;
    NSString *password = self.pwdTextField.text;
    
    if (!phoneNumber.length || !password.length)
        return;
    
    [[TuyaSmartUser sharedInstance] loginByPhone:@"86"
                                     phoneNumber:phoneNumber
                                        password:password
                                         success:^{
        UIViewController *vc = TuyaCommunityManager.sharedInstance.mainViewController;
        UIApplication.sharedApplication.keyWindow.rootViewController = vc;
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)didRegisterButtonPressed {
    [self.navigationController pushViewController:[TuyaCommunityRegisterViewController new]
                                         animated:YES];
}

@end
