//
//  AddUserTableViewCell.m
//  DynamicSecurity
//
//  Created by SDK on 2017/11/6.
//  Copyright © 2017年 songyan. All rights reserved.
//

#import "AddUserTableViewCell.h"
@interface AddUserTableViewCell()

@property (nonatomic ,strong) UILabel *titleLab;

@property (nonatomic, strong) UIButton *changeBtn;

@property (nonatomic ,strong) UIImageView *onlineImage;

@end


@implementation AddUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews{
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.textAlignment = 0;
    self.titleLab.numberOfLines = 0;
    self.titleLab.font =[UIFont systemFontOfSize:18];
    [self addSubview:self.titleLab];
    
    self.changeBtn = [PublicTool createBtnWithButton:self.changeBtn buttonType:UIButtonTypeCustom frame:CGRectZero backgroundColor:[UIColor colorWithRed:0.88 green:0.60 blue:0.24 alpha:1.00] image:nil normalTile:@"账号切换" selectedTitle:nil highlightTile:nil textAlignment:1 selected:nil titleNormalColor:SYWhiteColor titleSelectedColor:nil titleHighlightedColor:nil];
    [self.changeBtn addTarget:self action:@selector(changeClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.changeBtn];
    
    self.onlineImage = [[UIImageView alloc] initWithImage:SYImage(@"x")];
    self.onlineImage.hidden = YES;
    [self addSubview:self.onlineImage];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = SYLineColor;
    [self addSubview:self.lineView];
}

- (void)layoutSubviews{
    Weak_Self;
    
    if (!self.onlineImage.hidden) {
        [self.onlineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(5);
            make.centerY.equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.onlineImage.mas_right).offset(5);
            make.centerY.equalTo(weakSelf);
        }];
    }else{
        self.onlineImage.frame = CGRectZero;
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(10);
            make.centerY.equalTo(weakSelf);
        }];
    }
    
    
    
   
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-20);
        make.centerY.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(10);
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void)setModel:(AddModel *)model{
    _model = model;
    self.titleLab.text = _model.userName;
    if ([_model.userSecret isEqualToString:self.userOnline]) {
        self.onlineImage.hidden = NO;
        [self.changeBtn setTitle:@"当前登录" forState:UIControlStateNormal];
        [self.changeBtn setTitle:@"当前登录" forState:UIControlStateHighlighted];
        [self.changeBtn setTitle:@"当前登录" forState:UIControlStateSelected];
        [self.changeBtn setBackgroundColor:[UIColor colorWithRed:0.2 green:0.54 blue:0.93 alpha:1]];
    }
}


- (void)changeClick{
    SYLog(@"切换账号");
    if ([self.delegate respondsToSelector:@selector(cell:changeUserForData:)]) {
        [self.delegate cell:self changeUserForData:_model];
    }
    if (self.changeBlock) {
        self.changeBlock(_model);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
