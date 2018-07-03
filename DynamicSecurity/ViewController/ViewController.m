//
//  ViewController.m
//  DynamicSecurity
//
//  Created by songyan on 2017/10/30.
//  Copyright © 2017年 songyan. All rights reserved.
//

#import "ViewController.h"
#import "ZZCircleProgress.h"
#import "ZZCACircleProgress.h"
#import "OTPAuthBarClock.h"
#import "UserTableViewCell.h"
#import "CustomerServiceViewController.h"
#import "LookForSNViewController.h"
#import "AddUserViewController.h"
#import "IntoAppPasswordViewController.h"
#import "SetPasswordViewController.h"

@interface ViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
//    ZZCACircleProgress *cirPro;//progress
    ZZCircleProgress *cirPro;
    NSTimeInterval period;
}

@property (nonatomic, strong) NSTimer *timer;


@property (nonatomic, strong)dispatch_source_t time;//定时器

@property (nonatomic, assign) float currentTime;//记录时间60s

@property (nonatomic, assign) NSInteger timeInterval;//时间戳

@property(nonatomic, strong) OTPAuthBarClock *clock;

@property (nonatomic ,strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *passwordLab;

@property (strong, nonatomic) OTPAuthURL *authURL;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *diamondImageView;

@property (nonatomic ,strong) UIView *topView;

@property (nonatomic ,strong) UIView *bottomView;

@property (nonatomic ,strong) UIButton *otpBtn;

@property (nonatomic ,strong) UIButton *qrCodeBtn;

@property (nonatomic ,strong) UIButton *proveCenterBtn;

@property (nonatomic ,strong) UIButton *userCenterBtn;

@property (nonatomic, strong) UIButton *addUserBtn;

@property (nonatomic, strong) UIButton *saveOTPCodeBtn;

@property (nonatomic, strong) UIView *proveView;

@property (nonatomic, strong) UIView *userView;

@property (nonatomic, strong) UIView *userTopView;

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic ,strong) NSMutableArray *autherArr;

@end



@implementation ViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OTPAuthURLDidGenerateNewOTPNotification object:nil];

}
/**
 * 系统方法
 * 是否隐藏
 - (BOOL)prefersStatusBarHidden {
 return YES;
 }
 */


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!self.bindPush) {
        [self addOTPWithTimeLag]; // 如果不是从绑定也跳转 获取动态码
    }
    self.navigationItem.hidesBackButton = YES;

}

/*
 
 // 当页面加载完成后, 销毁登录密码页面
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isAppDidFinishLaunching) {
        if (self.WindowNeedDisappearBlock) {
            self.WindowNeedDisappearBlock(YES);
        }
    }
}
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = SYWhiteColor;
    self.title = @"动态密码";

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:SYNavColor}];
    self.navigationController.navigationBar.barTintColor = SYWhiteColor;

    self.view.backgroundColor = [UIColor whiteColor];
    self.autherArr = [NSMutableArray array];
    
    _currentTime = 0.0;
    period = 60;//60s
    [self.tableView registerClass:[UserTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self initSubView];
    
    UIApplication *app = [UIApplication sharedApplication];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(applicationDidBecomeActive:)
               name:UIApplicationDidBecomeActiveNotification
             object:app];
    [nc addObserver:self
           selector:@selector(applicationWillResignActive:)
               name:UIApplicationWillResignActiveNotification
             object:app];
//    NSNotificationCenter *notif = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(otpAuthURLDidGenerateNewOTP:)
               name:OTPAuthURLDidGenerateNewOTPNotification
             object:_authURL];
   
}



- (void)initSubView{
    [self.view addSubview:self.scrollView];
    
    self.proveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.scrollView.height)];
    self.proveView.backgroundColor = SYNOColor;
    [self.scrollView addSubview:self.proveView];
    
    self.userView = [[UIView alloc] initWithFrame:CGRectMake(Screen_Width, 0, Screen_Width, self.scrollView.height)];
    self.userView.backgroundColor = SYNOColor;
    [self.scrollView addSubview:self.userView];
    
    [self.view addSubview:self.bottomView];
    
    [self.proveView addSubview:self.bgImageView];
    //[self.proveView addSubview:self.diamondImageView];
    cirPro = [[ZZCircleProgress alloc] initWithFrame:CGRectMake(0, 0, 150, 150) pathBackColor:[UIColor whiteColor] pathFillColor:SYProgressBGColor startAngle:-90 strokeWidth:7];
    cirPro.showProgressText = NO;
    cirPro.increaseFromLast = YES;
    [self.proveView addSubview:cirPro];
    
    self.passwordLab.text = [self addOTPWithTimeLag];
    [self.proveView addSubview:self.passwordLab];
    //[self.proveView addSubview:self.topView];
    
    [self.proveView addSubview:self.addUserBtn];
    [self.proveView addSubview:self.saveOTPCodeBtn];

    
   // [self.userView addSubview:self.userTopView];
    [self.userView addSubview:self.tableView];
    if (!self.dataArray) {
        self.dataArray = [[NSMutableArray alloc] init];
    }
    [self readDataForTableView];
    
    [self layoutSubViews];
    
    [self currentTheTime];
}


- (void)layoutSubViews{
    Weak_Self;
    CGFloat itemWidth = 200;
//    float diamondSize = 250;
    
    
    //第一页
    /*
    [self.diamondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.proveView).offset(100);
        //        make.left.equalTo(weakSelf.view).offset(50);
        make.centerX.equalTo(weakSelf.proveView);
        make.size.mas_equalTo(CGSizeMake(diamondSize, diamondSize-33));
    }];
     */
    
    [cirPro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.proveView).offset(30);
        //        make.left.equalTo(weakSelf.view).offset(50);
        make.centerX.equalTo(weakSelf.proveView);
        //make.center.equalTo(weakSelf.diamondImageView);
        make.size.mas_equalTo(CGSizeMake(itemWidth, itemWidth));
    }];
    [self.passwordLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(cirPro);
    }];
  
    [self.saveOTPCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(cirPro.mas_bottom).offset(20);
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(200, 42));
    }];
    
    [self.addUserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.saveOTPCodeBtn.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(200, 42));
    }];
    
    
    /*第二页*/
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.userView);
        make.left.and.right.and.bottom.equalTo(weakSelf.userView);
    }];
    
    
   

    
}

