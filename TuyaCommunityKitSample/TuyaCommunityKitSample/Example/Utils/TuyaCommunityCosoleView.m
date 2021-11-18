//
//  TuyaCommunityCosoleView.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "TuyaCommunityCosoleView.h"
#import <Masonry/Masonry.h>

@interface TuyaCommunityCosoleView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextView *textView;

@end

@implementation TuyaCommunityCosoleView

#pragma mark - Init Method

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

#pragma mark - Private Method

- (void)setupUI {
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.text = @"print json:";
    self.titleLabel.textColor = UIColor.lightGrayColor;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.centerX.equalTo(self);
        make.height.mas_equalTo(20);
    }];
    
    self.textView = [UITextView new];
    self.textView.backgroundColor = UIColor.whiteColor;
    self.textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.textView.textColor = UIColor.blackColor;
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.leading.centerX.bottom.equalTo(self);
    }];
}

#pragma mark - Public Method

- (void)updateContentWithModel:(NSObject *)model {
    self.textView.text = [[model yy_modelToJSONString] formatJSON];
}

- (void)updateContentWithModels:(NSArray *)models {
    NSMutableString *string = [NSMutableString string];
    for (NSObject *model in models) {
        [string appendFormat:@"%@,\n", [[model yy_modelToJSONString] formatJSON]];
    }
    
    self.textView.text = string.copy;
}

- (void)cleanContent {
    self.textView.text = nil;
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
}

@end
