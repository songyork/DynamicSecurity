//
//  AppDelegate.m
//  DynamicSecurity
//
//  Created by songyan on 2017/10/30.
//  Copyright © 2017年 songyan. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

#import "DSLoginViewController.h"

#import "OTPAuthBarClock.h"

#import "ZFTouchID.h"

#import "InputPasswrodView.h"

#import "SetPasswordViewController.h"

@interface AppDelegate ()



@property (nonatomic, strong) NSMutableArray *authURLs;//用于强引用Google的算法

@property (nonatomic, strong) UIWindow *rootWindow;//跟window

@property (nonatomic, strong) MBProgressHUD *HUD;

@property (nonatomic, strong) UIViewController *fakeRootVC;//密码Window

@property (nonatomic ,strong) InputPasswrodView *inputPassView;//输入密码的封装

@property (nonatomic, strong) UIImageView *logoImage;

- (void)saveKeychainArray;

@end



static NSString *const kOTPKeychainEntriesArray = @"OTPKeychainEntries";


@implementation AppDelegate

- (void)saveKeychainArray {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *keychainReferences = [self valueForKeyPath:@"authURLs.keychainItemRef"];
    [ud setObject:keychainReferences forKey:kOTPKeychainEntriesArray];
    [ud synchronize];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化userinfo
    [[UserInfo sharedUserInfo] getUserInfo];
   // [UserInfo sharedUserInfo].isLoadInfo = NO;
    //获取uuid : 序列号
    SYLog(@"uuid-----------------%@", [UserInfo sharedUserInfo].localUUID);
    
    //设置为登录模式
    [UserInfo sharedUserInfo].isLoginToApp = YES;
    
    //强引用 初始化
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *savedKeychainReferences = [ud arrayForKey:kOTPKeychainEntriesArray];
    self.authURLs = [NSMutableArray arrayWithCapacity:[savedKeychainReferences count]];
    
    //[UserInfo sharedUserInfo].isSetPassword = NO;
    //初始化一个secret
    NSString *secret = @"abcdabcdabcdabcd";
    NSString *encodedSecret = secret;
    NSData *secretData = [OTPAuthURL base32Decode:encodedSecret];
    NSURL *url = [NSURL URLWithString:@"otpauth://totp/(null)?"];
    OTPAuthURL *authURL = [OTPAuthURL authURLWithURL:url secret:secretData];
    SYLog(@"authURL------%@", authURL.otpCode);
    if (authURL) {
        [self.authURLs addObject:authURL];//强引用不让authURL释放
    }
    
    //初始化 network
    [[NetworkTool sharedNetworkTool] getManagerBySingleton];
    
    /*
     * 获取客服链接
     */
    [[NetworkTool sharedNetworkTool] getCustomerServiceCompletion:^(BOOL isSuccess, id response) {
        NSDictionary *dic = response[@"data"];
        [UserInfo sharedUserInfo].customerService = dic[@"url"];
        
    } Failure:^(id error) {
        
    }];
   
    
    
    //初始化一个 登录密码的window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.fakeRootVC = [[UIViewController alloc] init];
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.fakeRootVC];
    [self.navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:SYWhiteColor}];
    self.navController.navigationBar.barTintColor = SYNavColor;
    
    
    /*禁用系统自带的手势返回*/
    [PublicTool stopSystemPopGestureRecognizerForNavigationController:self.navController];
    self.window.rootViewController = self.navController;
    
    
    
    
    /*
     *  设置登录密码的view等子控件
     */
    [self setUpFakeVC];
    
    
    
  
      return YES;
}

