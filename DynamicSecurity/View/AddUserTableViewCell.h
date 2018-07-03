//
//  AddUserTableViewCell.h
//  DynamicSecurity
//
//  Created by SDK on 2017/11/6.
//  Copyright © 2017年 songyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DSAddUserTableCellDelegate <NSObject>

- (void)cell:(UITableViewCell *)cell changeUserForData:(AddModel *)data;
@end


@interface AddUserTableViewCell : UITableViewCell

@property (nonatomic, strong) AddModel *model;

@property (nonatomic, strong) UIView *lineView;

/**
 delegate : 用于传secret
 */
@property (nonatomic, weak)id<DSAddUserTableCellDelegate>delegate;

/**
 block  : 用于传secret
 addModel   :   用户数据模型
 */
@property (nonatomic, copy) void(^changeBlock)(AddModel *addModel);

@property (nonatomic, copy) NSString *userOnline;

@end
