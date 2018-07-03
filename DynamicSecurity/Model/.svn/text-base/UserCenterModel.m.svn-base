//
//  UserCenterModel.m
//  DynamicSecurity
//
//  Created by SDK on 2017/11/6.
//  Copyright © 2017年 songyan. All rights reserved.
//

#import "UserCenterModel.h"

@implementation UserCenterModel




+ (NSMutableArray *)getDateFromModel{
    NSArray *titleArr = @[@"联系客服", @"解除安全令牌", @"查看序列号", @"设置登录密码"];

    NSMutableArray *data = [NSMutableArray new];
    
    for (NSString *key in titleArr) {
        UserCenterModel *model = [[UserCenterModel alloc] init];
        model.titleString = key;
        model.iamgeName = key;
        [data addObject:model];
    }
    SYLog(@"---data: %@", data);
    
    return data;
    
}




@end
