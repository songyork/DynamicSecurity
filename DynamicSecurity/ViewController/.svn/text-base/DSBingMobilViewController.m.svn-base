//
//  DSBingMobilViewController.m
//  DynamicSecurity
//
//  Created by songyan on 2017/11/5.
//  Copyright © 2017年 songyan. All rights reserved.
//

#import "DSBingMobilViewController.h"
#import "DWCoreTextLabel.h"
#import "ViewController.h"

@interface DSBingMobilViewController ()<UITextFieldDelegate>
{
    UIButton *knowBtn;
}
@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UILabel *tipsLab;

@property (nonatomic ,strong) UILabel *phoneLab;

@property (nonatomic ,strong) UIButton *getCodeBtn;

@property (nonatomic ,strong) UIButton *bindBtn;

@property (nonatomic, strong) UIButton *readBtn;

@property (nonatomic, strong) UIView *phoneBorderView;//输入框边框

@property (nonatomic, strong) UIView *codeBorderView;//

@property (nonatomic ,strong) UITextField *inputTF;

@property (nonatomic ,strong) UITextField *phoneNumTextField;

@property (nonatomic, copy) NSString *verificationPhoneStr;//验证手机号码, 是否与获取验证码的手机号一致

@property(nonatomic,strong)NSTimer *telCodeTimer;//验证码倒计时

@property(nonatomic,assign)NSInteger timerNumber;//倒计时时间

@property (nonatomic, strong) UIWindow *readWindow;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *tipsView;

@property (nonatomic ,strong) DWCoreTextLabel * readLabel;

@property (nonatomic, strong)dispatch_source_t time;//定时器

@property (nonatomic, assign) int i;

@property (nonatomic ,strong) NSMutableArray *autherArr;

@property (nonatomic, assign) BOOL isRead;// 强制阅读

@end

@implementation DSBingMobilViewController

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.phoneNumberStr.length > 1) {
        [self getClick:nil];
    }
    if (self.phoneNumTextField) {
        //13927260906
//        self.phoneNumTextField.text = @"15212295995";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.autherArr = [NSMutableArray new];
    [self addSubViews];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"绑定安全令牌";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[PublicTool creatBackBtnWithTarget:self Action:@selector(backClick)]];

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.phoneNumTextField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.inputTF];
    
    [[NetworkTool sharedNetworkTool] getManagerBySingleton];
    self.isRead = NO;
}

- (void)addSubViews{
    
    //[self.view addSubview:self.topView];
    [self.view addSubview:self.tipsLab];
    [self.view addSubview:self.phoneLab];
    [self.view addSubview:self.phoneBorderView];
    [self.view addSubview:self.codeBorderView];
    if (self.proveType == NotBindPhone) {
        [self.view addSubview:self.phoneNumTextField];
    }
    [self.view addSubview:self.inputTF];
    [self.view addSubview:self.getCodeBtn];
    [self.view addSubview:self.bindBtn];
    [self.view addSubview:self.readBtn];
    
    //根据 验证方式来设置 text
    if (self.proveType == HasBindPhone) {
        self.phoneLab.text = @"请绑定安全令牌";
    }else {
        self.phoneLab.text = @"您好,请先输入您的手机号进行绑定";
    }
    
    [self layoutUI];
}

