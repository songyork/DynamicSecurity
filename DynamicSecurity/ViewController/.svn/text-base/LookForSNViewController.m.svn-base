//
//  LookForSNViewController.m
//  DynamicSecurity
//
//  Created by SDK on 2017/11/6.
//  Copyright © 2017年 songyan. All rights reserved.
//

#import "LookForSNViewController.h"
#import <Photos/Photos.h>
@interface LookForSNViewController ()

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UILabel *snTitleLab;

@property (nonatomic, strong) UILabel *snDetailLab;

@property (nonatomic, strong) UITextView *tipsTextView;

@property (nonatomic, strong) UIButton *saveLabBtn;

@property (nonatomic, strong) UIButton *saveScreenBtn;

@end

@implementation LookForSNViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // self.navigationController.navigationBar.hidden = YES;

}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
   // self.navigationController.navigationBar.hidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SYWhiteColor;
    self.title = @"查看序列号";
    //initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backGesture:)
    
    
    

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[PublicTool creatBackBtnWithTarget:self Action:@selector(backClick)]];

    [self setUpSubViews];
}

- (void)creatBackBtn{
    UIView *backView = [[UIView alloc] init];
    
    UIImageView *backImage = [[UIImageView alloc] initWithImage:SYImage(@"tb_bl")];
    backImage.frame = CGRectMake(0, 0, 10, 15);
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(13, 0, 40, 15);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:SYWhiteColor forState:UIControlStateNormal];
    
    
    [backView addSubview:backImage];
    [backView addSubview:backBtn];
    backView.frame = CGRectMake(0, 0, 60, 15);
    
    
    
}

- (void)setUpSubViews{
    //[self.view addSubview:self.topView];
    [self.view addSubview:self.snTitleLab];
    [self.view addSubview:self.snDetailLab];
    [self.view addSubview:self.saveLabBtn];
    [self.view addSubview:self.tipsTextView];
    [self.view addSubview:self.saveScreenBtn];
    [self layoutSubviews];
}


- (void)layoutSubviews{
    Weak_Self;
    [self.snTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(15 + 64);
        make.left.equalTo(weakSelf.view).offset(10);
        make.height.mas_equalTo(25);
    }];
    [self.snDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.snTitleLab.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.snTitleLab);
        
        make.height.mas_equalTo(30);
    }];
    [self.saveLabBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.snDetailLab.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.snDetailLab);
        make.size.mas_equalTo(CGSizeMake(20, 25));
    }];
    CGSize textSize = [self.tipsTextView.text boundingRectWithSize:CGSizeMake(Screen_Width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.tipsTextView.font} context:nil].size;

    [self.tipsTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.snDetailLab.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.view).offset(10);
        make.right.equalTo(weakSelf.view).offset(-10);
        make.height.mas_equalTo(textSize.height + 80);
    }];
    
    [self.saveScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tipsTextView.mas_bottom).offset(30);
        make.left.equalTo(weakSelf.view).offset(30);
        make.right.equalTo(weakSelf.view).offset(-30);
        make.height.mas_equalTo(40);
    }];
}

- (UIImage *)captureScreenForView:(UIView *)currentView {
    UIGraphicsBeginImageContextWithOptions(currentView.bounds.size, NO, 0.0);
    
    [currentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  viewImage;
}


- (void)loadImageFinished:(UIImage *)image
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        //写入图片到相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        SYLog(@"%@", req);
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        SYLog(@"success = %d, error = %@", success, error);
        if (success) {
            [PublicTool showAlertToViewController:self alertControllerTitle:nil alertControllerMessage:@"屏幕截图已保存到相册,请妥善保管" alertCancelTitle:@"好的" alertReportTitle:nil cancelHandler:^(UIAlertAction * _Nonnull action) {
                
            } reportHandler:nil completion:^{
                
            }];
        }
        if (error) {
            [PublicTool showAlertToViewController:self alertControllerTitle:nil alertControllerMessage:@"上士安全令牌想访问您的相册,是否允许?" alertCancelTitle:@"取消" alertReportTitle:@"去设置" cancelHandler:^(UIAlertAction * _Nonnull action) {
                
            } reportHandler:^(UIAlertAction * _Nonnull action) {
                [self goToSetting];
            } completion:^{
                
            }];
        }
        
    }];
}

