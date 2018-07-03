//
//  InputPasswrodView.h
//  DynamicSecurity
//
//  Created by SDK on 2017/11/15.
//  Copyright © 2017年 songyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTextField.h"


typedef NS_ENUM(NSInteger, InputPasswordType) {
    SetPassword                = 0,   // 设置密码
    ChangePassword             = 1,   // 修改密码
    VerifyPassword             = 2,   // 进入验证密码
};



@interface InputPasswrodView : UIView

@property (nonatomic ,strong) BaseTextField *verifyTextField;

@property (nonatomic, copy) void(^PassBlock)(BOOL isMatch);//进入页面验证密码回调

@property (nonatomic, copy) void(^SetBlock)(NSString *password);//回调输入的text

@property (nonatomic, assign) InputPasswordType inputPasswordType;


/**
 自定义Init

 @param frame : frame
 @param inputype : InputPasswordType (枚举)
 @return : id
 */
- (id)initWithFrame:(CGRect)frame inputType:(InputPasswordType)inputype;
/**
 *  清除密码
 */
- (void)clearUpPassword;



@end