- (void)layoutUI{
    Weak_Self;
    CGSize labSize = [self.tipsLab.text boundingRectWithSize:CGSizeMake(Screen_Width - 80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.tipsLab.font} context:nil].size;
    [self.tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(24 + 64);
        make.left.equalTo(weakSelf.view).offset(40);
        make.right.equalTo(weakSelf.view).offset(-40);
        make.height.mas_equalTo(labSize.height +10);
    }];
    if (self.proveType == NotBindPhone) {
        [self.phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.tipsLab.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(Screen_Width, 30));
        }];
        [self.phoneBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.phoneLab.mas_bottom).offset(10);
            make.left.equalTo(weakSelf.view).offset(40);
            make.right.equalTo(weakSelf.view).offset(-40);
            make.height.mas_equalTo(40);
        }];
        [self.phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.phoneBorderView);
            make.left.equalTo(weakSelf.phoneBorderView).offset(8);
            make.right.equalTo(weakSelf.phoneBorderView).offset(-8);
            make.height.mas_equalTo(40);
        }];
        [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.left.equalTo(weakSelf.codeBorderView.mas_right).offset(5);
            make.right.equalTo(weakSelf.phoneBorderView);
            make.size.mas_equalTo(CGSizeMake(74, 40));
            make.centerY.equalTo(weakSelf.codeBorderView);
        }];
        [self.codeBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.phoneBorderView.mas_bottom).offset(17);
            make.left.equalTo(weakSelf.phoneBorderView);
            make.right.equalTo(weakSelf.getCodeBtn.mas_left).offset(-5);
            make.height.mas_equalTo(40);
        }];
        [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.codeBorderView);
            make.left.equalTo(weakSelf.codeBorderView).offset(8);
            make.right.equalTo(weakSelf.codeBorderView).offset(-8);
            make.height.mas_equalTo(40);
        }];
    }else{
        [self.phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.tipsLab.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(Screen_Width, 30));
        }];
        [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.phoneLab.mas_bottom).offset(20);
            make.right.equalTo(weakSelf.view).offset(-40);
            make.size.mas_equalTo(CGSizeMake(74, 40));
        }];
        [self.codeBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view).offset(40);
            make.right.equalTo(weakSelf.getCodeBtn.mas_left).offset(-5);
            make.centerY.equalTo(weakSelf.getCodeBtn);
            make.height.mas_equalTo(40);
        }];
        [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.codeBorderView);
            make.left.equalTo(weakSelf.codeBorderView).offset(8);
            make.right.equalTo(weakSelf.codeBorderView).offset(-8);
            make.height.mas_equalTo(40);
        }];
    }
    [self.readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.codeBorderView.mas_bottom).offset(30);
        make.left.equalTo(weakSelf.codeBorderView);
        make.size.mas_equalTo(CGSizeMake((Screen_Width - 80) /2 - 8, 40));

    }];
    [self.bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.readBtn);
        make.left.equalTo(weakSelf.readBtn.mas_right).offset(16);
        make.right.equalTo(weakSelf.getCodeBtn);
        make.height.mas_equalTo(40);
    }];
   
}

#pragma mark ----------------------------------------------Other Method
- (void)currentTime{
    //*** 2、开启计时器
    if (!_telCodeTimer) {
        _timerNumber = 60;
        _telCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getTelCodeBtn) userInfo:nil repeats:YES];
        [_telCodeTimer fire];
    }
    
}

// 定时器响应方法
-(void)getTelCodeBtn{
    _timerNumber -- ;
    if (_timerNumber == 0) {
        
        [_telCodeTimer invalidate];
        _telCodeTimer = nil;
        [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.getCodeBtn.enabled = YES;
        if (self.proveType == HasBindPhone) {
            self.phoneLab.text = @"请绑定安全令牌";
        }else{
            self.phoneLab.text = @"您好,请先输入您的手机号进行绑定";
        }
        

    }else{
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"(%lds)",(long)_timerNumber] forState:0];
        self.getCodeBtn.enabled = NO;
        
        NSString *phone = [NSString string];
        if (self.phoneNumberStr.length > 1) {
            phone = self.phoneNumberStr;
        }else{
            phone = self.phoneNumTextField.text;
        }
//        phone = [NSString st]
        NSMutableString *phoneNumber = [phone mutableCopy];
        NSRange range = {3,4};
        [phoneNumber replaceCharactersInRange:range withString:@"****"];
        self.phoneLab.text = [NSString stringWithFormat:@"验证码已发送到:%@",phoneNumber];
    }
}