- (void)readDataForTableView{
    // cell 的数据
    self.dataArray = [UserCenterModel getDateFromModel];
}

#pragma mark ------------------------------------------------Click & Method


- (void)otpClick{
    SYLog(@"动态密码");
    if (self.otpBtn.selected == NO) {
        self.otpBtn.selected = YES;
        self.qrCodeBtn.selected = NO;
    }
}

- (void)qrClick{
    SYLog(@"扫码验证");
    if (self.qrCodeBtn.selected == NO) {
        self.qrCodeBtn.selected = YES;
        self.otpBtn.selected = NO;
    }
    [PublicTool showAlertToViewController:self alertControllerTitle:nil alertControllerMessage:@"暂未开放,敬请期待" alertCancelTitle:@"好的" alertReportTitle:nil cancelHandler:^(UIAlertAction * _Nonnull action) {
        self.qrCodeBtn.selected = NO;
        self.otpBtn.selected = YES;
    } reportHandler:nil completion:^{
        
    }];
}

- (void)addClick{
    SYLog(@"---添加/切换账户");
    Weak_Self;
    AddUserViewController *addVC = [[AddUserViewController alloc] init];
    addVC.addBlock = ^(AddModel *addModel) {
        // 切换账号后 用secret获取动态码
        [UserInfo sharedUserInfo].secretCode = addModel.userSecret;
        [PublicTool fastLoginWithSecretCode:[UserInfo sharedUserInfo].secretCode];
        [weakSelf addOTPWithTimeLag];
    };
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)saveOTPClick{
    // 复制
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.passwordLab.text;
    if ([pasteboard.string isEqualToString:self.passwordLab.text]) {
        [PublicTool showHUDWithViewController:self Text:@"复制成功"];
    }
    SYLog(@"-----复制动态口令:%@", pasteboard.string);
}

- (void)proveCClick{
    SYLog(@"验证中心");
    if (self.proveCenterBtn.selected == NO) {
        self.proveCenterBtn.selected = YES;
        self.userCenterBtn.selected = NO;
    }
    
    if (self.proveCenterBtn.selected == YES) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:SYNavColor}];
        self.title = @"动态密码";

        self.navigationController.navigationBar.barTintColor = SYWhiteColor;
        [UIView animateWithDuration:0.2 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }];
        
    }
}

