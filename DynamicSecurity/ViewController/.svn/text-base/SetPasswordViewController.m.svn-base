//
//  SetPasswordViewController.m
//  DynamicSecurity
//
//  Created by SDK on 2017/11/15.
//  Copyright © 2017年 songyan. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "InputPasswrodView.h"
@interface SetPasswordViewController ()<UIScrollViewDelegate>

@property (nonatomic ,strong) UIScrollView *scrollView;

@property (nonatomic ,strong) UIView *navView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic ,strong) InputPasswrodView *inputOldPassView;

@property (nonatomic ,strong) InputPasswrodView *inputPassView;

@property (nonatomic ,strong) InputPasswrodView *reInputPassView;

@property (nonatomic, copy) NSString *setPassStr;



@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SYWhiteColor;
    self.title = @"修改密码";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[PublicTool creatBackBtnWithTarget:self Action:@selector(backClick)]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //[self.navigationItem.backBarButtonItem setTitle:@"返回"];
    
    [self setUpSubViews];
}

- (void)setUpSubViews{
   // [self.view addSubview:self.navView];
    [self.view addSubview:self.scrollView];
    
    // 根据页数来区别 设置密码和修改密码
    if (self.pages == 2) {
        [self setPassword];
    }else{
        
        [self changePassword];
        
    }
}

- (void)setPassword{
    Weak_Self;

    UILabel *inputTitle = [self setUpLabelWithFrame:CGRectMake(0, 30, Screen_Width, 21) textColor:[UIColor grayColor] textAlignment:1 font:16 text:@"输入新密码"];
    [self.scrollView addSubview:inputTitle];
    
    
    UILabel *reInputTitle = [self setUpLabelWithFrame:CGRectMake(Screen_Width, 30, Screen_Width, 21) textColor:[UIColor grayColor] textAlignment:1 font:16 text:@"再次输入新密码"];
    [self.scrollView addSubview:reInputTitle];
    

    /**
     * inputPassView 输入完成以后 scrollView.contentOffset 跳转到第二页
     * reInputPassView 再次输入 , 与第一次匹配 设置成功
     */
    
    self.inputPassView = [[InputPasswrodView alloc] initWithFrame:CGRectMake(40, 0, Screen_Width - 80, 45) inputType:0];
    CGPoint centerP = CGPointMake(self.view.centerX, self.view.centerY - 50);
    self.inputPassView.center = centerP;
    self.inputPassView.SetBlock = ^(NSString *password) {
        weakSelf.setPassStr = password;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.scrollView.contentOffset = CGPointMake(Screen_Width, 0);
            [weakSelf.inputPassView.verifyTextField resignFirstResponder];

        } completion:^(BOOL finished) {
            [weakSelf.inputPassView clearUpPassword];// 清除textfield.text
            [weakSelf.reInputPassView.verifyTextField becomeFirstResponder];

        }];
    };
    [self.scrollView addSubview:self.inputPassView];

    self.reInputPassView = [[InputPasswrodView alloc] initWithFrame:CGRectMake(40 + Screen_Width, 0, Screen_Width - 80, 45) inputType:0];
    CGPoint centerReP = CGPointMake(self.view.centerX + Screen_Width, self.view.centerY - 50);

    self.reInputPassView.center = centerReP;
    self.reInputPassView.SetBlock = ^(NSString *password) {
        if ([password isEqualToString:weakSelf.setPassStr]) {
            [PublicTool setIntoAppForPassword:weakSelf.setPassStr];
            if (weakSelf.SetPassStatusBlock) {
                weakSelf.SetPassStatusBlock(@"密码设置成功");
            }
            
            if (weakSelf.isPush) {
                [weakSelf.navigationController popViewControllerAnimated:YES];

            }else{
                [UserInfo sharedUserInfo].isSetPassword = YES;

                [weakSelf dismissViewControllerAnimated:YES completion:^{
                }];
            }
        }else{
            [PublicTool showHUDWithViewController:weakSelf Text:@"两次密码不同,请重新输入"];
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.scrollView.contentOffset = CGPointMake(0, 0);
                [weakSelf.reInputPassView.verifyTextField resignFirstResponder];

            } completion:^(BOOL finished) {
                [weakSelf.reInputPassView clearUpPassword];
                [weakSelf.inputPassView.verifyTextField becomeFirstResponder];

            }];
            
        }
    };
    [self.scrollView addSubview:self.reInputPassView];
    
}