#pragma mark ----------------------------------------------BTNClick
- (void)backClick{
    SYLog(@"-----返回");
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)bindClick{
    SYLog(@"--------绑定");
    //根据proveType 来进行处理绑定模式
    if (self.proveType == HasBindPhone) {
        // 绑定过手机 获取上级页面传的电话号码
        if (self.phoneNumberStr.length > 1 || self.inputTF.text.length > 1) {
            if ([self.phoneNumberStr isEqualToString:self.verificationPhoneStr]) {
                [self hasBindPhone];
            }else{
                [PublicTool showHUDWithViewController:self Text:@"手机号不一致请重新填写"];

            }
        
        }else{
            [PublicTool showHUDWithViewController:self Text:@"请填写手机号和验证码"];
        }

    }else{
        //没有绑定手机 获取textfield的值
        if (self.phoneNumTextField.text.length > 1 || self.inputTF.text.length > 1) {
            if ([self.phoneNumTextField.text isEqualToString:self.verificationPhoneStr]) {
                [self notBindPhone];
            }else{
                [PublicTool showHUDWithViewController:self Text:@"手机号不一致请重新填写"];
                
            }
            
        }else{
            [PublicTool showHUDWithViewController:self Text:@"请填写手机号和验证码"];
        }

        
    }
    
}

- (void)readClick{
    _i = 10;
    // 阅读页面 单独一个window 弹出
    SYLog(@"阅读");
    self.readWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, Screen_Height, Screen_Width, Screen_Height)];
    self.readWindow.backgroundColor = SYNOColor;
    self.readWindow.windowLevel = UIWindowLevelAlert + 0.1;
    [self.readWindow makeKeyAndVisible];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    self.bgView.backgroundColor = SYNOColor;
//    self.bgView.alpha = 0.5;
    [self.readWindow addSubview:self.bgView];
    
    self.tipsView = [[UIView alloc] initWithFrame:CGRectMake(0, 95, 280, 450)];
    self.tipsView.centerX = self.view.centerX;
//    self.tipsView = [[UIView alloc] init];
    self.tipsView.alpha = 0.0;
    self.tipsView.backgroundColor = [UIColor colorWithRed:0.31 green:0.53 blue:0.91 alpha:1.00];
    [self.readWindow addSubview:self.tipsView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.tipsView.width, 20)];
    titleLab.text = @"注  意";
    titleLab.textAlignment = 1;
    titleLab.textColor = SYWhiteColor;
    titleLab.font = [UIFont systemFontOfSize:18];
    [self.tipsView addSubview:titleLab];
    
    // 图文混排
    self.readLabel = [[DWCoreTextLabel alloc] initWithFrame:CGRectMake(10, 40, self.tipsView.width - 20, 350)];
    self.readLabel.text = @"    绑定安全令牌开启后，老版本游戏包将无法登录，需要安装安全版游戏包才能正常游戏。 \n    安全版本游戏包请认准以下标签： \n    安全版游戏包请联系在线客服领取，\n    客服联系方式:打开“用户中心”-“在线客服”";
    self.readLabel.backgroundColor = SYNOColor;
    self.readLabel.font = [UIFont systemFontOfSize:14];
    self.readLabel.textColor = SYWhiteColor;
    [self.tipsView addSubview:self.readLabel];
    CGFloat widthLab = self.readLabel.width;
    CGFloat heightLab = 180.0;
    [self.readLabel dw_DrawImage:SYImage(@"sdk") withImageID:@"sdk" atFrame:CGRectMake(0, 85, widthLab, heightLab) margin:0 drawMode:DWTextImageDrawModeSurround target:nil selector:nil];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.readLabel.height + self.readLabel.y, self.tipsView.width, 1)];
    lineView.backgroundColor = SYWhiteColor;
    [self.tipsView addSubview:lineView];
    
    knowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    knowBtn.frame = CGRectMake(0, lineView.height + lineView.y + 10, 90, 22);
    knowBtn.centerX = 140;