- (void)userCClick{
    SYLog(@"用户中心");
    if (self.userCenterBtn.selected == NO) {
        self.userCenterBtn.selected = YES;
        self.proveCenterBtn.selected = NO;
    }
    
    if (self.userCenterBtn.selected == YES) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:SYWhiteColor}];
        self.title = @"用户中心";
        self.navigationController.navigationBar.barTintColor = SYNavColor;
        [UIView animateWithDuration:0.2 animations:^{
            self.scrollView.contentOffset = CGPointMake(Screen_Width, 0);
        }];
        
    }
}

- (void)updateUIForAuthURL:(OTPAuthURL *)authURL {
//    self.frontNameTextField.text = authURL.name;
//    NSString *otpCode = authURL.otpCode;
    
    
}

- (void)otpAuthURLDidGenerateNewOTP:(NSNotification *)notification {

    // 接收通知, 改变动态码
    self.authURL = notification.object;
    self.passwordLab.text = self.authURL.otpCode;
    
    
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
        self.passwordLab.text = checkCode;//59971
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


-(void)currentTheTime{
    //获得队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //创建一个定时器
    self.time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC));
    //设置时间间隔
    uint64_t interval = (uint64_t)(0.005* NSEC_PER_SEC);
    //设置定时器
    dispatch_source_set_timer(self.time, start, interval, 0);
    //设置回调
    
    dispatch_source_set_event_handler(self.time, ^{
        _currentTime++;
//        NSLog(@"%f", _currentTime);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSTimeInterval seconds = [[NSDate date] timeIntervalSince1970];
            CGFloat mod =  fmod(seconds, period);
            CGFloat percent = mod / period;
//            NSLog(@"------------%f", percent);
            cirPro.progress = percent;
            
 
        });
        
        
    });
    
    
    //由于定时器默认是暂停的所以我们启动一下
    //启动定时器
    dispatch_resume(self.time);
}


// 弃用
- (NSInteger)getTimeInterval{
    
    self.timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSLog(@"------------当前时间戳:%ld", (long)self.timeInterval);
    
    NSString *str = [NSString stringWithFormat:@"%ld", (long)self.timeInterval];//时间戳
    NSTimeInterval time = [str doubleValue] * 1000; // + 28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    //    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    NSLog(@"时间:%@", currentDateStr);
    return self.timeInterval;
    
}

- (void)invalidate {
    
}

- (void)startUpTimer {
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
//                                                  target:self
//                                                selector:@selector(redrawTimer:)
//                                                userInfo:nil
//                                                 repeats:YES];
}


// 回来应用
- (void)applicationDidBecomeActive:(UIApplication *)application {
    SYLog(@"回来主进程");
    /**
     * 回到应用 重新开始记录事件
     * 更新动态码
     */
    [self currentTheTime];
    [self addOTPWithTimeLag];

}

// 进入后台
- (void)applicationWillResignActive:(UIApplication *)application {
    // 进入后台, 讲定时器关闭
    if (self.time) {
        dispatch_source_cancel(self.time);
        self.time = nil;
        SYLog(@"进入后台");
    }

}

/*
- (void)redrawTimer:(NSTimer *)timer {
    [self.view setNeedsDisplay];
    _currentTime++;

//    cirPro.progress = (_currentTime/30.0);
    
    if (_currentTime >= 30) {
        _currentTime = 0;
        if (_currentTime == 0){
//            [cirPro.progressLayer removeAllAnimations];
        }
//        [cirPro setProgressLabelTextForTimeInterval];
//        cirPro.pathFillColor = SongYRGB(arc4random()%255, arc4random()%255, arc4random()%255);
    }

}
 */