//init 子控件
- (void)setUpFakeVC{
    Weak_Self;
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 64)];
    navView.backgroundColor = SYNavColor;
    [self.fakeRootVC.view addSubview:navView];
    
    self.logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 84, 100, 100)];
    self.logoImage.image = SYImage(@"头像01");
    self.logoImage.layer.cornerRadius = self.logoImage.width / 2;
    self.logoImage.layer.masksToBounds = YES;
    self.logoImage.centerX = self.fakeRootVC.view.width / 2;
    [self.fakeRootVC.view addSubview:self.logoImage];
    
    UILabel *titleLab = [self setUpLabelWithFrame:CGRectMake(0, 195, Screen_Width, 25) textColor:[UIColor blackColor] textAlignment:1 font:[UIFont systemFontOfSize:20] text:@"欢迎使用"];
    [self.fakeRootVC.view addSubview:titleLab];
    
    UILabel *nameLab = [self setUpLabelWithFrame:CGRectMake(0, 230, Screen_Width, 30) textColor:[UIColor colorWithRed:0.31 green:0.54 blue:0.87 alpha:1.00] textAlignment:1 font:[UIFont fontWithName:@"Arial-BoldMT" size:30] text:@"上士安全令牌"];
    [self.fakeRootVC.view addSubview:nameLab];
    
    
    //自定义view : 封装密码输入框
    self.inputPassView = [[InputPasswrodView alloc] initWithFrame:CGRectMake(40, 0, Screen_Width - 80, 45) inputType:0];
    CGPoint centerP = CGPointMake(self.fakeRootVC.view.centerX, self.fakeRootVC.view.centerY);
    self.inputPassView.center = centerP;
    
    /*
     * 返回password : 用于匹配本地化存储的密码
     */
    self.inputPassView.SetBlock = ^(NSString *password) {
        
        // 匹配密码
        if ([password isEqualToString:[PublicTool loadPasswordForIntoApp]]) {
            //密码一致
            [weakSelf.inputPassView.verifyTextField resignFirstResponder];
            [weakSelf.inputPassView clearUpPassword];
            weakSelf.inputPassView.hidden = YES;
            weakSelf.HUD = [MBProgressHUD showHUDAddedTo:weakSelf.fakeRootVC.view animated:YES];
            weakSelf.HUD.mode = MBProgressHUDModeIndeterminate;
            weakSelf.HUD.label.text = @"正在加载";
            
            [weakSelf getInfoToApp];
    
        }else{
            
            //不一致
            [PublicTool showHUDWithViewController:weakSelf.fakeRootVC Text:@"密码错误"];
            [weakSelf.inputPassView.verifyTextField resignFirstResponder];
            [weakSelf.inputPassView clearUpPassword];
        }
    };
    
    /**
     * 弃用
     */
    if ([UserInfo sharedUserInfo].isSetPassword) {
        //[weakSelf.inputPassView.verifyTextField resignFirstResponder];
        //[weakSelf.inputPassView clearUpPassword];
        //weakSelf.inputPassView.hidden = YES;
           }

    
    // 设置是否 添加 输入框 add
    if ([PublicTool loadPasswordForIntoApp].length > 0) {
        //当本地化存储的密码长度 >0 添加
        [self.fakeRootVC.view addSubview:self.inputPassView];
    }else{
        /**
         * 长度 <=0
         * 进入设置密码页面, 强制设置密码.
         */
        SetPasswordViewController *setVC = [[SetPasswordViewController alloc] init];
        setVC.pages = 2;//2页
        setVC.isPush = NO;//不是push进入
        
        //HUD提示
        setVC.SetPassStatusBlock = ^(NSString *status) {
            [PublicTool showHUDWithViewController:weakSelf.fakeRootVC Text:status];

            if ([status isEqualToString:@"密码设置成功"]) {
                /**
                 * 密码设置成功 显示加载 HUD
                 * 创建主Window
                 */
                self.HUD = [MBProgressHUD showHUDAddedTo:weakSelf.fakeRootVC.view animated:YES];
                self.HUD.mode = MBProgressHUDModeIndeterminate;
                self.HUD.label.text = @"正在加载";
                
               
                [weakSelf getInfoToApp];
                
               

            }
            
        };
        
        /*
         * presentView 方式进入设置密码页面
         */
        [self.fakeRootVC presentViewController:setVC animated:YES completion:^{
           // [self.fakeRootVC.view addSubview:self.inputPassView];
        }];
    }

}


