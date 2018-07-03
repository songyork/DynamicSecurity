//
//  DSLoginViewController.m
//  DynamicSecurity
//
//  Created by SDK on 2017/11/4.
//  Copyright © 2017年 songyan. All rights reserved.
//

#import "DSLoginViewController.h"

#import "ViewController.h"
#import "DSBingMobilViewController.h"
@interface DSLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLab;
@property (weak, nonatomic) IBOutlet UIView *userBoradView;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UIButton *userClearBtn;
@property (weak, nonatomic) IBOutlet UILabel *passwordLab;
@property (weak, nonatomic) IBOutlet UIView *passwordBoradView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *passClearBtn;
@property (weak, nonatomic) IBOutlet UIButton *showPassBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *topView;
@property (weak, nonatomic) IBOutlet UILabel *navTitleLab;

@property(nonatomic,strong) MBProgressHUD *HUD;

@property (nonatomic ,strong) UIButton *backBtn;

@property (nonatomic ,strong) UILabel *titleLab;

@property (nonatomic, assign) BOOL userClear;

@property (nonatomic, assign) BOOL passClear;

@property (nonatomic ,strong) NSMutableArray *autherArr;

@property (nonatomic, copy) NSString *string;

@end

@implementation DSLoginViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:SYWhiteColor}];
        self.navigationController.navigationBar.barTintColor = SYNavColor;

    self.autherArr = [NSMutableArray new];
    self.string = [self addOTPWithTimeLag];
    
    
    [self setUpSubViews];//设置子控件
    
    [[NetworkTool sharedNetworkTool] getManagerBySingleton];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.userTextField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.passwordTextField];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.pushWay == LoginToApp) {
        self.title = @"登录";
        
    }else{
        self.title = @"添加账号";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[PublicTool creatBackBtnWithTarget:self Action:@selector(backClick)]];

    }

    
    if ([UserInfo sharedUserInfo].isLoginToApp) {
        self.pushWay = 0;
        //test
//        self.userTextField.text = @"TY123453f";
//        self.passwordTextField.text = @"123456";
//        [self loginClick:self.passwordTextField.text];
    }else{
        
        // 添加账号模式 添加topview title
        self.pushWay = 1;
        self.topView.userInteractionEnabled = YES;
       // [self.topView addSubview:self.backBtn];
//        self.backBtn.centerY = (self.topView.centerY+20);
        
        [self.topView addSubview:self.titleLab];
        CGPoint titleCenter = CGPointMake(Screen_Width / 2, 42);
        self.titleLab.center = titleCenter;
//        self.userTextField.text = @"ssysss";
//        self.passwordTextField.text = @"111111";
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 让textfield的值为空
    self.userTextField.text = @"";
    self.passwordTextField.text = @"";
}

- (void)setUpSubViews{
    
    self.userClear = NO;
    
    self.passClear = NO;
    
    self.navTitleLab.textColor = SYWhiteColor;
    
//    self.logoView.backgroundColor = [UIColor colorWithRed:0.2 green:0.54 blue:0.93 alpha:1];
    
    self.usernameLab.textColor = [UIColor colorWithRed:0.00 green:0.47 blue:0.88 alpha:1.00];
    
    self.passwordLab.textColor = [UIColor colorWithRed:0.00 green:0.47 blue:0.88 alpha:1.00];
    
    self.userTextField.delegate = self;
    
    self.passwordTextField.delegate = self;
    self.passwordTextField.secureTextEntry = YES;

    self.userBoradView.layer.borderWidth = 1;
    self.userBoradView.layer.borderColor = [UIColor blackColor].CGColor;
    self.userBoradView.layer.cornerRadius = 5;
    self.userBoradView.layer.masksToBounds = YES;
    
    
    self.passwordBoradView.layer.borderWidth = 1;
    self.passwordBoradView.layer.borderColor = [UIColor blackColor].CGColor;
    self.passwordBoradView.layer.cornerRadius = 5;
    self.passwordBoradView.layer.masksToBounds = YES;
}

