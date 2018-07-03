//
//  SDKInfo.h
//  AYSDK
//
//  Created by SDK on 2017/7/24.
//  Copyright © 2017年 SDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYSingleton.h"


@interface SDKInfo : NSObject
@property (nonatomic) BOOL isInited; //判断SDK是否初始化
@property(nonatomic,assign)int directionNumber; //游戏方向，0位横屏游戏、1位竖屏游戏
@property(nonatomic,assign)BOOL isLoginSuccess; //是否登录成功
@property(nonatomic,copy)NSString *AYAppKey;   //游戏appKey
@property(nonatomic,copy)NSString *bindPhoneNumber; //已绑定的手机号码
@property(nonatomic,assign)BOOL isBindingIdCard;//是否绑定身份证

@property (nonatomic, copy) NSString *package_name;//包名
@property (nonatomic, copy) NSString *app_version;//
@property (strong) NSString *sdkVer;        //SDK版本
@property (nonatomic, copy) NSString *app_channel;
@property(nonatomic,copy)NSString *AYAppId;     //游戏appid
@property (strong) NSString *systemVer;     //手机系统版本
@property (strong) NSString *deviceName;    //
@property (strong) NSString *uuid;          // 手机本地保存，app对应的唯一表示；
@property (strong) NSString *ipAddress;     //
@property (strong) NSString *idfa;          //IDFA
@property (nonatomic, strong) NSString *idfv; //IDFV
@property (nonatomic, copy) NSString *appName;//APP名字
@property(nonatomic,strong)NSString *deviceInternet;
@property(nonatomic,strong)NSString *deviceModel; //苹果手机型号
@property(nonatomic,strong)NSString *deviceScreenBounds;
@property (nonatomic, copy) NSString *platform;// 平台 固定是iOS


@property (nonatomic ,copy) NSString *requestUrl;//h5

@property (nonatomic ,copy) NSString *zhiUrl;//zhifu

@property (nonatomic ,copy) NSString *token;//token值

@property (nonatomic, copy) NSString *tokenCode;//给游戏方验证的token值

@property (nonatomic, copy) NSString *order;//给游戏方验证的token值

@property (nonatomic, assign) BOOL isSignOut;//退出游戏

@property (nonatomic, copy) NSString *loginUser;//当前登录的账号

@property (nonatomic ,copy) NSString *fastUserName;//需要保存

@property (nonatomic, assign) BOOL needAuto;//是否需要自动登录

@property (nonatomic, assign) BOOL isAppStatus;//app状态,是否是正式服

@property (nonatomic, assign) BOOL isNetWorking;

@property (nonatomic, assign) BOOL isBindPhone;//是否绑定手机

@property (nonatomic, copy) NSString *bbsID;//论坛id


SYSingletonH(SDKInfo)


-(void)setSDKInfoWithAppId:(NSString *)appId appKey:(NSString *)appKey directionNumber:(int)directionNumber;


/*记录激活*/
- (void)saveActivateFlag:(BOOL)activated;

/*获取激活*/
- (BOOL)getCurrentActivateFlag;

/*保存客服的链接*/
- (void)saveCustomerService:(NSString *)customerService;
/*获取客服链接*/
- (NSString *)getCustomerService;
/*获取UUID*/
- (NSString *)getUUID;
/*获取设备信息*/
- (NSDictionary *)getDeviceInfo;


/*创建设备信息*/   //没用
- (NSMutableDictionary *)createDiviceInfo;
/*没用*/
- (NSDictionary *)createDiviceInfoForBusiness;

@end