- (void)getInfoToApp{
    Weak_Self;
    [[NetworkTool sharedNetworkTool] getAppInfoForGoToViewControllerCompletion:^(BOOL isSuccess, id respones) {
//        isSuccess = NO;
        if (isSuccess) {
            NSDictionary *appDict = respones[@"data"];
            int status = [appDict[@"app_status"] intValue];
            if (status == 0) {
                [UserInfo sharedUserInfo].goVC = YES;
            }else if (status == 1){
                [UserInfo sharedUserInfo].goVC = NO;
            }

            
            [UserInfo sharedUserInfo].isLoadInfo = YES;
            //进入 根window
            [weakSelf loadRootWindowData];
        }else{
            [UserInfo sharedUserInfo].goVC = NO;
            //进入 根window
            [weakSelf loadRootWindowData];
        }
    } failure:^(id error) {
        [PublicTool showHUDWithViewController:weakSelf.fakeRootVC Text:@"网络加载异常"];
    }];
}

/**
  后期可能会用到 : 指纹解锁
 ZFTouchID *touchID = [[ZFTouchID alloc] init];
 [touchID TouchIDWithDetail:@"" Block:^(BOOL success, kErrorType type, NSError *error) {
 if (success) {
 // 识别成功
 SYLog(@"识别成功");
 [self loadRootWindowData];
 //self.window = nil;
 
 }else {
 // 识别失败
 SYLog(@"识别失败");
 // 如果验证失败，需要在这里判断各种不同的情况已进行不同的处理
 switch (type) {
 case kErrorTypeAuthenticationFailed:
 SYLog(@"kErrorTypeAuthenticationFailed");
 break;
 case kErrorTypeUserCancel:
 SYLog(@"kErrorTypeUserCancel");
 break;
 case kErrorTypeUserFallback:
 SYLog(@"kErrorTypeUserFallback");
 break;
 // ...
 default:
 break;
 }
 }
 }];
 

 
 */


//创建rootWindow
- (void)loadRootWindowData{
    
    /**
     * 初始化两个页面
     * DSLoginViewController : 登录页
     * ViewController  :  动态口令展示页等
     * 判断后决定进入哪个页面
     */
    DSLoginViewController *loginVC = [[DSLoginViewController alloc] init];
    ViewController *vc = [[ViewController alloc] init];
    
    
    Weak_Self;
    
    //获取token : token是时效性
    [UserInfo sharedUserInfo].token = [PublicTool getToken];
    //    [UserInfo sharedUserInfo].token = @"";
    //判断token的长度
    if ([UserInfo sharedUserInfo].token.length > 1) {
        
        /*
         * 获取列表接口
         * 获取数据 : 当前设备对应序列号下有哪些账号信息
         * username, secret, userID
         */
        [[NetworkTool sharedNetworkTool] getUserDynamicWithSn:[UserInfo sharedUserInfo].postUUID completion:^(BOOL isSuccess, id respones) {
            //isSuccess = NO;
            
            if (isSuccess) {
                
                [weakSelf.HUD hideAnimated:YES afterDelay:1];
                
                //读取 保存本地的secret
                [UserInfo sharedUserInfo].secretCode = [PublicTool getSecretCodeForFastLogin];
                //                [UserInfo sharedUserInfo].secretCode = @"";//test
                
                //判断secret是否是空
                if ([UserInfo sharedUserInfo].secretCode.length > 1) {
                    //不为空
                    // 接解析respones
                    NSArray *array = respones[@"data"];//获取到一个数组, 内部是用户信息
                    
                    /*
                     * 遍历数组
                     * 数组内是字典
                     */
                    for (NSDictionary *dict in array) {
                        /*
                         * 判断 本地保存的secret是否与服务器的数据对应
                         */
                        if ([[UserInfo sharedUserInfo].secretCode isEqualToString:dict[@"secret"]]) {
                            // 对应 : 获取用户名
                            [UserInfo sharedUserInfo].userName = dict[@"username"];
                        }
                    }
                    
                    // nav设置rootviewcontroller 导航栏
                    weakSelf.navController = [[UINavigationController alloc] initWithRootViewController:vc];
                    
                    vc.textStr = [weakSelf addOTPWithTimeLag];//强引用 : 让算法激活
                    
                }else{
                    
                    //进入登录页 设置根控制器
                    loginVC.pushWay = 0;
                    weakSelf.navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //HUD
                    [weakSelf.HUD hideAnimated:YES afterDelay:1];
                    
                    //进入下级页面方法
                    [weakSelf pushSomewhere];
                    
                });
                
                
            }else{
                [weakSelf.HUD hideAnimated:YES afterDelay:1];
                /**
                 * response[@"code"] = -10000
                 * 表示token失效, 需要重新登录 获取新的token
                 */
                //int i = -10000;
                if ([respones[@"code"] intValue] == -10000) {
                    
                    loginVC.pushWay = 0;
                    [weakSelf.HUD hideAnimated:YES afterDelay:1];
                    
                   dispatch_async(dispatch_get_main_queue(), ^{
                       weakSelf.navController = [[UINavigationController alloc] initWithRootViewController:loginVC];

                       [weakSelf pushSomewhere];

                    });
                    //                    return YES;
                }
            }
        } failure:^(id error) {
            
        }];
        
        
    }else{
        // secret为空 本地没有储存秘钥 进入登录页
        loginVC.pushWay = 0;
        self.navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [weakSelf.HUD hideAnimated:YES afterDelay:1];
        
        [weakSelf pushSomewhere];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
        });
        
        
    }
    
    

}