#pragma mark ------------------------------------------------Click & Method

// 返回
- (void)backClick{
    SYLog(@"back");
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)clearClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 100) {
        SYLog(@"账号清除");
        self.userTextField.text = @"";
    }else if (btn.tag == 101){
        SYLog(@"密码清除");
        self.passwordTextField.text = @"";
    }
    
}
- (IBAction)showPassClick:(id)sender {
    SYLog(@"show");
    
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
    if (self.passwordTextField.secureTextEntry) {
        [self.showPassBtn setImage:SYImage(@"3") forState:UIControlStateNormal];
        SYLog(@"不显示密码");
    }else{
        [self.showPassBtn setImage:SYImage(@"2") forState:UIControlStateNormal];
        SYLog(@"显示密码");
    }
    
}
- (IBAction)loginClick:(id)sender {
    SYLog(@"登录");
    
    //判断输入账号是否符合条件
    if (self.userTextField.text.length < 6 || self.userTextField.text == nil) {
        [PublicTool showHUDWithViewController:self Text:@"请按规定填写账号"];
        return;
    }else{
        //a-zA-Z0-9
        // 正则表达式 : 判断是否有中文
        NSString *regex = @"^([\u4E00-\u9FA5]+)$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isEmpty = [PublicTool isEmpty:self.userTextField.text];//是否有空格
        if([pred evaluateWithObject:self.userTextField.text] || isEmpty) {
            [PublicTool showHUDWithViewController:self Text:@"请按规定填写账号"];
            return;
        }
        
    }
//    [self.HUD removeFromSuperview];
//    self.HUD = nil;
    
    if (self.passwordTextField.text.length < 6 || self.passwordTextField.text == nil) {
        [PublicTool showHUDWithViewController:self Text:@"请按规定填写密码"];
        return;
    }else{
        NSString *regex = @"^([\u4E00-\u9FA5]+)$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isEmpty = [PublicTool isEmpty:self.passwordTextField.text];
        //![pred evaluateWithObject:self.passwordTextField.text] ||
        if([pred evaluateWithObject:self.passwordTextField.text] || isEmpty) {
            [PublicTool showHUDWithViewController:self Text:@"请按规定填写密码"];
            return;
        }
        
        //        if ([self.passwordTextField.text hasPrefix:@" "]) {
        //            [self showHUDWithText:@"密码开头不能有空格"];
        //
        //            return;
        //        }
        //        if ([self.passwordTextField.text hasSuffix:@" "]) {
        //            [self showHUDWithText:@"密码最后一位不能有空格"];
        //            return;
        //        }
    }
    
    //进入申请数据 判断获取哪个接口
    if (self.pushWay == 0) {
        [self loginToApp];
    }else{
        [self addToApp];
    }
    
}

