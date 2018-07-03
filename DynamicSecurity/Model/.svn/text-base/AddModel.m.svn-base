//
//  AddModel.m
//  DynamicSecurity
//
//  Created by SDK on 2017/11/6.
//  Copyright © 2017年 songyan. All rights reserved.
//

#import "AddModel.h"

@implementation AddModel
// 解析数据
+ (NSMutableArray *)getDate:(NSArray *)data{
    NSMutableArray *dataArr = [NSMutableArray new];
    NSDictionary *dic = [NSDictionary new];
    for (dic in data) {
        AddModel *model = [[AddModel alloc] init];
        model.userSecret = dic[@"secret"];
        model.userID = dic[@"uid"];
        model.userName = dic[@"username"];
        [dataArr addObject:model];
    }
    return dataArr;
}


@end
