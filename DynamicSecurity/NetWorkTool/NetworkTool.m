//
//  NetworkTool.m
//  AYSDK
//
//  Created by SDK on 2017/7/25.
//  Copyright © 2017年 SDK. All rights reserved.
//

#import "NetworkTool.h"




//#import "KeFuViewController.h"
@interface NetworkTool  ()

@property(nonatomic,strong)AFHTTPSessionManager *manager;


@property (nonatomic ,strong) UIWindow *kefuWindow;


@property(nonatomic,strong)UIWindow *htmlWindow; //H5Window




/**上传图片
 NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@""]);
 [self.manager POST:@"" parameters:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
 [formData appendPartWithFileData:imageData name:@"约定的URL" fileName:@"名字+格式.png/jpeg" mimeType:@"xxx/png"];
 } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
 
 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
 
 }];
 

 
 */

@end

@implementation NetworkTool

SYSingletonM(NetworkTool)


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


//*** 0、单例加载manager属性
-(void)getManagerBySingleton{
    _manager = [self singletonLoadManager];
    
}

-(AFHTTPSessionManager *)singletonLoadManager{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        //        [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
//        [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    });
    return manager;
}




- (void)getAppInfoForGoToViewControllerCompletion:(void(^)(BOOL isSuccess, id respones))completion failure:(void(^)(id error))failure{
    
    NSDictionary *dic = @{
                          @"platform"   :   @"ios",
                          @"version"    :   APP_Version,
                          };
    NSString *sign = [PublicTool makesignStringWithParams:dic];
    SYLog(@"---sign:%@", sign);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    NSString *urlString = [NSString stringWithFormat:@"%@ct=Sys&ac=getInfo", SY_URL_Head];
    SYLog(@"审核模式------params:%@-----", params);
    [self getResponseWithUrl:urlString Parameters:params Medthod:@"审核模式" Completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
            }
            
        }
    }Failure:^(id error) {
        if (failure) {
            failure(error);
        }
    }];

}


//客服....
- (void)getCustomerServiceCompletion:(void(^)(BOOL isSuccess, id response)) completion Failure:(void(^)(id error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@ct=Sys&ac=getOnlineKefuUrl", SY_URL_Head];
    NSDictionary *dic = @{
                      @"time"        : [PublicTool getTimeStamps],
                      };
    NSString *sign = [PublicTool makesignStringWithParams:dic];
    SYLog(@"---sign:%@", sign);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    [_manager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSDictionary *originalDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        SYLog(@"success--------------originalDic-------- %@",originalDic[@"msg"]);
        if ([originalDic[@"state"] intValue] == 1) {
            NSDictionary *dic = originalDic[@"data"];
            SYLog(@"客服---------------------dic-------- %@",dic);
            //            NSString *htmlUrl = dic[@"÷"];
            if (completion) {
                completion(YES, originalDic);
            }
        }else{
            if (completion) {
                completion(NO, originalDic);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
        
    }];

}


//登录
- (void)loginWithUserName:(NSString *)userName Password:(NSString *)password sn:(NSString *)sn Completion:(void(^)(BOOL isSuccess, id respones))completion Failure:(void(^)(id error))failure{
    
    NSDictionary *dic = @{
                          @"username"       :   userName,
                          @"password"       :   password,
                          @"sn"             :   sn,
                          @"platform"   :   @"ios",
                          @"version"    :   APP_Version,
                          @"time"       :   [PublicTool getTimeStamps],
                          };
    NSString *sign = [PublicTool makesignStringWithParams:dic];
    SYLog(@"---sign:%@", sign);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    NSString *urlString = [NSString stringWithFormat:@"%@ct=User&ac=login", SY_URL_Head];
    SYLog(@"登录------params:%@-----", params);
    [_manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *originalDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        SYLog(@"登录-------success--------------originalDic-------- %@------------message:%@",originalDic, originalDic[@"msg"]);
        if ([originalDic[@"state"] intValue] == 1) {
            NSDictionary *dic = originalDic[@"data"];
            SYLog(@"dic-------- %@",dic);
            

            if (completion) {
                completion(YES, originalDic);
            }
        }else{
            if (completion) {
                completion(NO, originalDic);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
    }];

}



- (void)getOTPSecretWithSn:(NSString *)sn uid:(NSString *)uid completion:(void(^)(BOOL isSuccess, id respones))completion failure:(void(^)(id error))failure{
    NSDictionary *dic = @{
                          @"sn"         :   sn,
                          @"uid"        :   uid,
                          @"token"      :   [UserInfo sharedUserInfo].token,
                          @"platform"   :   @"ios",
                          @"version"    :   APP_Version,
                          @"time"       :   [PublicTool getTimeStamps],
                          };
    NSString *sign = [PublicTool makesignStringWithParams:dic];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    NSString *urlString = [NSString stringWithFormat:@"%@ct=UserDynamicPassword&ac=bind", SY_URL_Head];
    SYLog(@"绑定手机号码------params:%@-----", params);

    [self getResponseWithUrl:urlString Parameters:params Medthod:@"获取动态密码" Completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
            }
        }
    } Failure:^(id error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getUserDynamicWithSn:(NSString *)sn completion:(void(^)(BOOL isSuccess, id respones))completion failure:(void(^)(id error))failure{
    NSDictionary *dic = @{
                          @"sn"         :   sn,
                          @"token"      :   [UserInfo sharedUserInfo].token,
                          @"platform"   :   @"ios",
                          @"version"    :   [NSString stringWithFormat:@"%@", APP_Version],
                          @"time"       :   [PublicTool getTimeStamps],
                          };
    NSString *sign = [PublicTool makesignStringWithParams:dic];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    NSString *urlString = [NSString stringWithFormat:@"%@ct=UserDynamicPassword&ac=getList", SY_URL_Head];
    SYLog(@"绑定手机号码------params:%@-----", params);
    [self getResponseWithUrl:urlString Parameters:params Medthod:@"获取某一SN下绑定的用户" Completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
            }
        }
    } Failure:^(id error) {
        if (failure) {
            failure(error);
        }
    }];
}

