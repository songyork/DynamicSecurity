//
//  SetPasswordViewController.h
//  DynamicSecurity
//
//  Created by SDK on 2017/11/15.
//  Copyright © 2017年 songyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetPasswordViewController : UIViewController

/*表示scrollView的页码有几页*/
@property (nonatomic, assign) int pages;

/*是否是push状态进入页面*/
@property (nonatomic, assign) BOOL isPush;

/*返回密码设置成功 : 用于HUD提示 (由于dismiss回到上级页面,HUD来不及提示就被释放掉, 所以回到上级页面显示HUD提示)*/
@property (nonatomic, copy) void(^SetPassStatusBlock)(NSString *status);



@end
