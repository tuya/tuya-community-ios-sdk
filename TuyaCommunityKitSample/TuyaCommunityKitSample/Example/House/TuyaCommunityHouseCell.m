//
//  TuyaCommunityHouseCell.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityHouseCell.h"

@interface TuyaCommunityHouseCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation TuyaCommunityHouseCell

#pragma mark - Init Method

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    
    return self;
}

#pragma mark - Private Method

- (void)setupUI {
    self.nameLabel = [UILabel new];
    self.nameLabel.textColor = UIColor.blackColor;
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(5);
        make.trailing.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(20);
    }];

    self.statusLabel = [UILabel new];
    self.statusLabel.textColor = UIColor.greenColor;
    self.statusLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(20);
        make.trailing.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(15);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setTitle:@"Move out -> Delete" forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.deleteButton.backgroundColor = [UIColor.blueColor colorWithAlphaComponent:0.5];
    self.deleteButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    [self.deleteButton addTarget:self
                          action:@selector(didDeleteButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.statusLabel.mas_centerY);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.5];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(20);
        make.centerX.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}

- (void)didDeleteButtonPressed {
    if (self.deleteBlock) self.deleteBlock();
}
#pragma mark - Public Method

+ (CGFloat)cellHeight {
    return 50;
}

#pragma mark - Setter

- (void)setShowDelete:(BOOL)showDelete {
    _showDelete = showDelete;
    
    self.deleteButton.hidden = !showDelete;
}

- (void)setModel:(TuyaCommunityHouseModel *)model {
    _model = model;
    
    self.nameLabel.text = model.houseAddress;
    self.statusLabel.textColor = UIColor.greenColor;
    NSString *status = nil;
    NSString *buttonText = nil;
    switch (model.auditStatus) {
        case TuyaCommunityHouseAuditStatusPending:
            status = @"Pending";
            buttonText = @"Delete";
            break;
        case TuyaCommunityHouseAuditStatusPass:
            status = @"Pass";
            buttonText = @"Move out";
            break;
        case TuyaCommunityHouseAuditStatusFailure:
            status = @"Failure";
            buttonText = @"Delete";
            self.statusLabel.textColor = UIColor.redColor;
            break;
        case TuyaCommunityHouseAuditStatusMovedOut:
            status = @"Moved out";
            buttonText = @"Delete";
            self.statusLabel.textColor = UIColor.redColor;
            break;
        default:
            break;
    }
    
    self.statusLabel.text = status;
    [self.deleteButton setTitle:buttonText forState:UIControlStateNormal];
}

- (void)setMemberModel:(TuyaCommunityMemberModel *)memberModel {
    _memberModel = memberModel;
    
    self.nameLabel.text = memberModel.account;
    
    NSString *status = nil;
    switch (memberModel.audit) {
        case TuyaCommunityMemberAuditStatusPending:
            status = @"Pending";
            break;
        case TuyaCommunityMemberAuditStatusPass:
            status = @"Pass";
            break;
        case TuyaCommunityMemberAuditStatusFailure:
            status = @"Failure";
            break;
        default:
            break;
    }
    
    self.statusLabel.text = [NSString stringWithFormat:@"%@------%@", memberModel.userTypeCode, status];
}

@end