- (void)goToSetting{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}
- (void)saveScreenClick{
    SYLog(@"----截图");
//    [PublicTool showAlertToViewController:self alertControllerTitle:<#(NSString *)#> alertControllerMessage:<#(NSString *)#> alertControllerStyle:<#(UIAlertControllerStyle)#> alertCancelTitle:<#(NSString *)#> alertReportTitle:<#(NSString *)#> cancelHandler:<#^(UIAlertAction * _Nonnull action)cancelHandler#> reportHandler:<#^(UIAlertAction * _Nonnull action)reportHandler#> completion:???]
    UIImage *screenImage = [self captureScreenForView:self.view];
    
    if (screenImage) {
//        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 250)];
//        imgView.image = screenImage;
//        imgView.center = self.view.center;
//        [self.view addSubview:imgView];
        [self loadImageFinished:screenImage];
    }
}

- (void)saveLabClick{
     UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.snDetailLab.text;
    if ([pasteboard.string isEqualToString:self.snDetailLab.text]) {
        [PublicTool showHUDWithViewController:self Text:@"复制成功"];
    }
    SYLog(@"-----复制");
}

- (void)backClick{
    SYLog(@"-----返回");
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark ------------------------------------------------Lazy &Init

- (UITextView *)tipsTextView{
    if (!_tipsTextView) {
        _tipsTextView = [[UITextView alloc] init];
        _tipsTextView.editable = NO;
        _tipsTextView.selectable = NO;
        _tipsTextView.bounces = NO;
        _tipsTextView.scrollEnabled = NO;
        _tipsTextView.allowsEditingTextAttributes = NO;
        _tipsTextView.textAlignment = 0;
        _tipsTextView.textColor = [UIColor colorWithRed:0.51 green:0.51 blue:0.52 alpha:1.00];
        _tipsTextView.text = @"     “安全令牌”启用后账户会自动绑定序列号,我们建议您保存一份序列号的屏幕截图,并将其储存在手机相册中,以备将来提交重置序列号使用。\n   \n     还原手机设置导致重新安装应用后序列号改变，您需要提供之前所安装的序列号联系客服申请重置。";
        _tipsTextView.font = [UIFont systemFontOfSize:16];
        
        
          }
    return _tipsTextView;
}

- (UIButton *)saveScreenBtn{
    if (!_saveScreenBtn) {
        _saveScreenBtn = [PublicTool createBtnWithButton:_saveScreenBtn buttonType:UIButtonTypeCustom frame:CGRectZero backgroundColor:nil image:nil normalTile:@"保存屏幕截图" selectedTitle:nil highlightTile:nil textAlignment:1 selected:nil titleNormalColor:SYWhiteColor titleSelectedColor:nil titleHighlightedColor:nil];
        [_saveScreenBtn setBackgroundImage:SYImage(@"按钮") forState:UIControlStateNormal];
        [_saveScreenBtn addTarget:self action:@selector(saveScreenClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveScreenBtn;
}

- (UIButton *)saveLabBtn{
    if (!_saveLabBtn) {
        _saveLabBtn = [PublicTool createBtnWithButton:_saveLabBtn buttonType:UIButtonTypeCustom frame:CGRectZero backgroundColor:nil image:SYImage(@"复制按钮") normalTile:nil selectedTitle:nil highlightTile:nil textAlignment:0 selected:nil titleNormalColor:nil titleSelectedColor:nil titleHighlightedColor:nil];
        [_saveLabBtn addTarget:self action:@selector(saveLabClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveLabBtn;
}

- (UILabel *)snDetailLab{
    if (!_snDetailLab) {
        _snDetailLab = [[UILabel alloc] init];
        _snDetailLab.textAlignment = 0;
        _snDetailLab.text = [UserInfo sharedUserInfo].localUUID;
        _snDetailLab.textColor = [UIColor colorWithRed:0.22 green:0.48 blue:0.89 alpha:1.00];
        _snDetailLab.font = [UIFont systemFontOfSize:22];

    }
    return _snDetailLab;
}

- (UILabel *)snTitleLab{
    if (!_snTitleLab) {
        _snTitleLab = [[UILabel alloc] init];
        _snTitleLab.textAlignment = 0;
        _snTitleLab.text = @"序列号 :";
        _snTitleLab.font = [UIFont systemFontOfSize:20];
        
    }
    return _snTitleLab;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 64)];
        _topView.backgroundColor = SYNavColor;
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
        [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backGesture:) forControlEvents:UIControlEventTouchUpInside];
        backBtn.frame = CGRectMake(10, 0, , 15);
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
        backLab.textAlignment = 0;
        backLab.textColor = [UIColor whiteColor];
        backLab.text = @" 返回";
        [backView addSubview:backLab];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGesture:)];
        [backView addGestureRecognizer:tap];
        
    }
    return _topView;
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