// 登录
- (void)loginToApp{
    Weak_Self;

    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    self.HUD.label.text = @"正在登录";
    
    
    [[NetworkTool sharedNetworkTool] loginWithUserName:self.userTextField.text Password:self.passwordTextField.text sn:[UserInfo sharedUserInfo].postUUID Completion:^(BOOL isSuccess, id respones) {
        //test
        //                isSuccess = YES;
        if (isSuccess) {
            NSDictionary *dict = respones[@"data"];
            NSString *phone = dict[@"phone"];
            [UserInfo sharedUserInfo].token = dict[@"token"];
            [UserInfo sharedUserInfo].userID = dict[@"user_id"];
            [UserInfo sharedUserInfo].phoneNumber = phone;
            [UserInfo sharedUserInfo].userName = dict[@"username"];
            [UserInfo sharedUserInfo].bind = [dict[@"bind"] intValue];
            [PublicTool saveToken:[UserInfo sharedUserInfo].token];
            
            //[UserInfo sharedUserInfo].bind = -1;
            //bind = -1 表示此账号与其它设备进行过绑定
            if ([UserInfo sharedUserInfo].bind == -1) {
                [weakSelf.HUD hideAnimated:YES];
                [PublicTool showHUDWithViewController:self Text:@"该账号已与其它设备绑定"];

            }else{
                // 获取列表
                [[NetworkTool sharedNetworkTool] getUserDynamicWithSn:[UserInfo sharedUserInfo].postUUID completion:^(BOOL isSuccess, id respones) {
                    if (isSuccess) {
                        self.HUD.mode = MBProgressHUDModeText;
                        weakSelf.HUD.label.text = @"登录成功";
                        [weakSelf.HUD hideAnimated:YES afterDelay:1.0f];
                        weakSelf.HUD.minSize = CGSizeMake(0, 0);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            //                        phone = @"15570705522";
                            
                            DSBingMobilViewController *bindVC = [[DSBingMobilViewController alloc] init];
                            bindVC.phoneNumberStr = phone;//获取phoneNumber
                            
                            //                phone = @"";
                            // 号码是否是空
                            if (phone.length > 1) {
                                // 不为空 : 绑定过手机
                                bindVC.proveType = HasBindPhone;
                            }else{
                                
                                // 为空 : 没有绑定过手机
                                bindVC.proveType = NotBindPhone;
                            }
                            //            NSString *userName = respones[@"data"][@"username"];
                            NSArray *userArray = respones[@"data"];
                            SYLog(@"-----%@", userArray);
                            
                            
                            // 初始化 动态口令页面
                            ViewController *vc = [[ViewController alloc] init];
                            NSDictionary *dicu = [NSDictionary new];
                            //遍历
                            if (userArray.count > 0) {
                                for (dicu in userArray) {
                                    if ([weakSelf.userTextField.text isEqualToString:dicu[@"username"]]) {
                                        //存在相同的账号
                                        SYLog(@"%@", dicu[@"username"]);
                                        [UserInfo sharedUserInfo].secretCode = dicu[@"secret"];
                                        //保存secret
                                        [PublicTool fastLoginWithSecretCode:[UserInfo sharedUserInfo].secretCode];
                                        
                                        
                                    }
                                }
                                
                            }
                            vc.textStr = [self addOTPWithTimeLag];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                /*
                                 * 审核模式
                                 * goVC = YES   :   直接进入VC, 无需绑定
                                 */
                                if ([UserInfo sharedUserInfo].goVC) {
                                    [UserInfo sharedUserInfo].secretCode = @"abcdefghijklmnop";
                                   // vc.bindPush = YES;
                                    [weakSelf.navigationController pushViewController:vc animated:YES];
                                    return;
                                }
                                
                                
                                NSDictionary *userDic = [NSDictionary new];
                                //用户信息列表是否是空
                                if (userArray.count > 0) {
                                    for (userDic in userArray) {
                                        if ([weakSelf.userTextField.text isEqualToString:userDic[@"username"]]) {
                                            SYLog(@"%@", userDic[@"username"]);
                                            [UserInfo sharedUserInfo].secretCode = userDic[@"secret"];
                                            //匹配用户名 和 电话是否为空
                                           
                                            if (phone.length > 1) {
                                                
                                                // 进入vc
                                                [weakSelf.navigationController pushViewController:vc animated:YES];
                                                return;
                                            }
                                           
                                        }
                                    }
                                    //进入绑定
                                    [weakSelf.navigationController pushViewController:bindVC animated:YES];
                                    
                                }else{
                                    //进入绑定
                                    [weakSelf.navigationController pushViewController:bindVC animated:YES];
                                }
                                
                                
                            });
                            
                        });
                    }else{
                        
                    }
                } failure:^(id error) {
                    
                }];

            }
            
        }else{
            weakSelf.HUD.mode = MBProgressHUDModeText;
            weakSelf.HUD.label.text = respones[@"msg"];
            [weakSelf.HUD hideAnimated:YES afterDelay:1];
            
        }
    }Failure:^(id error) {
        weakSelf.HUD.mode = MBProgressHUDModeText;
        weakSelf.HUD.label.text =@"网络异常";
        [weakSelf.HUD hideAnimated:YES afterDelay:1];
    }];
    
    
    
}