//    knowBtn.backgroundColor = [UIColor redColor];
    [knowBtn setTitle:@"10" forState:UIControlStateNormal];
    [knowBtn setTitle:@"10" forState:UIControlStateHighlighted];
    [knowBtn setBackgroundImage:SYImage(@"an07") forState:UIControlStateNormal];
    knowBtn.enabled = NO;
    [knowBtn setTitleColor:[UIColor colorWithRed:0.31 green:0.53 blue:0.91 alpha:1.00] forState:UIControlStateNormal];
    [knowBtn setTitleColor:[UIColor colorWithRed:0.31 green:0.53 blue:0.91 alpha:1.00] forState:UIControlStateHighlighted];
    [knowBtn addTarget:self action:@selector(knowClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tipsView addSubview:knowBtn];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.readWindow.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
        self.bgView.backgroundColor = [UIColor blackColor];
        self.bgView.alpha = 0.5;
    } completion:^(BOOL finished) {
        self.tipsView.alpha = 1.0f;
        

    }];
    
    [self currentTheTime:_i];
}

- (void)knowClick{
    
    [UIView animateWithDuration:0.1f animations:^{
        //        self.readWindow.width = 0;
        //        self.readWindow.height = 0;
        self.readWindow.frame = CGRectMake(0, Screen_Height, Screen_Width, Screen_Height);
        self.isRead = YES;
        self.getCodeBtn.enabled = YES;
        self.bindBtn.enabled = YES;
        //        self.readWindow.frame = CGRectZero;
    } completion:^(BOOL finished) {
        self.readWindow = nil;
        
    }];
    
}

// 定时器, 用于弹框页面,强制阅读
-(void)currentTheTime:(int)time{
    //获得队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //创建一个定时器
    self.time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC));
    //设置时间间隔
    uint64_t interval = (uint64_t)(1.0* NSEC_PER_SEC);
    //设置定时器
    dispatch_source_set_timer(self.time, start, interval, 0);
    //设置回调
    
    dispatch_source_set_event_handler(self.time, ^{
        //        NSLog(@"%f", _currentTime);
        _i --;
        dispatch_async(dispatch_get_main_queue(), ^{
            [knowBtn setTitle:[NSString stringWithFormat:@"%d", _i] forState:UIControlStateNormal];
            if (_i == 0) {
                [knowBtn setTitle:@"朕知道了" forState:UIControlStateNormal];
                knowBtn.enabled = YES;
                if (_time) {
                    dispatch_source_cancel(_time);

                }
            }
        });
        
        
    });
    
    
    //由于定时器默认是暂停的所以我们启动一下
    //启动定时器
    dispatch_resume(self.time);
}

// 绑定过手机的处理方法
- (void)hasBindPhone{
    
    [PublicTool showAlertToViewController:self alertControllerTitle:@"提示" alertControllerMessage:@"确认是否开启安全令牌" alertCancelTitle:@"否" alertReportTitle:@"是" cancelHandler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    } reportHandler:^(UIAlertAction * _Nonnull action) {
        //确定绑定方法
        [self isSureToBindWithPhoneNumber:self.self.phoneNumberStr];
    } completion:^{
        SYLog(@"完成alert");
    }];
    
}

// 没有绑定过手机的处理方法
- (void)notBindPhone{
    // 想服务器传电话号码和验证码 先是手机和账号绑定
    [[NetworkTool sharedNetworkTool] bindMobileWithToken:[UserInfo sharedUserInfo].token Uid:[UserInfo sharedUserInfo].userID Code:self.inputTF.text PhoneNumber:self.phoneNumTextField.text Completion:^(BOOL isSuccess, id respones) {
        
        if (isSuccess) {
//            [PublicTool showHUDWithViewController:self Text:@"绑定成功"];
            [PublicTool showAlertToViewController:self alertControllerTitle:@"提示" alertControllerMessage:@"确认是否开启安全令牌" alertCancelTitle:@"否" alertReportTitle:@"是" cancelHandler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            } reportHandler:^(UIAlertAction * _Nonnull action) {
                [self isSureToBindWithPhoneNumber:self.self.phoneNumTextField.text];
            } completion:^{
                SYLog(@"完成alert");
            }];
        }else{
            [PublicTool showHUDWithViewController:self Text:respones[@"msg"]];
        }
    } Failure:^(id error) {
        [PublicTool showHUDWithViewController:self Text:@"网络异常"];
    }];
}

