//
//  UserTableViewCell.m
//  DynamicSecurity
//
//  Created by SDK on 2017/11/6.
//  Copyright © 2017年 songyan. All rights reserved.
//

#import "UserTableViewCell.h"
@interface UserTableViewCell()



@property (strong, nonatomic) UILabel *titleLab;

@property (strong, nonatomic) UIImageView *titleImage;

@end
@implementation UserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleImage = [[UIImageView alloc] init];
        self.titleImage.layer.cornerRadius = self.titleImage.height / 2;
        self.titleImage.layer.masksToBounds = YES;
        [self addSubview:self.titleImage];
        
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.textAlignment = 0;
        self.titleLab.numberOfLines = 0;
        [self addSubview:self.titleLab];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = SYLineColor;
        [self addSubview:self.lineView];
        
        Weak_Self;
        [self.titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(10);
            make.centerY.equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleImage.mas_right).offset(5);
            make.centerY.equalTo(weakSelf);
            
        }];

        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(10);
            make.right.equalTo(weakSelf).offset(-10);
            make.bottom.equalTo(weakSelf);
            make.height.mas_equalTo(0.5f);
        }];
    }
    return self;
}


- (void)setModel:(UserCenterModel *)model{
    _model = model;
    
    self.titleLab.text = _model.titleString;
    self.titleImage.image = SYImage(_model.iamgeName);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