// 添加账号
- (void)addToApp{
    Weak_Self;
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    self.HUD.label.text = @"正在登录";
    
    
    [[NetworkTool sharedNetworkTool] getUserDynamicWithSn:[UserInfo sharedUserInfo].postUUID completion:^(BOOL isSuccess, id respones) {
        if (isSuccess) {
            //            NSString *userName = respones[@"data"][@"username"];
            NSArray *userArray = respones[@"data"];
            SYLog(@"-----%@", userArray);
            // 添加账号接口
            [[NetworkTool sharedNetworkTool] addUserToAppWithUserName:self.userTextField.text password:self.passwordTextField.text completion:^(BOOL isSuccess, id respones) {
                if (isSuccess) {
                    self.HUD.mode = MBProgressHUDModeText;
                    weakSelf.HUD.label.text = @"登录成功";
                    [weakSelf.HUD hideAnimated:YES afterDelay:1.0f];
                    weakSelf.HUD.minSize = CGSizeMake(0, 0);
                    NSDictionary *dict = respones[@"data"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *phone = dict[@"phone"];
                        [UserInfo sharedUserInfo].userID = dict[@"user_id"];
                        [UserInfo sharedUserInfo].phoneNumber = phone;
                        [UserInfo sharedUserInfo].userName = dict[@"username"];
                        
                        // 与登录一样 , 判断是否可以直接进入 vc
                        DSBingMobilViewController *bindVC = [[DSBingMobilViewController alloc] init];
                        bindVC.phoneNumberStr = phone;
                        //                phone = @"";
                        if (phone.length > 1) {
                            bindVC.proveType = HasBindPhone;
                        }else{
                            bindVC.proveType = NotBindPhone;
                        }
                        
                        /*
                        ViewController *vc = [[ViewController alloc] init];
                        NSDictionary *dicu = [NSDictionary new];
                        
                        if (userArray.count > 0) {
                            for (dicu in userArray) {
                                if ([weakSelf.userTextField.text isEqualToString:dicu[@"username"]]) {
                                    SYLog(@"%@", dicu[@"username"]);
                                    [UserInfo sharedUserInfo].secretCode = dicu[@"secret"];
                                    
                                }
                            }
                            
                        }
                        vc.textStr = [self addOTPWithTimeLag];
                        */
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            /*
                             * 审核模式
                             * goVC = YES   :   直接进入VC, 无需绑定
                             */
                            if ([UserInfo sharedUserInfo].goVC) {
                                [UserInfo sharedUserInfo].secretCode = @"abcdefghijklmnop";
                                // vc.bindPush = YES;
                                for (UIViewController *temp in self.navigationController.viewControllers) {
                                    if ([temp isKindOfClass:[ViewController class]]) {
                                        [self.navigationController popToViewController:temp animated:YES];
                                    }
                                }
                                return;
                            }

                            
                            NSDictionary *userDic = [NSDictionary new];
                            if (userArray.count > 0) {
                                for (userDic in userArray) {
                                    if ([weakSelf.userTextField.text isEqualToString:userDic[@"username"]]) {
                                        SYLog(@"%@", userDic[@"username"]);
                                        [UserInfo sharedUserInfo].secretCode = userDic[@"secret"];
                                        [PublicTool fastLoginWithSecretCode:[UserInfo sharedUserInfo].secretCode];
                                        
                                        /*
                                         * 获取到 账号与用户信息匹配 
                                         * 遍历navigationController 找到 ViewController 类的 UIViewController
                                         * 进入ViewController
                                         */
                                        
                                            for (UIViewController *temp in self.navigationController.viewControllers) {
                                                if ([temp isKindOfClass:[ViewController class]]) {
                                                    [self.navigationController popToViewController:temp animated:YES];
                                                }
                                            }
                                        //跳转后不继续执行代码
                                        return;
                                    }
                                }
                                [weakSelf.navigationController pushViewController:bindVC animated:YES];
                                
                            }else{
                                [weakSelf.navigationController pushViewController:bindVC animated:YES];
                            }
                            
                            
                        });
                        
                    });
                    
                }else{
                    weakSelf.HUD.mode = MBProgressHUDModeText;
                    weakSelf.HUD.label.text = respones[@"msg"];
                    [weakSelf.HUD hideAnimated:YES afterDelay:1];
                }
            }failure:^(id error) {
                weakSelf.HUD.mode = MBProgressHUDModeText;
                weakSelf.HUD.label.text =@"网络异常";
                [weakSelf.HUD hideAnimated:YES afterDelay:1];
            }];
            
        }else{
            
        }
    } failure:^(id error) {
        
    }];
    
    
}

