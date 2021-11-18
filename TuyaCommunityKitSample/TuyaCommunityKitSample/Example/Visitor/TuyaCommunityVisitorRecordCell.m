//
//  TuyaCommunityVisitorRecordCell.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityVisitorRecordCell.h"
#import <Masonry/Masonry.h>

@interface TuyaCommunityVisitorRecordCell()

@property (nonatomic, strong) UILabel  *visitorNameLabel;
@property (nonatomic, strong) UILabel  *visitorReasonLabel;
@property (nonatomic, strong) UILabel  *visitorStatusStrLabel;
@property (nonatomic, strong) UILabel  *visitorStartTimeStrLabel;
@property (nonatomic, strong) UILabel  *visitorEndTimeStrLabel;

@end

@implementation TuyaCommunityVisitorRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - Private Method

- (void)setupUI {
    
    self.visitorStatusStrLabel = [UILabel new];
    self.visitorStatusStrLabel.textColor = UIColor.redColor;
    self.visitorStatusStrLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.visitorStatusStrLabel];
    [self.visitorStatusStrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(5);
        make.trailing.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(20);
    }];
    
    self.visitorNameLabel = [UILabel new];
    self.visitorNameLabel.textColor = UIColor.blackColor;
    self.visitorNameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.visitorNameLabel];
    [self.visitorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.visitorStatusStrLabel.mas_bottom).offset(5);
        make.trailing.equalTo(self.contentView).offset(-20);
    }];
    
    self.visitorReasonLabel = [UILabel new];
    self.visitorReasonLabel.textColor = UIColor.blackColor;
    self.visitorReasonLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.visitorReasonLabel];
    [self.visitorReasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(20);
        make.trailing.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.visitorNameLabel.mas_bottom).offset(5);
    }];
        
    self.visitorStartTimeStrLabel = [UILabel new];
    self.visitorStartTimeStrLabel.textColor = UIColor.blackColor;
    self.visitorStartTimeStrLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.visitorStartTimeStrLabel];
    [self.visitorStartTimeStrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.visitorReasonLabel.mas_bottom).offset(5);
    }];
    
    self.visitorEndTimeStrLabel = [UILabel new];
    self.visitorEndTimeStrLabel.textColor = UIColor.blackColor;
    self.visitorEndTimeStrLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.visitorEndTimeStrLabel];
    [self.visitorEndTimeStrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.visitorStartTimeStrLabel.mas_bottom).offset(5);
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

- (NSString *)dateWithFormatStr:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

#pragma mark - Setter

-(void)setModel:(TuyaCommunityVisitorModel *)model {
    _model = model;
    self.visitorNameLabel.text = [NSString stringWithFormat:@"visitorName：%@",model.visitorName];
    self.visitorStatusStrLabel.text = [NSString stringWithFormat:@"visitorStatusStr：%@",model.visitorStatusStr];
    self.visitorReasonLabel.text = [NSString stringWithFormat:@"visitorReason：%@",model.visitorReason];
    self.visitorStartTimeStrLabel.text = [NSString stringWithFormat:@"startTime：%@",[self dateWithFormatStr:[NSDate dateWithTimeIntervalSince1970:model.startTime/1000.f]]];
    self.visitorEndTimeStrLabel.text = [NSString stringWithFormat:@"endTime：%@",[self dateWithFormatStr:[NSDate dateWithTimeIntervalSince1970:model.endTime/1000.f]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