- (void)isSureToBindWithPhoneNumber:(NSString *)phoneNumber{
    // 账号与序列号绑定
    [[NetworkTool sharedNetworkTool] checkSmsWithPhone:phoneNumber Code:self.inputTF.text Completion:^(BOOL isSuccess, id respones) {
        
        if (isSuccess) {
            [self getOTPInfo];//跳转vc
            
        }else{
            [PublicTool showHUDWithViewController:self Text:respones[@"msg"]];
            
        }
    } Failure:^(id error) {
        [PublicTool showHUDWithViewController:self Text:@"网络异常"];
    }];
}


- (void)getOTPInfo{
    SYLog(@"测试成功");
//    return;
    Weak_Self;
    ViewController *vc = [[ViewController alloc] init];
    
    // 获取动态口令
    [[NetworkTool sharedNetworkTool] getOTPSecretWithSn:[UserInfo sharedUserInfo].postUUID uid:[UserInfo sharedUserInfo].userID completion:^(BOOL isSuccess, id respones) {
        if (isSuccess) {
            [PublicTool showHUDWithViewController:self Text:@"绑定成功"];

            [UserInfo sharedUserInfo].secretCode = respones[@"data"][@"secret"];
            [PublicTool fastLoginWithSecretCode:[UserInfo sharedUserInfo].secretCode];
            vc.bindPush = YES;
            vc.textStr = [weakSelf addOTPWithTimeLag];
            NSMutableDictionary *saveSecretDic = [NSMutableDictionary new];
            NSMutableDictionary *dic = [KeyChainWrapper load:SY_Secret_Key];
            if (dic.count > 0) {
                [dic setObject:[UserInfo sharedUserInfo] forKey:[UserInfo sharedUserInfo].userName];
                [KeyChainWrapper save:SY_Secret_Key data:saveSecretDic];
            }else{
                [saveSecretDic setObject:[UserInfo sharedUserInfo].secretCode forKey:[UserInfo sharedUserInfo].userName];
                [KeyChainWrapper save:SY_Secret_Key data:saveSecretDic];
            }
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }else{
            [PublicTool showHUDWithViewController:self Text:respones[@"msg"]];
        }
        
    } failure:^(id error) {
        [PublicTool showHUDWithViewController:self Text:@"网络异常"];
    }];
}


/*
 * 获取验证码
 */
- (void)getClick:(id)sender{
    Weak_Self;
    BOOL isTel = NO;
    if (self.proveType == NotBindPhone) {
        isTel = [PublicTool isValidateTel:self.phoneNumTextField.text];
    }else{
        isTel = YES;
    }
    if (isTel) {
        SYLog(@"获取验证码");
//        NSString *phoneNum = [NSString string];
        if (self.phoneNumberStr.length > 1) {
            self.verificationPhoneStr = self.phoneNumberStr;
        }else{
            self.verificationPhoneStr = self.phoneNumTextField.text;
        }
//        [self currentTime];

        [[NetworkTool sharedNetworkTool] bindPhoneSmsWithPhoneNumber:self.verificationPhoneStr Completion:^(BOOL isSuccess, id respones) {
            if (isSuccess) {
                SYLog(@"-------respones:%@", respones);
                [weakSelf currentTime];
            }else{
                SYLog(@"-------respones:%@", respones);
                //882136
                [PublicTool showHUDWithViewController:self Text:respones[@"msg"]];

                
            }
        }Failure:^(id error) {
            
        }];
        
    }else{
        [PublicTool showHUDWithViewController:self Text:@"请填写正确的手机号码"];
    }
}

/*设置验证码*/
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.phoneNumTextField || textField == self.inputTF) {
        if (textField.isFirstResponder) {
            [textField resignFirstResponder];
        }
    }
    return YES;
}


# pragma mark --------------------------------------------------------------- 输入框输入的文字限制
/*输入框输入的文字限制*/