/*
 //创建 rootWindow
 self.rootWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
 self.rootWindow.backgroundColor = SYWhiteColor;
 self.rootWindow.windowLevel = UIWindowLevelAlert;//roowindow 显示等级 : 高等级, 覆盖掉密码视图
 [self.navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:SYWhiteColor}];
 self.navController.navigationBar.barTintColor = SYNavColor;
 [PublicTool stopSystemPopGestureRecognizerForNavigationController:self.navController];
 self.rootWindow.rootViewController = self.navController;
 [self.rootWindow makeKeyAndVisible];
 */


- (void)pushSomewhere{
    /*
     * 利用密码页模态弹出下级页面,并销毁密码页
     * 采用同个UINavigationController,
     */
    /*禁用系统自带的手势返回*/

    [PublicTool stopSystemPopGestureRecognizerForNavigationController:self.navController];

    [self.fakeRootVC presentViewController:self.navController animated:YES completion:^{
        self.fakeRootVC = nil;
    }];
   
    
    
   
}

//简单封装一个label的init
- (UILabel *)setUpLabelWithFrame:(CGRect)frame textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font text:(NSString *)text{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    label.font = font;
    label.numberOfLines = 0;
    label.text = text;
    return label;
}



/*设置验证码*/
- (NSString *)addOTPWithTimeLag{
    /**
     * 此方法后面会一直用到
     * 让算法与通知一直保持激活状态
     */
    
    NSString *secret = [UserInfo sharedUserInfo].secretCode;
    NSString *checkCode = [NSString string];
    
    
    NSString *encodedSecret = secret;
    NSData *secretData = [OTPAuthURL base32Decode:encodedSecret];
    
    if ([secret length]) {
        NSString *name = @"123";
        OTPAuthURL *authURL = [[TOTPAuthURL alloc] initWithSecret:secretData
                                                             name:name];
        checkCode = authURL.otpCode;
        if (authURL) {
            [self.authURLs addObject:authURL];
        }
    }
    
    //    NSData *secretData = [secret dataUsingEncoding:NSASCIIStringEncoding];
    SYLog(@"-----------------secretData:%@", secretData);
    TOTPGenerator *generator = [[TOTPGenerator alloc] initWithSecret:secretData algorithm:[TOTPGenerator defaultAlgorithm] digits:[TOTPGenerator defaultDigits] period:60];
    //    HOTPGenerator *generator = [[HOTPGenerator alloc] initWithSecret:secretData algorithm:kOTPGeneratorSHA1Algorithm digits:6 counter:0];
    //    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timelag];
    //    NSDate *date = [NSDate date];
    NSString *str = [generator generateOTP];
    while (str.length < 6) {
        
        str = [NSString stringWithFormat:@"0%@",str];
    }
    return str;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