//绑定手机号码
- (void)bindMobileWithToken:(NSString *)tokenStr Uid:(NSString *)uid Code:(NSString *)code PhoneNumber:(NSString *)phoneNum Completion:(void(^)(BOOL isSuccess, id respones))completion Failure:(void(^)(id error))failure{
    
    
    NSDictionary *dic = @{
                          @"phone"       : phoneNum,//phoneNum
                          @"code"        : code,
                          @"uid"         : uid,
                          @"token"      :   [UserInfo sharedUserInfo].token,
                          @"platform"   :   @"ios",
                          @"version"    :   APP_Version,
                          @"time"       :   [PublicTool getTimeStamps],
                          };

    
    NSString *sign = [PublicTool makesignStringWithParams:dic];
    SYLog(@"---sign:%@", sign);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    NSString *urlString = [NSString stringWithFormat:@"%@ct=User&ac=bindPhone", SY_URL_Head];
    SYLog(@"绑定手机号码------params:%@-----", params);
    [self getResponseWithUrl:urlString Parameters:params Medthod:@"绑定手机号码" Completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
            }
            
        }
    }Failure:^(id error) {
        
    }];
    

}


- (void)addUserToAppWithUserName:(NSString *)userName password:(NSString *)password completion:(void(^)(BOOL isSuccess, id respones))completion failure:(void(^)(id error))failure{
    
    NSDictionary *dic = @{
                          @"username"       : userName,
                          @"password"        : password,
                          @"token"      :   [UserInfo sharedUserInfo].token,
                          @"platform"   :   @"ios",
                          @"version"    :   APP_Version,
                          @"time"       :   [PublicTool getTimeStamps],
                          };
    NSString *sign = [PublicTool makesignStringWithParams:dic];
    SYLog(@"---sign:%@", sign);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    NSString *urlString = [NSString stringWithFormat:@"%@ct=User&ac=verify", SY_URL_Head];
    SYLog(@"添加账号------params:%@-----", params);
    [self getResponseWithUrl:urlString Parameters:params Medthod:@"添加账号" Completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
            }
            
        }
    }Failure:^(id error) {
        if (failure) {
            failure(error);
        }
    }];
    
}





//绑定手机验证码
- (void)bindPhoneSmsWithPhoneNumber:(NSString *)phoneNum Completion:(void(^)(BOOL isSuccess, id respones))completion Failure:(void(^)(id error))failure{
    
    NSDictionary *dic = @{
                          @"phone"       : phoneNum,//phoneNum
                          @"type"        : @"bind_token",
                          @"token"      :   [UserInfo sharedUserInfo].token,
                          @"platform"   :   @"ios",
                          @"version"    :   APP_Version,
                          @"time"       :   [PublicTool getTimeStamps],
                          };
    NSString *sign = [PublicTool makesignStringWithParams:dic];
    SYLog(@"---sign:%@", sign);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    
    SYLog(@"绑定手机验证码------params:%@-----", params);
    [self getResponseWithUrl:SY_URL_Message Parameters:params Medthod:@"绑定手机验证码" Completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
            }
            
        }
    }Failure:^(id error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


//检测短信验证码
- (void)checkSmsWithPhone:(NSString *)phoneNum Code:(NSString *)code Completion:(void(^)(BOOL isSuccess, id respones))completion Failure:(void(^)(id error))failure{
   
    NSDictionary *dic = @{
                          @"phone"       : phoneNum,//phoneNum
                          @"code"        : code,
                          @"token"      :   [UserInfo sharedUserInfo].token,
                          @"platform"   :   @"ios",
                          @"version"    :   APP_Version,
                          @"time"       :   [PublicTool getTimeStamps],
                          };
    
    NSString *sign = [PublicTool makesignStringWithParams:dic];
    SYLog(@"---sign:%@", sign);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    NSString *urlString = [NSString stringWithFormat:@"%@ct=Sys&ac=checkSms", SY_URL_Head];
    SYLog(@"手机找回密码------params:%@-----", params);
    [self getResponseWithUrl:urlString Parameters:params Medthod:@"验证短信和手机号码_手机找回密码" Completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
                
            }
            
        }
    }Failure:^(id error) {
        
    }];
}





