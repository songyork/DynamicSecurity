//
//  NetworkTool.h
//  AYSDK
//
//  Created by SDK on 2017/7/25.
//  Copyright © 2017年 SDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYSingleton.h"


typedef NS_ENUM(NSInteger, RegistType) {
    RegistTypeName             = 0, //用户名
    RegistTypePhone         = 1,    // 手机号
    
};


@interface NetworkTool : NSObject


SYSingletonH(NetworkTool)


#pragma mark --- 1、初始化属性_manager
-(void)getManagerBySingleton;

#pragma mark --- 2、点击切换账号调用方法:1、关闭悬浮窗；2、调用登录接口
//- (void)switchBtnClick;


- (void)getAppInfoForGoToViewControllerCompletion:(void(^)(BOOL isSuccess, id respones))completion failure:(void(^)(id error))failure;

#pragma mark --- 5、删除保存的账号密码
//- (void)deleteUserInfoWithIndex:(NSUInteger)index;


#pragma mark ---------------网络请求------------
#pragma mark -------------获取序列号绑定的用户信息
- (void)getUserDynamicWithSn:(NSString *)sn completion:(void(^)(BOOL isSuccess, id respones))completion failure:(void(^)(id error))failure;
/*
 * 获取客服html接口
 */
- (void)getCustomerServiceCompletion:(void(^)(BOOL isSuccess, id response)) completion Failure:(void(^)(id error))failure;





/**
 * 给市场同事方便删除自己的deviceI的接口
 *
 * @param appId : APPID
 *
 * @param completion : 返回值
 *
 */
- (void)clearDeviceIdWithAppId:(NSString *)appId Completion:(void(^)(BOOL isSuccess, id resp)) completion Failure:(void(^)(id error))failure;



/*
 * 添加账号
 */
- (void)addUserToAppWithUserName:(NSString *)userName password:(NSString *)password completion:(void(^)(BOOL isSuccess, id respones))completion failure:(void(^)(id error))failure;



/*
 * 登录接口
 */
- (void)loginWithUserName:(NSString *)userName Password:(NSString *)password sn:(NSString *)sn Completion:(void(^)(BOOL isSuccess, id respones))completion Failure:(void(^)(id error))failure;




/**绑定手机和序列号
 * @param tokenStr : 登录后的token值
 
 * @param code     : 手机验证码
 
 * @param phoneNum : 手机号码
 */
- (void)bindMobileWithToken:(NSString *)tokenStr Uid:(NSString *)uid Code:(NSString *)code PhoneNumber:(NSString *)phoneNum Completion:(void(^)(BOOL isSuccess, id respones))completion Failure:(void(^)(id error))failure;





/**
 * 收取手机验证码短信
 */
- (void)bindPhoneSmsWithPhoneNumber:(NSString *)phoneNum Completion:(void(^)(BOOL isSuccess, id respones))completion Failure:(void(^)(id error))failure;

/**直接绑定序列号
 * param phoneNum : 电话号码
 * param code : 验证码
 */
- (void)checkSmsWithPhone:(NSString *)phoneNum Code:(NSString *)code Completion:(void(^)(BOOL isSuccess, id respones))completion Failure:(void(^)(id error))failure;

/**获取动态口令
 * param sn : 序列号
 * param uid : 用户uid
 */
- (void)getOTPSecretWithSn:(NSString *)sn uid:(NSString *)uid completion:(void(^)(BOOL isSuccess, id respones))completion failure:(void(^)(id error))failure;












@end
