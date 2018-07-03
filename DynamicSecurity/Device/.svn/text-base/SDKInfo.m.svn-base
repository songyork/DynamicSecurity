//
//  SDKInfo.m
//  AYSDK
//
//  Created by SDK on 2017/7/24.
//  Copyright © 2017年 SDK. All rights reserved.
//

#import "SDKInfo.h"
#import <UIKit/UIKit.h>
#import <UIKit/UIDevice.h>
#import <AdSupport/ASIdentifierManager.h>

#import "KeyChainWrapper.h"
#import "BNDReachability.h"
//************** 获取手机IP用的两个头文件；导入头文件，添加方法；
#import <arpa/inet.h>
#import <ifaddrs.h>

//************** 获取手机具体设备型号头文件；导入头文件，添加方法；
#import <sys/utsname.h>

//************** 获取手机当前网络状态；导入两个系统库 SystemConfiguration.framework；CoreTelephony.framework，添加方法；
//#import "Reachability.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>


@implementation SDKInfo

SYSingletonM(SDKInfo)

-(void)setSDKInfoWithAppId:(NSString *)appId appKey:(NSString *)appKey directionNumber:(int)directionNumber{
    
    
    
    //*** 1、appid、paysign、方向信息
    self.AYAppId = appId;
    self.AYAppKey = appKey;
    if (directionNumber) {
        self.directionNumber = directionNumber;
    }
//    else if([directionNumber isEqualToString:@"Vertical"]){
//        self.directionNumber = 1;
//    }
    
    self.isBindPhone = NO;
    
    //*** 2、设备信息
    self.systemVer = [[UIDevice currentDevice] systemVersion];
    self.deviceName = [[UIDevice currentDevice] localizedModel];

    

    self.uuid = [self getUUID];
    
    //    self->_ipAddress = [self deviceIPAdress]; //*** 获取的内网ip，没有意义
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
        self.idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }else{
        self.idfa = @"system version is lower than 6.0";
    }
    
    if ([[[UIDevice currentDevice] identifierForVendor] UUIDString] && [[[[UIDevice currentDevice] identifierForVendor] UUIDString] length] > 0) {
        self.idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    
    self.app_channel = @"appstore";
    
    self.app_version = [self getAppVersion];
    
    self.appName = [self getAppName];

    self.package_name = [[NSBundle mainBundle] bundleIdentifier];
    
    self.platform = @"ios";
//    self.deviceInternet = [self deviceInternetType];
    self.deviceModel = [self deviceModelName];
    self.deviceScreenBounds = [self getScreenSizeString];
}




