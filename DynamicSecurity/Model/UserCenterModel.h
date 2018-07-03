//
//  UserCenterModel.h
//  DynamicSecurity
//
//  Created by SDK on 2017/11/6.
//  Copyright © 2017年 songyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCenterModel : NSObject


@property (nonatomic, copy) NSString *iamgeName;

@property (nonatomic, copy) NSString *titleString;



+ (NSMutableArray *)getDateFromModel;


@end