-(void)textFieldEditChanged:(NSNotification *)obj{
    
    
    NSString *regex = @"^([0-9]+)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isEmpty = [PublicTool isEmpty:self.phoneNumTextField.text];
    if ((self.phoneNumTextField.text.length > 0) || (self.inputTF.text.length > 0)) {
        if ([self.phoneNumTextField isFirstResponder]) {
            if(![pred evaluateWithObject:self.phoneNumTextField.text] || isEmpty) {
                
                [PublicTool showHUDWithViewController:self Text:@"请按正确格式输入手机号码"];
                self.phoneNumTextField.text = @"";
                [self.phoneNumTextField resignFirstResponder];
                return;
            }
            
        }
        
        
        if ([self.inputTF isFirstResponder]) {
            if (![pred evaluateWithObject:self.inputTF.text] || isEmpty) {
                [PublicTool showHUDWithViewController:self Text:@"请按正确格式输入验证码"];
                
                self.inputTF.text = @"";
                [self.inputTF resignFirstResponder];
                return;
                
            }
        }
        
    }
    
    
    UITextField *textField = (UITextField *)obj.object;
    if (textField == self.phoneNumTextField) {
        [self limitTextLengthFor:textField length:11];
    }
    if (textField == self.inputTF) {
        [self limitTextLengthFor:textField length:10];
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

#pragma mark ------------------------------------------------Lazy & Init


- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 64)];
        _topView.backgroundColor = [UIColor colorWithRed:0.2 green:0.54 blue:0.93 alpha:1];
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        CGPoint titlePoint = CGPointMake(_topView.centerX, _topView.centerY + 10);
        titleLab.center = titlePoint;
        titleLab.textAlignment = 1;
        titleLab.textColor = [UIColor whiteColor];
        titleLab.text = @"绑定令牌";
        [_topView addSubview:titleLab];
        /*
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:SYImage(@"tb_bl") forState:UIControlStateNormal];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backGesture:) forControlEvents:UIControlEventTouchUpInside];
        backBtn.frame = CGRectMake(10, 0, 30, 20);
        backBtn.centerY = _topView.centerY + 10;
        [_topView addSubview:backBtn];
        */
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 120, 30)];
        backView.backgroundColor = SYNOColor;
        backView.centerY = _topView.centerY + 10;
        [_topView addSubview:backView];
        UIImageView *backImage = [[UIImageView alloc] initWithImage:SYImage(@"tb_bl")];
        backImage.frame = CGRectMake(0, 0, 10, 15);
        backImage.centerY = backView.height / 2;
        [backView addSubview:backImage];
        
        UILabel *backLab = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 80, 20)];
        backLab.centerY = backView.height / 2;
        backLab.textAlignment = 1;
        backLab.textColor = [UIColor whiteColor];
        backLab.text = @"用户中心";
        [backView addSubview:backLab];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGesture:)];
        [backView addGestureRecognizer:tap];
    }
    return _topView;
}

- (UILabel *)phoneLab{
    if (!_phoneLab) {
        _phoneLab = [[UILabel alloc] init];
        _phoneLab.text = @"填写验证码后点击获取验证码";
        _phoneLab.textAlignment = 1;
        _phoneLab.font = [UIFont systemFontOfSize:18];
    }
    return _phoneLab;
}


- (UILabel *)tipsLab{
    if (!_tipsLab) {
        _tipsLab = [[UILabel alloc] init];
        _tipsLab.textAlignment = 0;
        _tipsLab.font = [UIFont systemFontOfSize:18];
        _tipsLab.numberOfLines = 0;
        _tipsLab.text = @"  您好,请先阅读注意事项后,验证手机并开通安全令牌";
    }
    return _tipsLab;
}


- (UITextField *)phoneNumTextField{
    if (!_phoneNumTextField) {
        _phoneNumTextField = [[UITextField alloc] init];
        _phoneNumTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _phoneNumTextField.placeholder =  @"请输入手机号";
        _phoneNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNumTextField.font = [UIFont systemFontOfSize:14];
        _phoneNumTextField.keyboardType = UIKeyboardTypeNamePhonePad;
        _phoneNumTextField.delegate = self;
        _phoneNumTextField.borderStyle = UITextBorderStyleNone;
        _phoneNumTextField.returnKeyType = UIReturnKeyDone;
        _phoneNumTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        
    }
    return _phoneNumTextField;
}

