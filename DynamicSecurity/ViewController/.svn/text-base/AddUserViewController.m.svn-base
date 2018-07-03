//
//  AddUserViewController.m
//  DynamicSecurity
//
//  Created by SDK on 2017/11/6.
//  Copyright © 2017年 songyan. All rights reserved.
//

#import "AddUserViewController.h"
#import "AddUserTableViewCell.h"
#import "DSLoginViewController.h"
@interface AddUserViewController ()<UITableViewDelegate,UITableViewDataSource,DSAddUserTableCellDelegate>

@property (nonatomic, strong) UIImageView *headView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *headImage;

@property (nonatomic ,strong) UILabel *userNameLab;

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *touchAddBtn;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

static NSString *cellID = @"AddUserTableViewCell";


@implementation AddUserViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"切换/添加账号";
    self.view.backgroundColor = SYWhiteColor;
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[PublicTool creatBackBtnWithTarget:self Action:@selector(backClick)]];

    [self setUpSubviews];
    [self loadDataForTableView];
    [self.view addSubview:self.tableView];

    self.dataArray = [NSMutableArray new];
    [self.tableView registerClass:[AddUserTableViewCell class] forCellReuseIdentifier:cellID];
}

- (void)loadDataForTableView{
    Weak_Self;
    [[NetworkTool sharedNetworkTool] getManagerBySingleton];
    // 获取用户信息
    [[NetworkTool sharedNetworkTool] getUserDynamicWithSn:[UserInfo sharedUserInfo].postUUID completion:^(BOOL isSuccess, id respones) {
        if (isSuccess) {
            NSArray *arr = respones[@"data"];
            weakSelf.dataArray = [AddModel getDate:arr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }else{
            [PublicTool showHUDWithViewController:self Text:respones[@"msg"]];
        }
    } failure:^(id error) {
        [PublicTool showHUDWithViewController:self Text:@"网络异常"];
    }];
}

- (void)setUpSubviews{
    [self.view addSubview:self.headView];
    [self.headView addSubview:self.backBtn];
    [self.headView addSubview:self.headImage];
    [self.headView addSubview:self.userNameLab];
    [self layoutSunviews];
    
}


- (void)layoutSunviews{
    
    self.headView.frame = CGRectMake(0, 0, Screen_Width, (Screen_Width / (16/9) / 2));
    self.backBtn.frame = CGRectMake(10, 30, 40, 30);
    self.headImage.frame = CGRectMake(0, 0, 100, 100);
    
    self.headImage.center = CGPointMake(self.headView.width / 2, self.headView.height / 2);
    self.headImage.layer.cornerRadius = self.headImage.width / 2;
    self.headImage.layer.masksToBounds = YES;
    
    self.userNameLab.frame =CGRectMake(0, self.headView.height - 25, Screen_Width, 20);
    self.userNameLab.text = [UserInfo sharedUserInfo].userName;
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.headView.mas_bottom);
//        make.left.and.right.and.bottom.equalTo(weakSelf.view);
//    }];

}

#pragma mark ------------------------------------------------Click & Method


- (void)backClick{
    SYLog(@"back");
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)touchAddClick:(UITapGestureRecognizer *)tapGR{
    SYLog(@"添加账号");
    [UserInfo sharedUserInfo].isLoginToApp = NO;
//    for (UIViewController *temp in self.navigationController.viewControllers) {
//        if ([temp isKindOfClass:[DSLoginViewController class]]) {
//            [self.navigationController popToViewController:temp animated:YES];
//        }
//    }
    // 创建一个新的loginview 用来做添加账号
    DSLoginViewController *addUserVC = [[DSLoginViewController alloc] init];
    addUserVC.pushWay = 1;
    [self.navigationController pushViewController:addUserVC animated:YES];
    
}

#pragma mark ------------------------------------------------TableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Weak_Self;
    AddUserTableViewCell *cell = (AddUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[AddUserTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];

    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; //（这种是没有点击后的阴影效果)
        
    SYLog(@"dataArray---------------- :%@", self.dataArray);
    cell.userOnline = [UserInfo sharedUserInfo].secretCode;
    AddModel *model = [AddModel new];
    model = self.dataArray[indexPath.row];
    cell.model = model;
    cell.delegate = self;
    cell.changeBlock = ^(AddModel *addModel) {
        if (weakSelf.addBlock) {
            [UserInfo sharedUserInfo].userName = addModel.userName;
            [UserInfo sharedUserInfo].userID = addModel.userID;
//            [UserInfo sharedUserInfo].secretCode = addModel.userSecret;
            weakSelf.addBlock(addModel);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    if (indexPath.row < self.dataArray.count - 1) {
        cell.lineView.hidden = NO;
    }else{
        cell.lineView.hidden = YES;
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
    [PublicTool showAlertToViewController:self alertControllerTitle:nil alertControllerMessage:@"是否设置此账号为自动登录账号" alertCancelTitle:@"取消" alertReportTitle:@"设置" cancelHandler:^(UIAlertAction * _Nonnull action) {
        
    } reportHandler:^(UIAlertAction * _Nonnull action) {
        
    } completion:^{
        
    }];
    */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *secFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 90)];
    secFootView.backgroundColor = SYNOColor;
    
    UIView *footLine = [[UIView alloc] initWithFrame:CGRectMake(10, 0, Screen_Width, 0.5f)];
    footLine.backgroundColor = SYLineColor;
    [secFootView addSubview:footLine];
  
    
    UIView *touchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    touchView.center = secFootView.center;
    touchView.backgroundColor = SYNOColor;
    [secFootView addSubview:touchView];
    UIImageView *addImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    addImage.image = SYImage(@"04+");
    addImage.layer.cornerRadius = addImage.width / 2;
    addImage.layer.masksToBounds = YES;
    
    UILabel *addLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, 85, 20)];
    addLab.text = @"添加账号";
    addLab.textAlignment = 1;
    addLab.font = [UIFont systemFontOfSize:18];
    addLab.textColor = [UIColor colorWithRed:0.95 green:0.58 blue:0.1 alpha:1];
    
    [touchView addSubview:addImage];
    [touchView addSubview:addLab];
    
    UITapGestureRecognizer *touchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAddClick:)];
    [touchView addGestureRecognizer:touchTap];
    
    
    return secFootView;
}

#pragma mark ----------------------------------------------CellDelegate
- (void)cell:(UITableViewCell *)cell changeUserForData:(AddModel *)data{
    SYLog(@"-----------%@", data.userName);
}

- (UIImageView *)headView{
    if (!_headView) {
        _headView = [[UIImageView alloc] initWithImage:SYImage(@"02头部bg.jpg")];
        _headView.userInteractionEnabled = YES;
    }
    return _headView;
}

- (UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc] initWithImage:SYImage(@"头像01")];
        
    }
    return _headImage;
}

- (UILabel *)userNameLab{
    if (!_userNameLab) {
        _userNameLab = [[UILabel alloc] init];
        _userNameLab.textAlignment = 1;
        _userNameLab.font = [UIFont systemFontOfSize:18];
        _userNameLab.backgroundColor = SYNOColor;
        
    }
    return _userNameLab;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [PublicTool createBtnWithButton:_backBtn buttonType:UIButtonTypeCustom frame:CGRectZero backgroundColor:SYNOColor image:SYImage(@"min77_back_bt") normalTile:nil selectedTitle:nil highlightTile:nil textAlignment:1 selected:nil titleNormalColor:nil titleSelectedColor:nil titleHighlightedColor:nil];
        [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headView.height, Screen_Width, Screen_Height - self.headView.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = SYWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

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