#pragma mark ------------------------------------------------TableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"Cell";
    UserTableViewCell *cell = (UserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    UserCenterModel *model = [UserCenterModel new];
    model = self.dataArray[indexPath.row];
    cell.model = model;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    if (indexPath.row < self.dataArray.count - 1) {
        cell.lineView.hidden = NO;
    }else{
        cell.lineView.hidden = YES;
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            SYLog(@"联系客服");
            CustomerServiceViewController *csVC = [[CustomerServiceViewController alloc] init];
            [self.navigationController pushViewController:csVC animated:YES];
        }
            break;
            
        case 1:
        {
            SYLog(@"解除绑定");
            [PublicTool showAlertToViewController:self alertControllerTitle:@"提示" alertControllerMessage:@"解除“安全令牌”请联系在线客服处理" alertCancelTitle:@"知道了" alertReportTitle:nil cancelHandler:^(UIAlertAction * _Nonnull action) {
                SYLog(@"6666");
            } reportHandler:nil completion:nil];
        }
            break;
            
        case 2:
        {
            SYLog(@"查看序列号");
            LookForSNViewController *lookVC = [[LookForSNViewController alloc] init];
            [self.navigationController pushViewController:lookVC animated:YES];
        }
            break;
            
        case 3:
        {
            Weak_Self;
            SYLog(@"设置密码");
            // 强制绑定密码
            //IntoAppPasswordViewController *intoVC = [[IntoAppPasswordViewController alloc] init];
            //[self.navigationController pushViewController:intoVC animated:YES];
            SetPasswordViewController *setVC = [[SetPasswordViewController alloc] init];
            setVC.isPush = YES;
            setVC.pages = 3;
            setVC.SetPassStatusBlock = ^(NSString *status) {
                [PublicTool showHUDWithViewController:weakSelf Text:status];
            };
            [self.navigationController pushViewController:setVC animated:YES];
        }
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .5f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footLine = [[UIView alloc] initWithFrame:CGRectMake(10, 0, Screen_Width, 0.5f)];
    footLine.backgroundColor = SYLineColor;
    return footLine;
}

#pragma mark ------------------------------------------------LazyInit & Init

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = SYWhiteColor;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (UIButton *)addUserBtn{
    if (!_addUserBtn) {
        _addUserBtn = [PublicTool createBtnWithButton:_addUserBtn buttonType:UIButtonTypeCustom frame:CGRectZero backgroundColor:nil image:nil normalTile:@"账号切换 / 添加绑定" selectedTitle:nil highlightTile:nil textAlignment:1 selected:NO titleNormalColor:[UIColor colorWithRed:0 green:0.46 blue:0.92 alpha:1] titleSelectedColor:nil titleHighlightedColor:nil];
        [_addUserBtn setBackgroundImage:SYImage(@"03") forState:UIControlStateNormal];
        [_addUserBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addUserBtn;
}

- (UIButton *)saveOTPCodeBtn{
    if (!_saveOTPCodeBtn) {
        _saveOTPCodeBtn = [PublicTool createBtnWithButton:_saveOTPCodeBtn buttonType:UIButtonTypeCustom frame:CGRectZero backgroundColor:nil image:nil normalTile:@"复制动态口令" selectedTitle:nil highlightTile:nil textAlignment:1 selected:NO titleNormalColor:[UIColor colorWithRed:0 green:0.46 blue:0.92 alpha:1] titleSelectedColor:nil titleHighlightedColor:nil];
        [_saveOTPCodeBtn setBackgroundImage:SYImage(@"03") forState:UIControlStateNormal];
        [_saveOTPCodeBtn addTarget:self action:@selector(saveOTPClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveOTPCodeBtn;
}

- (UIView *)userTopView{
    if (!_userTopView) {
        _userTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 64)];
        _userTopView.backgroundColor = [UIColor colorWithRed:0.2 green:0.54 blue:0.93 alpha:1];
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        CGPoint titlePoint = CGPointMake(_userTopView.centerX, _userTopView.centerY + 10);
        titleLab.center = titlePoint;
        titleLab.textAlignment = 1;
        titleLab.textColor = [UIColor whiteColor];
        titleLab.text = @"绑定令牌";
        [_userTopView addSubview:titleLab];
        
    }
    return _userTopView;
}


- (UILabel *)passwordLab{
    if (!_passwordLab) {
        _passwordLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 30)];
        _passwordLab.font = [UIFont systemFontOfSize:30];
        _passwordLab.textColor = SYWhiteColor;
        _passwordLab.textAlignment = 1;
        
    }
    return _passwordLab;
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[ UIImageView alloc] initWithFrame:self.scrollView.bounds];
        _bgImageView.image = SYImage(@"bg.jpg");
    }
    return _bgImageView;
}

- (UIImageView *)diamondImageView{
    if (!_diamondImageView) {
        _diamondImageView = [[UIImageView alloc] init];
        _diamondImageView.image = SYImage(@"01");
    }
    return _diamondImageView;
}


- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 64)];
        _topView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 21)];
        titleLab.center = _topView.center;
        titleLab.text = @"动态密码";
        titleLab.textColor = [UIColor colorWithRed:0 green:0.46 blue:0.92 alpha:1];
        titleLab.textAlignment = 1;
        [_topView addSubview:titleLab];
        
        
        //[self createTopButton];
       // [_topView addSubview:self.otpBtn];
        //[_topView addSubview:self.qrCodeBtn];
    }
    return _topView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height - 64, Screen_Width, 49)];
        _bottomView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 0.5)];
        lineView.backgroundColor = SYLineColor;
        [_bottomView addSubview:lineView];

        [self createBottomButton];
        [_bottomView addSubview:self.proveCenterBtn];
        [_bottomView addSubview:self.userCenterBtn];
    }
    return _bottomView;
}