- (void)clearDeviceIdWithAppId:(NSString *)appId Completion:(void(^)(BOOL isSuccess, id resp)) completion Failure:(void(^)(id error))failure{
    
    NSDictionary *param = @{
                             @"app_id"      : appId,
                             };
    
    NSString *signStr = [PublicTool makesignStringWithParams:param];
    SYLog(@"---sign:%@", signStr);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:param];
    [params setObject:signStr forKey:@"sign"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@ct=sys&ac=clearDevice", SY_URL_Head];
    SYLog(@"------params:%@-----", params);
    [self getResponseWithUrl:urlString Parameters:params Medthod:@"清理deviceID" Completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
                
            }
            
        }
    }Failure:^(id error) {
        
    }];

    
    
}







/*
 * 临时多一层封装
 */
- (void)getDataForResponseWithUrl:(NSString *)urlString Parameters:(id)params Medthod:(NSString *)medthod Completion:(void(^)(BOOL isSuccess, id responesObj))completion Failure:(void(^)(id responesObj))failure{
    
    [_manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *originalDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        SYLog(@"%@----success--------------originalDic-------- %@------------message:%@", medthod,originalDic, originalDic[@"msg"]);
        if ([originalDic[@"state"] intValue] == 1) {
            //            NSDictionary *dic = originalDic[@"data"];
            //            SYLog(@"dic-------- %@",dic);
            if (completion) {
                completion(YES, originalDic);
            }
        }else{
            if (completion) {
                completion(NO, originalDic);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
    }];
    
    

    
}




//公共请求方法..
- (void)getResponseWithUrl:(NSString *)urlString Parameters:(id)params Medthod:(NSString *)medthod Completion:(void(^)(BOOL isSuccess, id responesObj))completion Failure:(void(^)(id error))failure{
//    Weak_Self;
    [self getDataForResponseWithUrl:urlString Parameters:params Medthod:medthod Completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
                
            }
            
        }
    } Failure:^(id responesObj) {
        if (failure) {
            failure(responesObj);
        }
    }];
}



#pragma mark ----------------------------------------------保存账号信息
//*** 登录或者注册成功后保存账号、密码，最多保存5个
-(void)saveWithUsername:(NSString *)username andWithPassword:(NSString *)password{
    if ([KeyChainWrapper load:SYUsernameKey] == nil) {
        NSMutableArray *userNameArray = [NSMutableArray array];
        [userNameArray insertObject:username atIndex:0];
        [KeyChainWrapper save:SYUsernameKey data:userNameArray];
    }else{
        NSMutableArray *userNameArr = [KeyChainWrapper load:SYUsernameKey];
        if ([userNameArr containsObject:username]) {
//            NSMutableDictionary *haveUserDict = [KeyChainWrapper load:AYPasswordKey];
//            [haveUserDict removeObjectForKey:username];
//            [KeyChainWrapper save:AYPasswordKey data:haveUserDict];

            [userNameArr removeObject:username];
            [userNameArr insertObject:username atIndex:0];
            [KeyChainWrapper save:SYUsernameKey data:userNameArr];

        }else{
            if (userNameArr.count == 5) {
                NSMutableDictionary *userDict = [KeyChainWrapper load:SYPasswordKey];
                [userDict removeObjectForKey:userNameArr[4]];
                [KeyChainWrapper save:SYPasswordKey data:userDict];
                
                [userNameArr removeObjectAtIndex:4];
                [userNameArr insertObject:username atIndex:0];
                [KeyChainWrapper save:SYUsernameKey data:userNameArr];
            }else{
                [userNameArr insertObject:username atIndex:0];
                [KeyChainWrapper save:SYUsernameKey data:userNameArr];
            }
        }
    }
    //*** 、字典保存账号、密码，最多5个
    if ([KeyChainWrapper load:SYPasswordKey] == nil) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:password forKey:username];
        [KeyChainWrapper save:SYPasswordKey data:dict];
    }else{
        NSMutableDictionary *userDict = [KeyChainWrapper load:SYPasswordKey];
        if ([userDict objectForKey:username]) {
            if (![password isEqualToString:[userDict objectForKey:username]]) {
                [userDict setObject:password forKey:username];
                [KeyChainWrapper save:SYPasswordKey data:userDict];
            }
            
        }else{
            [userDict setObject:password forKey:username];
            [KeyChainWrapper save:SYPasswordKey data:userDict];
        }
    }
    
    
}


- (void)loginForForumWithUserName:(NSString *)userName Password:(NSString *)password{
    NSDictionary *params = @{
                             
                             };
    NSString *urlString = [NSString stringWithFormat:@"%@ct=index&ac=login", SY_URL_Head];
    SYLog(@"登录------params:%@-----", params);
    [_manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}



@end
