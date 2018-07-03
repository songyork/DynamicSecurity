//
//  DSLoginViewController.h
//  DynamicSecurity
//
//  Created by SDK on 2017/11/4.
//  Copyright © 2017年 songyan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PushWay) {
    
    LoginToApp          = 0, // 登录模式
    AddToApp            = 1, // 添加账号模式
    
};

@interface DSLoginViewController : UIViewController

@property (nonatomic, copy) NSString *userID;

@property (nonatomic, strong) NSArray *userArray;

@property (nonatomic, assign) BOOL isAppDidFinishLaunching;

/*暂时弃用, 用于销毁登录密码Window*/
@property (nonatomic, copy) void(^WindowNeedDisappearBlock)(BOOL disappear);


/*推出页面的功能方式 0 : 登录, 1 : 增加账号*/
@property (nonatomic, assign) PushWay pushWay;

@end
