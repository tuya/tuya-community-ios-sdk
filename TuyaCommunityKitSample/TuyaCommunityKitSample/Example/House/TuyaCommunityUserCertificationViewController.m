//
//  TuyaCommunityUserCertificationViewController.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityUserCertificationViewController.h"

@interface TuyaCommunityUserCertificationViewController ()

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, strong) TuyaCommunityHouseMemberService *memberService;

@end

@implementation TuyaCommunityUserCertificationViewController

#pragma mark - Lifecycle Method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Fill Name";
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.nameTextField = [UITextField new];
    self.nameTextField.placeholder = @"Input here";
    self.nameTextField.borderStyle = UITextBorderStyleLine;
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.nameTextField.leftView = ({
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
        lbl.text = @" Input your name：";
        lbl;
    });
    [self.view addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
        make.top.offset(100);
        make.height.mas_equalTo(40);
    }];
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn.backgroundColor = UIColor.blueColor;
    [self.confirmBtn addTarget:self
                  action:@selector(didConfirmButtonPressed)
        forControlEvents:UIControlEventTouchUpInside];
    [self.confirmBtn setTitle:@"Submit" forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.view addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.nameTextField.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
    }];
}

- (void)didConfirmButtonPressed {
    NSString *name = [self.nameTextField.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if (!name.length) return;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(self) weakSelf = self;
    [self.memberService verifyUserInfoWithRealName:name
                                               sex:TuyaCommunityGenderTypeMale
                                            idCard:nil
                                           success:^{
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        NSLog(@"%@", error);
    }];
}

#pragma mark - Getter

- (TuyaCommunityHouseMemberService *)memberService {
    if (!_memberService) {
        _memberService = [TuyaCommunityHouseMemberService new];
    }
    
    return _memberService;
}

@end