// 修改密码
- (void)changePassword{
    Weak_Self;
    
    UILabel *inputOldTitle = [self setUpLabelWithFrame:CGRectMake(0, 30, Screen_Width, 21) textColor:[UIColor grayColor] textAlignment:1 font:16 text:@"输入旧密码"];
    [self.scrollView addSubview:inputOldTitle];
    
    UILabel *inputTitle = [self setUpLabelWithFrame:CGRectMake(Screen_Width, 30, Screen_Width, 21) textColor:[UIColor grayColor] textAlignment:1 font:16 text:@"输入新密码"];
    [self.scrollView addSubview:inputTitle];
    
    
    UILabel *reInputTitle = [self setUpLabelWithFrame:CGRectMake(Screen_Width*2, 30, Screen_Width, 21) textColor:[UIColor grayColor] textAlignment:1 font:16 text:@"再次输入新密码"];
    [self.scrollView addSubview:reInputTitle];
    
    
    /**
     * 第一次输入与本地储存的密码匹配,
     * 一致, 进入第二页 与 第三页  进行新密码的设置和匹配
     * 不一致, 不进入新密码设置和匹配
     */
    
    self.inputOldPassView = [[InputPasswrodView alloc] initWithFrame:CGRectMake(40, 0, Screen_Width - 80, 45) inputType:1];
    CGPoint centerOP = CGPointMake(self.view.centerX, self.view.centerY - 50);
    self.inputOldPassView.center = centerOP;
    self.inputOldPassView.SetBlock = ^(NSString *password) {
        if ([password isEqualToString:[PublicTool loadPasswordForIntoApp]]) {
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.scrollView.contentOffset = CGPointMake(Screen_Width, 0);
                [weakSelf.inputOldPassView.verifyTextField resignFirstResponder];
            } completion:^(BOOL finished) {
                [weakSelf.inputPassView.verifyTextField becomeFirstResponder];
                [weakSelf.inputOldPassView clearUpPassword];
            }];
        }else{
            [PublicTool showHUDWithViewController:weakSelf Text:@"密码错误"];
            [weakSelf.inputOldPassView.verifyTextField resignFirstResponder];
            [weakSelf.inputOldPassView clearUpPassword];
        }
    };
    [self.scrollView addSubview:self.inputOldPassView];
    
    
    self.inputPassView = [[InputPasswrodView alloc] initWithFrame:CGRectMake(40 + Screen_Width, 0, Screen_Width - 80, 45) inputType:1];
    CGPoint centerP = CGPointMake(self.view.centerX + Screen_Width, self.view.centerY - 50);
    self.inputPassView.center = centerP;
    self.inputPassView.SetBlock = ^(NSString *password) {
        weakSelf.setPassStr = password;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.scrollView.contentOffset = CGPointMake(Screen_Width*2, 0);
            [weakSelf.inputPassView.verifyTextField resignFirstResponder];
            
        } completion:^(BOOL finished) {
            [weakSelf.inputPassView clearUpPassword];
            [weakSelf.reInputPassView.verifyTextField becomeFirstResponder];
        }];
        
    };
    [self.scrollView addSubview:self.inputPassView];
    
    self.reInputPassView = [[InputPasswrodView alloc] initWithFrame:CGRectMake(40 + (Screen_Width*2), 0, Screen_Width - 80, 45) inputType:0];
    CGPoint centerReP = CGPointMake(self.view.centerX + (Screen_Width*2), self.view.centerY - 50);
    
    self.reInputPassView.center = centerReP;
    self.reInputPassView.SetBlock = ^(NSString *password) {
        if ([password isEqualToString:weakSelf.setPassStr]) {
            [PublicTool setIntoAppForPassword:weakSelf.setPassStr];
            if (weakSelf.SetPassStatusBlock) {
                weakSelf.SetPassStatusBlock(@"密码设置成功");
            }
            if (weakSelf.isPush) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
  
            }else{
                [UserInfo sharedUserInfo].isSetPassword = YES;

                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }
        }else{
            [PublicTool showHUDWithViewController:weakSelf Text:@"两次密码不同,请重新输入"];
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.scrollView.contentOffset = CGPointMake(Screen_Width, 0);
                [weakSelf.reInputPassView.verifyTextField resignFirstResponder];
                
            } completion:^(BOOL finished) {
                [weakSelf.reInputPassView clearUpPassword];
                [weakSelf.inputPassView.verifyTextField becomeFirstResponder];
                
            }];
            
        }
    };
    [self.scrollView addSubview:self.reInputPassView];

}



- (UILabel *)setUpLabelWithFrame:(CGRect)frame textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment font:(CGFloat)fontSize text:(NSString *)text{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.numberOfLines = 0;
    label.text = text;
    return label;
}


- (void)backClick{
    SYLog(@"back");
    [self.view endEditing:YES];
    [PublicTool showAlertToViewController:self alertControllerTitle:nil alertControllerMessage:@"您是否放弃设置密码" alertCancelTitle:@"取消" alertReportTitle:@"是的" cancelHandler:^(UIAlertAction * _Nonnull action) {
        
    } reportHandler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];

        

    } completion:^{
        
    }];
}


- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height - 64)];
        _scrollView.contentSize = CGSizeMake(Screen_Width * self.pages, Screen_Height - 64);
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator =NO;
        _scrollView.showsVerticalScrollIndicator =NO;
        _scrollView.scrollEnabled = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}


- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 64)];
        _navView.backgroundColor = [UIColor colorWithRed:0.31 green:0.53 blue:0.91 alpha:1.00];
        self.backBtn  = [PublicTool createBtnWithButton:self.backBtn buttonType:UIButtonTypeCustom frame:CGRectMake(3, 17, 40, 30) backgroundColor:SYNOColor image:SYImage(@"min77_back_bt") normalTile:nil selectedTitle:nil highlightTile:nil textAlignment:1 selected:nil titleNormalColor:nil titleSelectedColor:nil titleHighlightedColor:nil];
        [self.backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        if (self.isPush) {
            [_navView addSubview:self.backBtn];

        }
        UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 20)];
        navTitle.centerY = _navView.centerY;
        navTitle.textAlignment = 1;
        navTitle.textColor = SYWhiteColor;
        navTitle.font = [UIFont systemFontOfSize:16];
        navTitle.text = @"设置登录密码";
        [_navView addSubview:navTitle];
    }
    
    return _navView;
    
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