/*记录用户是否激活*/
- (void)saveActivateFlag:(BOOL)activated{
    [[NSUserDefaults standardUserDefaults] setBool:activated forKey:@"userActivate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*
 * 获取用户是否激活
 */
- (BOOL)getCurrentActivateFlag{
    BOOL activated = [[NSUserDefaults standardUserDefaults]boolForKey:@"userActivate"];
    return activated;

}

- (void)saveCustomerService:(NSString *)customerService{
    
    [[NSUserDefaults standardUserDefaults] setValue:customerService forKey:@"customerService"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getCustomerService{
    
    NSString *customerService = [[NSUserDefaults standardUserDefaults] valueForKey:@"customerService"];
    
    return customerService;
}


- (NSString*)getAppVersion{
    NSString *appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (appversion && [appversion length] >0) {
        return appversion;
    }else{
        return @"";
    }
}

- (NSString *)getAppName{
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    if (appName && [appName length] >0) {
        return appName;
    }else{
        return @"测试用";
    }
    
}

- (NSString *)getScreenSizeString{
    NSString *size = [NSString stringWithFormat:@"%0.0lf*%0.0lf",[UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width];
    if (size && [size length] >0) {
        return size;
    }else{
        return nil;
    }
    
    
}


/*获取设备信息*/
- (NSDictionary *)getDeviceInfo{
//    NSString *str = [NSString stringWithFormat:@"%@6666", self.uuid];
    NSDictionary *dic =  @{
                           @"sdk_version": self.sdkVer,
                           @"app_version": self.app_version,
                           @"system_name":self.deviceModelName,
                           @"device_id": self.uuid,
                           @"idfa": self.idfa,
                           @"platform": self.platform,
                           @"idfv": self.idfv,
                           @"app_channel" : self.app_channel,
                           @"app_name" : self.appName,
                           @"app_id" : self.AYAppId,
                           @"package_name" : self.package_name,
                           @"screen_size" : self.deviceScreenBounds,
                           @"system_version" : self.systemVer,
                           };
    return dic;

}



- (NSDictionary *)createDiviceInfoForBusiness{
    NSDictionary *info = @{
                           @"sdk_version": [self sdkVer],
                           @"app_version": [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"],
                           @"device_name":[self deviceModelName],
                           @"device_id": [self uuid],
                           @"idfa": [self idfa],
                           @"platform": @"ios",
                           @"idfv": [self idfv],
                           @"app_channel" : @"appstore",
                           @"app_name" : @"测试",
                           @"app_id" : self.AYAppId,
                           @"package_name" : [[NSBundle mainBundle] bundleIdentifier],
                           @"screen_size" : self.deviceScreenBounds,
                           @"system_version" : self.systemVer,
                           };
    return info;
}


- (NSMutableDictionary *)createDiviceInfo
{
    return [[NSMutableDictionary alloc] initWithDictionary:@{@"SCREENSIZE": [self getScreenSizeString],
                                                             @"DEVICEID": [self idfa],
                                                             @"CHANNEL": @"",
                                                             @"TIME": [NSNumber numberWithInt:(int)[[NSDate date] timeIntervalSince1970]],
                                                             @"IMEI": [self uuid],
                                                             @"APPID": @"",
                                                             @"IPADDRESS": [self ipAddress],
                                                             @"SYSTEMVERSION": [self systemVer]}];
    
}




//获取设备唯一标识码
- (NSString *)getUUID
{
    NSString *strUUID = [[NSString alloc] initWithData:[KeyChainWrapper load:@"uuid"] encoding:NSUTF8StringEncoding];
    
    if (!(strUUID.length>0))
    {
        
        
        
        
        NSString *str = [[NSUUID UUID] UUIDString];
        strUUID = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [KeyChainWrapper save:@"uuid" data:[strUUID dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    
    
    return strUUID;
}

//设备链接的网络IP地址
-(NSString *)deviceIPAdress
{
    NSString *address = @"1111111";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0)
    { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL)
        {
            if (temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
    //        NSLog(@"手机的IP是：%@", address);
    return address;
}


//设备的具体型号
-(NSString*)deviceModelName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone_1G";
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone_3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone_3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone_4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"Verizon_iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone_4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone_5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone_5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone_5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone_5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone_5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone_5S";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone_6_Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone_6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone_6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone_6s_Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone_SE";
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone_7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone_7_Plus";
    
    //iPod 系列
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod_Touch_1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod_Touch_2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod_Touch_3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod_Touch_4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod_Touch_5G";
    
    //iPad 系列
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad_2_(WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad_2_(GSM)";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad_2_(CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad_2_(32nm)";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad_mini_(WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad_mini_(GSM)";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad_mini_(CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad_3(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad_3(CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad_3(4G)";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad_4_(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad_4_(4G)";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad_4_(CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad_Air";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad_Air";
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad_Air";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad_Air_2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad_Air_2";
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceModel isEqualToString:@"iPad4,4"]
        ||[deviceModel isEqualToString:@"iPad4,5"]
        ||[deviceModel isEqualToString:@"iPad4,6"])      return @"iPad_mini_2";
    
    if ([deviceModel isEqualToString:@"iPad4,7"]
        ||[deviceModel isEqualToString:@"iPad4,8"]
        ||[deviceModel isEqualToString:@"iPad4,9"])      return @"iPad_mini_3";
    
    return deviceModel;
}

//设备的连接的网络
-(NSString *)deviceInternetType
{
    NSString *netconnType = nil;
    BNDReachability *reach = [BNDReachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case ReachableViaWiFi:
            //            NSLog(@"正在使用wifi网络");
            netconnType = @"wifi";
            break;
        case ReachableViaWWAN:
        {
            //            NSLog(@"正在使用蜂窝网络");
            // 获取手机网络类型
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            
            NSString *currentStatus = info.currentRadioAccessTechnology;
            
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
                
                netconnType = @"GPRS";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
                
                netconnType = @"2.75G EDGE";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
                
                netconnType = @"3.5G HSDPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
                
                netconnType = @"3.5G HSUPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
                
                netconnType = @"2G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
                
                netconnType = @"HRPD";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
                
                netconnType = @"4G";
            }
            //            NSLog(@"当前连接网络：%@",netconnType);
        }
            break;
        case NotReachable:
            NSLog(@"没有网络，你在火星上吗？");
            netconnType = @"当前没有网络可连接";
            break;
            
        default:
            break;
    }
    
    return netconnType;
    
    
    //    return nil;
}




@end
