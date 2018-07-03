//
//  UserInfo.h
//  DynamicSecurity
//
//  Created by SDK on 2017/11/6.
//  Copyright © 2017年 songyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

/*uid*/
@property (nonatomic, copy) NSString *userID;
/*用户名*/
@property (nonatomic, copy) NSString *userName;
/*token*/
@property (nonatomic, copy) NSString *token;
/*保存本地序列号*/
@property (nonatomic, copy) NSString *localUUID;
/*上传服务器序列号*/
@property (nonatomic, copy) NSString *postUUID;
/*用户绑定的电话号码*/
@property (nonatomic, copy) NSString *phoneNumber;
/*动态口令*/
@property (nonatomic, copy) NSString *secretCode;
/*客服链接*/
@property (nonatomic ,copy) NSString *customerService;

@property (nonatomic, assign) BOOL isLoginToApp;
/*快速登录*/
@property (nonatomic ,copy) NSString *fastLoginUserName;

/*快速登录*/
@property (nonatomic ,copy) NSString *fastLoginPassword;

/*是否绑定过设备(0 : 没有, 1 : 与当前设备绑定, -1 : 与其它设备绑定)*/
@property (nonatomic, assign) int bind;


/*设置了登录密码*/
@property (nonatomic, assign) BOOL isSetPassword;

SYSingletonH(UserInfo)


- (void)getUserInfo;

/*获取UUID*/
- (NSString *)getUUID;
/*获取设备信息*/
//- (NSDictionary *)getDeviceInfo;

/*为shenhe服务*/
@property (nonatomic, assign) BOOL goVC;

/*是否申shenhe模式请完数据*/
@property (nonatomic, assign) BOOL isLoadInfo;

@end
