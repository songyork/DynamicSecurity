//
//  PublicTool.h
//  AYSDK
//
//  Created by SDK on 2017/7/26.
//  Copyright © 2017年 SDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicTool : NSObject



//*** 1、获取bundle文件
+ (NSBundle *_Nonnull)getResourceBundle;

//*** 2、获取bunle文件里面的图片
+ (UIImage *_Nonnull)getImageFromBundle:(NSBundle *_Nullable)bundle withName:(NSString *_Nullable)name withType:(NSString *_Nullable)type;

//*** 3、将字符串转换成md5
+ (NSString *_Nonnull)toMD5:(NSString *_Nullable)targetString;

+ (NSString *_Nonnull)makesignStringWithParams:(NSDictionary *_Nullable)params;

//获取时间戳
+(NSString *_Nonnull)getTimeStamps;


//*** 4、字典转成字符串
+ (NSString *_Nonnull)buildQueryString:(id _Nullable )dict sortArray:(NSArray *_Nullable)sortArray needUrlEncode:(BOOL)isEncode;


//*** 5、获取主视图的根视图控制器
+ (UIViewController *_Nonnull)getKeyWindowRootVcr;

//*** 6、判断是否是手机号码
+ (BOOL)isValidateTel:(NSString *_Nullable)tel;


/*设置登录密码*/
+ (void)setIntoAppForPassword:(NSString *_Nullable)password;



/**
 读取登录密码

 @return string : 密码
 */
+ (NSString *_Nonnull)loadPasswordForIntoApp;

/*第一次打开*/
+ (void)saveFirstOpen:(BOOL)firstOpen;

+ (BOOL)getCurrenFirstOpen;

/*是否需要自动登录*/
+ (void)ifNeedAutoLogin:(BOOL)isAutoLogin;

/*是否是自动登录状态*/
+ (BOOL)isAuToLoginToUserChoose;

//*** 7、密码加密处理
+(NSString *_Nonnull)generatePassword:(NSString *_Nullable)password;

/*
 * 自动登录保存用户名
 */
+ (void)fastLoginWithSecretCode:(NSString *_Nullable)secret;

/**
 * 取出自动登录保存的用户名
 */
+ (NSString *_Nonnull)getSecretCodeForFastLogin;


/*
 * 保存自动登录的用户名和密码
 * @param value : 密码
 */
+ (void)fastLoginWithValue:(NSDictionary *_Nullable)value key:(NSString *_Nullable)key;

/*
 * 取出自动登录是保存的账号密码
 */
+ (id _Nonnull)getFastLoginWithKey:(NSString *_Nullable)key;

/**
 * encode转码
 */
+ (NSString *_Nonnull)encodeString:(NSString *_Nullable)unencodedString;

+ (NSString *_Nonnull)decodeString:(NSString *_Nullable)encodedString;

//保存token值
+ (void)saveToken:(NSString *_Nullable)token;

//获取token值
+ (NSString *_Nonnull)getToken;

/**
 * HUD
 */
+ (void)showHUDWithViewController:(UIViewController *_Nullable)viewController Text:(NSString *_Nullable)text;

/*
 * 禁用系统返回手势
 */
+ (void)stopSystemPopGestureRecognizerForNavigationController:(UINavigationController *_Nonnull)navigationController;

/**
 * alertViewController
 */
+ (void)showAlertToViewController:(UIViewController *_Nullable)viewController alertControllerTitle:(NSString *_Nullable)alertControllerTitle alertControllerMessage:(NSString *_Nullable)message alertCancelTitle:(NSString *_Nullable)cancelTitle alertReportTitle:(NSString *_Nullable)reportTitle cancelHandler:(void(^__nullable)(UIAlertAction * _Nonnull action))cancelHandler reportHandler:(void(^__nullable)(UIAlertAction * _Nonnull action))reportHandler completion:(void (^ __nullable)(void))completion;

+ (UIButton *_Nonnull)createBtnWithButton:(UIButton *_Nonnull)btn buttonType:(UIButtonType)buttonType frame:(CGRect)frame backgroundColor:(UIColor *_Nullable)backgroundColor image:(UIImage *_Nullable)image normalTile:(NSString *_Nullable)normalTile selectedTitle:(NSString *_Nullable)selectedTitle highlightTile:(NSString *_Nullable)highlightTile textAlignment:(NSTextAlignment)textAlignment selected:(BOOL)selected titleNormalColor:(UIColor *_Nullable)titleNormalColor titleSelectedColor:(UIColor *_Nullable)titleSelectedColor titleHighlightedColor:(UIColor *_Nullable)titleHighlightedColor;

/*创建返回BTN*/
+ (UIView *_Nonnull)creatBackBtnWithTarget:(UIViewController *_Nullable)target Action:(SEL _Nonnull)action;

/**
 * 保存上次登录是返回的语言选项
 */
+ (void)saveLanguage:(BOOL)isChiness;

+ (BOOL)getLanguage;

//+ (void)saveHtmlString:(NSString *)urlString MoneyString:(NSString *)moneyString;

/*是否有空格*/
+ (BOOL)isEmpty:(NSString *_Nonnull)string;

/*利用富文本改变label的字体颜色*/
+ (UILabel *_Nonnull)changeTextColor:(UIColor *_Nullable)changeColor ChangeTitle:(NSString *_Nullable)changeTitleText Titile:(NSString *_Nullable)titleText ToLabel:(UILabel *_Nonnull)label;


@end
