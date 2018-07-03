//
//  IntoAppPasswordViewController.m
//  DynamicSecurity
//
//  Created by SDK on 2017/11/15.
//  Copyright © 2017年 songyan. All rights reserved.
//

#import "IntoAppPasswordViewController.h"
#import "InputPasswrodView.h"
#import "SetPasswordViewController.h"

@interface IntoAppPasswordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UIView *navView;

@property (nonatomic ,strong) InputPasswrodView *inputPassView;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;


@end

@implementation IntoAppPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SYWhiteColor;
    [self setSubViews];
    [self loadDataForTabView];
}


- (void)loadDataForTabView{
    
    self.dataArray = @[@"打开密码", @"修改密码"];
    
    
}

- (void)setSubViews{
    
    
    [self.view addSubview:self.navView];
    
    [self.view addSubview:self.titleLab];
    
    
    CGSize titleSize = [self.titleLab.text boundingRectWithSize:CGSizeMake(Screen_Width - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.titleLab.font} context:nil].size;
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom).offset(25);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(Screen_Width - 60, titleSize.height + 10));
    }];

    
    //[self isSetPasswordBefor];
  //  BOOL iii = YES;
    if ([self isSetPasswordBefor]) {
        //有
        [self setInputView];
    }else{
        //无
        [self settingPasswrodView];

    }
    
}

- (void)setInputView{
    
    Weak_Self;
    
    self.titleLab.text = @"请输入密码";
    
    self.inputPassView = [[InputPasswrodView alloc] initWithFrame:CGRectMake(40, 0, Screen_Width - 80, 45) inputType:VerifyPassword];
    CGPoint centerP = CGPointMake(self.view.centerX, self.view.centerY - 50);
    self.inputPassView.center = centerP;
    self.inputPassView.PassBlock = ^(BOOL isMatch) {
        if (isMatch) {
            SYLog(@"答对了");
            [weakSelf settingPasswrodView];
            weakSelf.inputPassView = nil;
        }else{
            SYLog(@"打错了");
            [PublicTool showHUDWithViewController:weakSelf Text:@"密码错误"];
        }
    };
    [self.view addSubview:self.inputPassView];
    
    
}


- (void)settingPasswrodView{
    [self.view addSubview:self.tableView];
    
}

- (void)backClick{
    SYLog(@"back");
    [self.navigationController popViewControllerAnimated:YES];
}


/*判断是否有登录密码*/
- (BOOL)isSetPasswordBefor{
    NSString *password = [PublicTool loadPasswordForIntoApp];
    if (password.length > 1) {
        return YES;
    }
    return NO;
    
}









#pragma mark ------------------------------------------------TableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"Cell";
    // forIndexPath:indexPath
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; //（这种是没有点击后的阴影效果)

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    self.titleLab.textAlignment = 1;
    //[PublicTool setIntoAppForPassword:@"111111"];
    
    if (indexPath.row < self.dataArray.count - 1) {
        if ([PublicTool loadPasswordForIntoApp].length > 0) {
            cell.textLabel.text = @"关闭密码";
            
        }else{
            
        }
    }else{
        if ([PublicTool loadPasswordForIntoApp].length < 1) {
            cell.textLabel.textColor = [UIColor grayColor];
        }else{
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }
    
    /*
    UserCenterModel *model = [UserCenterModel new];
    model = self.dataArray[indexPath.row];
    cell.model = model;
    
    */
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    switch (indexPath.row) {
        case 0:
        {
            if ([PublicTool loadPasswordForIntoApp].length > 0) {
                SYLog(@"关闭密码");
                [PublicTool showAlertToViewController:self alertControllerTitle:@"提示" alertControllerMessage:@"您确定要关闭密码吗?" alertCancelTitle:@"取消" alertReportTitle:@"是的" cancelHandler:^(UIAlertAction * _Nonnull action) {
                    
                } reportHandler:^(UIAlertAction * _Nonnull action) {
                    self.dataArray = @[@"打开密码", @"修改密码"];
                    [PublicTool setIntoAppForPassword:@""];
                    [self.tableView reloadData];
                } completion:^{
                    
                }];
            }else{
                Weak_Self;
                SetPasswordViewController *setVC = [[SetPasswordViewController alloc] init];
                setVC.isPush = YES;
                setVC.pages = 2;
                setVC.SetPassStatusBlock = ^(NSString *status) {
                    weakSelf.dataArray = @[@"关闭密码", @"修改密码"];
                    [weakSelf.tableView reloadData];
                    [PublicTool showHUDWithViewController:weakSelf Text:status];
                   
                };
                [self.navigationController pushViewController:setVC animated:YES];
            }
        }
            break;
            
        case 1:
        {
            Weak_Self;

            if ([PublicTool loadPasswordForIntoApp].length > 0) {
                SetPasswordViewController *setVC = [[SetPasswordViewController alloc] init];
                setVC.isPush = YES;
                setVC.pages = 3;
                setVC.SetPassStatusBlock = ^(NSString *status) {
                    weakSelf.dataArray = @[@"关闭密码", @"修改密码"];
                    [weakSelf.tableView reloadData];
                    [PublicTool showHUDWithViewController:weakSelf Text:status];
                    
                };
                [self.navigationController pushViewController:setVC animated:YES];
            }else{
                
            }
        }
            break;
            
        default:
            break;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .5f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footLine = [[UIView alloc] initWithFrame:CGRectMake(10, 0, Screen_Width, 0.5f)];
    footLine.backgroundColor = SYLineColor;
    return footLine;
}



- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 64)];
        _navView.backgroundColor = [UIColor colorWithRed:0.31 green:0.53 blue:0.91 alpha:1.00];
        self.backBtn  = [PublicTool createBtnWithButton:self.backBtn buttonType:UIButtonTypeCustom frame:CGRectMake(3, 17, 40, 30) backgroundColor:SYNOColor image:SYImage(@"min77_back_bt") normalTile:nil selectedTitle:nil highlightTile:nil textAlignment:1 selected:nil titleNormalColor:nil titleSelectedColor:nil titleHighlightedColor:nil];
        [self.backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:self.backBtn];
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


- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = 1;
        _titleLab.font = [UIFont systemFontOfSize:18];
        _titleLab.numberOfLines = 0;
        
    }
    return _titleLab;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navView.height, Screen_Width, Screen_Height - self.navView.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = SYWhiteColor;
       // _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
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