- (UITextField *)inputTF{
    if (!_inputTF) {
        _inputTF = [[UITextField alloc] init];
        _inputTF.translatesAutoresizingMaskIntoConstraints = NO;
        _inputTF.placeholder =  @"请输入验证码";
        _inputTF.borderStyle = UITextBorderStyleNone;
        _inputTF.font = [UIFont systemFontOfSize:14];
        _inputTF.keyboardType = UIKeyboardTypeNamePhonePad;
        _inputTF.delegate = self;
        _inputTF.returnKeyType = UIReturnKeyDone;
        _inputTF.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    return _inputTF;
}

- (UIView *)phoneBorderView{
    
    if (!_phoneBorderView) {
        _phoneBorderView = [[UIView alloc] init];
        _phoneBorderView.layer.borderColor = [UIColor colorWithRed:0.72 green:0.73 blue:0.73 alpha:1].CGColor;
        _phoneBorderView.layer.borderWidth = 2;
        _phoneBorderView.layer.masksToBounds = YES;
        _phoneBorderView.layer.cornerRadius = 10;
        
    }
    
    return _phoneBorderView;
}


- (UIView *)codeBorderView{
    if (!_codeBorderView) {
        _codeBorderView = [[UIView alloc] init];
        _codeBorderView.layer.borderColor = [UIColor colorWithRed:0.72 green:0.73 blue:0.73 alpha:1].CGColor;
        _codeBorderView.layer.borderWidth = 2;
        _codeBorderView.layer.masksToBounds = YES;
        _codeBorderView.layer.cornerRadius = 10;
        
    }
    
    return _codeBorderView;
}

- (UIButton *)getCodeBtn{
    if (!_getCodeBtn) {
        _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      
        _getCodeBtn.backgroundColor = [UIColor whiteColor];
        _getCodeBtn.layer.borderColor = [UIColor colorWithRed:0.18 green:0.55 blue:0.91 alpha:1.00].CGColor;
        _getCodeBtn.layer.borderWidth = 1;
        _getCodeBtn.layer.cornerRadius = 6;
        _getCodeBtn.layer.masksToBounds = YES;
        [_getCodeBtn setTitleColor:[UIColor colorWithRed:0.18 green:0.55 blue:0.91 alpha:1.00] forState:UIControlStateNormal];
        _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        //        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateHighlighted];
        if (self.isRead) {
            _getCodeBtn.enabled = YES;
        }else{
            _getCodeBtn.enabled = NO;

        }
        [_getCodeBtn addTarget:self action:@selector(getClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _getCodeBtn;
}

- (UIButton *)bindBtn{
    if (!_bindBtn) {
        _bindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bindBtn setBackgroundImage:SYImage(@"按钮") forState:UIControlStateNormal];
        [_bindBtn setTitle:@"绑定安全令牌" forState:UIControlStateNormal];
        [_bindBtn addTarget:self action:@selector(bindClick) forControlEvents:UIControlEventTouchUpInside];
        _bindBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        if (self.isRead) {
            _bindBtn.enabled = YES;
        }else{
            _bindBtn.enabled = NO;
            
        }
    }
    return _bindBtn;
}

- (UIButton *)readBtn{
    if (!_readBtn) {
        _readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_readBtn setBackgroundImage:SYImage(@"an05") forState:UIControlStateNormal];
        [_readBtn setBackgroundImage:SYImage(@"an06") forState:UIControlStateHighlighted];
        [_readBtn setTitle:@"阅读注意事项" forState:UIControlStateNormal];
        [_readBtn setTitle:@"阅读注意事项" forState:UIControlStateHighlighted];
        [_readBtn addTarget:self action:@selector(readClick) forControlEvents:UIControlEventTouchUpInside];
        _readBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _readBtn;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