- (void)createTopButton{
    
    
    self.otpBtn = [PublicTool createBtnWithButton:self.otpBtn buttonType:UIButtonTypeCustom frame:CGRectMake(0, 20, Screen_Width / 2, 44) backgroundColor:SYNOColor image:nil normalTile:@"动态密码" selectedTitle:nil highlightTile:nil textAlignment:1 selected:YES titleNormalColor:[UIColor colorWithRed:0.86 green:0.87 blue:0.87 alpha:1] titleSelectedColor:[UIColor colorWithRed:0 green:0.46 blue:0.92 alpha:1] titleHighlightedColor:[UIColor colorWithRed:0 green:0.46 blue:0.92 alpha:1]];
    
    [self.otpBtn addTarget:self action:@selector(otpClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.qrCodeBtn = [PublicTool createBtnWithButton:self.qrCodeBtn buttonType:UIButtonTypeCustom frame:CGRectMake(self.otpBtn.width, 20, (Screen_Width / 2), 44) backgroundColor:SYNOColor image:nil normalTile:@"扫码验证" selectedTitle:nil highlightTile:nil textAlignment:1 selected:NO titleNormalColor:[UIColor colorWithRed:0.86 green:0.87 blue:0.87 alpha:1] titleSelectedColor:[UIColor colorWithRed:0 green:0.46 blue:0.92 alpha:1] titleHighlightedColor:[UIColor colorWithRed:0 green:0.46 blue:0.92 alpha:1]];
    [self.qrCodeBtn addTarget:self action:@selector(qrClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)createBottomButton{
    self.proveCenterBtn = [PublicTool createBtnWithButton:self.proveCenterBtn buttonType:UIButtonTypeCustom frame:CGRectMake(0, 8, Screen_Width / 2, 60) backgroundColor:SYNOColor image:SYImage(@"验证中心2") normalTile:@"验证中心" selectedTitle:nil highlightTile:nil textAlignment:1 selected:YES titleNormalColor:[UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1]  titleSelectedColor:[UIColor colorWithRed:0 green:0.46 blue:0.92 alpha:1] titleHighlightedColor:[UIColor colorWithRed:0 green:0.46 blue:0.92 alpha:1]];
    [self.proveCenterBtn setImage:SYImage(@"验证中心1") forState:UIControlStateSelected];
    self.proveCenterBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.proveCenterBtn addTarget:self action:@selector(proveCClick) forControlEvents:UIControlEventTouchUpInside];
    [self initButton:self.proveCenterBtn];
    
    self.userCenterBtn = [PublicTool createBtnWithButton:self.userCenterBtn buttonType:UIButtonTypeCustom frame:CGRectMake(self.proveCenterBtn.width, 8, Screen_Width / 2, 60) backgroundColor:SYNOColor image:SYImage(@"用户中心1") normalTile:@"用户中心" selectedTitle:nil highlightTile:nil textAlignment:1 selected:NO titleNormalColor:[UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1] titleSelectedColor:[UIColor colorWithRed:0 green:0.46 blue:0.92 alpha:1] titleHighlightedColor:[UIColor colorWithRed:0 green:0.46 blue:0.92 alpha:1]];
    [self.userCenterBtn setImage:SYImage(@"用户中心2") forState:UIControlStateSelected];
    self.userCenterBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self.userCenterBtn addTarget:self action:@selector(userCClick) forControlEvents:UIControlEventTouchUpInside];
    [self initButton:self.userCenterBtn];
    
}

-(void)initButton:(UIButton*)btn{
    float btnimageW = btn.width - 35;
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height -15,-btn.imageView.frame.size.width, 15.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离变
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, btnimageW / 2, 25, btnimageW / 2)];//图片距离右边框距离减少图片的宽度，其它不边
   // btn.imageEdgeInsets = UIEdgeInsetsMake( 0, , 25, );
    
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height - 113)];
        _scrollView.contentSize = CGSizeMake(Screen_Width *2, Screen_Height -100);
        //_scrollView. = NO;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator =NO;
        _scrollView.showsVerticalScrollIndicator =NO;
        _scrollView.scrollEnabled = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