- (NSString *)addOTPWithTimeLag{
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
            [self.autherArr addObject:authURL];
        }
    }
    
    //    NSData *secretData = [secret dataUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"-----------------secretData:%@", secretData);
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



#pragma mark ----------------------------------------------UITextFieldDelegate
// 点击了return键
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.userTextField || textField == self.passwordTextField) {
        if (textField.isFirstResponder) {
            [textField resignFirstResponder];
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    self.textFieldY = textField.y;
}

# pragma mark --------------------------------------------------------------- 输入框输入的文字限制
/*输入框输入的文字限制*/

-(void)textFieldEditChanged:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    if (textField == self.userTextField) {
        [self limitTextLengthFor:textField length:15];
    }
    if (textField == self.self.passwordTextField) {
        [self limitTextLengthFor:textField length:15];
    }
    
    
}


- (void)limitTextLengthFor:(UITextField *)textField length:(NSInteger)maxLength{
    NSString *toBeString = textField.text;
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > maxLength)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:maxLength];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    
}




#pragma mark --- 监听键盘
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
    
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    // 获取键盘弹出动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    SYLog(@"打印键盘的高度：%f",(self.view.frame.size.height - height));
    SYLog(@"%f", (self.passwordBoradView.frame.size.height + self.passwordBoradView.frame.origin.y));

//    float usetTextY = self.userBoradView.height + self.userBoradView.y;
    float passTextY = self.passwordBoradView.height + self.passwordBoradView.y;//获取passwordBoradView的Y值
    float keyY = self.view.height - height;//获取键盘的Y值
    /*
     * 当passwordTextField在第一响应下
     * 如果键盘的Y轴 <= passwordBoradView的Y轴
     * view向上移动
     */
    if (self.passwordTextField.isFirstResponder) {
        if (passTextY >= keyY) {
            SYLog(@"输入框被遮挡");
            // 如果已移动了 就不在移动
            if (self.view.y != (-100)) {
                [UIView animateWithDuration:animationDuration animations:^{
                    self.view.y -= 100;
                }];
            }
        }

    }
    
}

#pragma mark ----------------------------------------------回收键盘
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];

    // 获取键盘弹出动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    if (self.passwordTextField.isFirstResponder) {
        [UIView animateWithDuration:animationDuration animations:^{
            self.view.y = 0;
        }];

    }
}

#pragma mark ------------------------------------------------ Lazy & Init

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [PublicTool createBtnWithButton:_backBtn buttonType:UIButtonTypeCustom frame:CGRectMake(10, 27, 40, 30) backgroundColor:SYNOColor image:SYImage(@"min77_back_bt") normalTile:nil selectedTitle:nil highlightTile:nil textAlignment:1 selected:nil titleNormalColor:nil titleSelectedColor:nil titleHighlightedColor:nil];
        [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 20)];
        _titleLab.textColor = SYWhiteColor;
        _titleLab.textAlignment = 1;
        _titleLab.text = @"添加账号";
        _titleLab.font = [UIFont systemFontOfSize:16];
    }
    return _titleLab;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];//结束编辑
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
