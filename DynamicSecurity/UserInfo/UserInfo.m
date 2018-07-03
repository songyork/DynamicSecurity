//
//  UserInfo.m
//  DynamicSecurity
//
//  Created by SDK on 2017/11/6.
//  Copyright © 2017年 songyan. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo


SYSingletonM(UserInfo)


- (void)getUserInfo{
    NSRange range = {4,19};
    NSString *str = [[self getUUID] substringWithRange:range];
    self.localUUID = str;
    self.postUUID = [self.localUUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
}

//获取设备唯一标识码
- (NSString *)getUUID
{
    NSString *strUUID = [[NSString alloc] initWithData:[KeyChainWrapper load:@"uuid"] encoding:NSUTF8StringEncoding];
    
    if (!(strUUID.length>0))
    {
        
        strUUID = [[NSUUID UUID] UUIDString];
//        strUUID = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [KeyChainWrapper save:@"uuid" data:[strUUID dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    return strUUID;
}



@end
