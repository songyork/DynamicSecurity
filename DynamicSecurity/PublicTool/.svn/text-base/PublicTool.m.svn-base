//
//  PublicTool.m
//  AYSDK
//
//  Created by SDK on 2017/7/26.
//  Copyright © 2017年 SDK. All rights reserved.
//

#import "PublicTool.h"
#import <CommonCrypto/CommonDigest.h>


@interface PublicTool ()



@end


@implementation PublicTool



//*** 1、获取bundle文件
+ (NSBundle *_Nonnull)getResourceBundle
{
    NSURL *bundleUrl = [[NSBundle mainBundle] URLForResource:@"AYSDKBundle" withExtension:@"bundle"];
    return [NSBundle bundleWithURL:bundleUrl];
}


//*** 2、获取bunle文件里面的图片
+ (UIImage *_Nonnull)getImageFromBundle:(NSBundle *_Nullable)bundle withName:(NSString *_Nullable)name withType:(NSString *_Nullable)type{
    NSString *imagePath = [bundle pathForResource:name ofType:type];
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:imagePath]];
    return image;
}

//*** 3、将字符串转换成md5
+ (NSString *_Nonnull)toMD5:(NSString *_Nullable)targetString{
    if (targetString){
        const char* data = [targetString UTF8String];
        unsigned int len= (unsigned int)strlen(data);
        unsigned char result[16];
        CC_MD5(data,len,result);
        NSString* md5_string = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                                result[0],result[1],result[2],result[3],result[4],result[5],result[6],
                                result[7],result[8],result[9],result[10],
                                result[11],result[12],result[13],result[14],result[15]];
        return [md5_string lowercaseString];
    }
    return nil;
}

/**
 请求签名
 */

+(NSString *_Nonnull)makesignStringWithParams:(NSDictionary *_Nullable)params{
    NSString *string1 =[[NSString alloc]init];
    NSArray *sortedArray = [params.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    for (NSString *sortedKey in sortedArray) {
        
        NSString *keyValue = [NSString stringWithFormat:@"%@=%@&",sortedKey,params[sortedKey]];
        NSString *string2 =[NSString stringWithFormat:@"%@%@",string1,keyValue];
        string1 = string2;
    }
    NSString *sortedString = [NSString string];
    NSString *lastString = [NSString string];
    if (string1.length > 0) {
         sortedString = [NSString stringWithFormat:@"%@%@",SY_API_KEY,string1];
        lastString = [sortedString substringWithRange:NSMakeRange(0, sortedString.length - 1)];

    }else{
        sortedString = [NSString stringWithFormat:@"%@",SY_API_KEY];
        lastString = [sortedString substringWithRange:NSMakeRange(0, sortedString.length)];

    }
    NSString *sign = [PublicTool toMD5:lastString];
    return sign;
}





+ (NSString *_Nonnull)getTimeStamps{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)time;
    return [NSString stringWithFormat:@"%lld",date];
}


//*** 4、字典转成字符串
+ (NSString *_Nonnull)buildQueryString:(id _Nullable)dict sortArray:(NSArray *_Nullable)sortArray needUrlEncode:(BOOL)isEncode{
    if ([dict isKindOfClass:[NSDictionary class]] || [dict isKindOfClass:[NSDictionary class]]) {
        NSMutableString *tempMsg = [NSMutableString string];
        for (id str in sortArray)
        {
            NSString *urlEncodedStr = nil;
            if ([[dict objectForKey:str] isKindOfClass:[NSString class]] && isEncode) {
                urlEncodedStr = [PublicTool encodeString:[dict objectForKey:str]];
            }
            else{
                urlEncodedStr = [dict objectForKey:str];
            }
            [tempMsg appendString:[NSString stringWithFormat:@"%@=%@&", str, urlEncodedStr]];
        }
        NSString *queryMsg = [tempMsg substringToIndex:tempMsg.length - 1];
        return queryMsg;
    }else{
        [NSException raise:@"SDK Error" format:@"不可用数据类型 %@", [dict class]];
        return nil;
    }
}


//*** 5、获取主视图的根视图控制器
+ (UIViewController *_Nonnull)getKeyWindowRootVcr{
//    UIViewController *vcr = [UIApplication sharedApplication].keyWindow.rootViewController;
//    UIViewController *topVC = vcr;
//    while (topVC.presentedViewController) {
//        topVC = topVC.presentedViewController;
//    }
//    NSArray *controArr = [UIApplication sharedApplication].windows;
//    UIWindow *win = [controArr firstObject];
//    UIViewController *VC = win.rootViewController;
//    UIViewController *topVC = VC.presentedViewController;
//    return topVC;
    
    
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
    
}


//*** 6、判断是否是手机号码
+ (BOOL)isValidateTel:(NSString *_Nullable)tel
{
    NSString *patternTel = @"^1[3,4,5,7,8][0-9]{9}$";
    NSError *err = nil;
    NSRegularExpression *TelExp = [NSRegularExpression regularExpressionWithPattern:patternTel options:NSRegularExpressionCaseInsensitive error:&err];
    NSTextCheckingResult * isMatchTel = [TelExp firstMatchInString:tel options:0 range:NSMakeRange(0, [tel length])];
    return isMatchTel? YES: NO;
}


//*** 7、密码加密处理
+ (NSString *_Nonnull)generatePassword:(NSString *_Nullable)password
{
    return [PublicTool toMD5:[NSString stringWithFormat:@"%@%@",password,[PublicTool toMD5:password]]];
}



+ (NSString *_Nonnull)encodeString:(NSString *_Nullable)unencodedString
{
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)unencodedString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
    return encodedString;
}

+ (NSString *_Nonnull)decodeString:(NSString *_Nullable)encodedString
{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)encodedString, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}


+ (void)setIntoAppForPassword:(NSString *_Nullable)password{
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"intoApp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString *_Nonnull)loadPasswordForIntoApp{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"intoApp"];
}

/*保存token值*/
+ (void)saveToken:(NSString *_Nullable)token{
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*获取token值*/
+ (NSString *_Nonnull)getToken{
    
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    return tokenStr;
}

+ (void)showHUDWithViewController:(UIViewController *_Nullable)viewController Text:(NSString *_Nullable)text{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.label.text = text;
    [HUD hideAnimated:YES afterDelay:1];
    //    [self.HUD removeFromSuperview];
    //    self.HUD = nil;
    
}


+ (void)saveFirstOpen:(BOOL)firstOpen{
    [[NSUserDefaults standardUserDefaults] setBool:firstOpen forKey:@"userFirstOpen"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getCurrenFirstOpen{
    BOOL first = [[NSUserDefaults standardUserDefaults]boolForKey:@"userFirstOpen"];
    return first;
    
}


+ (void)fastLoginWithSecretCode:(NSString *_Nullable)secret{
    [[NSUserDefaults standardUserDefaults] setObject:secret forKey:SY_fastLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *_Nonnull)getSecretCodeForFastLogin{
    NSString *secret = [[NSUserDefaults standardUserDefaults] objectForKey:SY_fastLogin];
    return secret;
}

+ (void)fastLoginWithValue:(NSString *_Nullable)value key:(NSString *_Nullable)key{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getFastLoginWithKey:(NSString *_Nullable)key{
    NSString *value = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    return value;
}

+ (void)ifNeedAutoLogin:(BOOL)isAutoLogin{
    [[NSUserDefaults standardUserDefaults] setBool:isAutoLogin forKey:@"autoLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isAuToLoginToUserChoose{
    BOOL isAutoLogin = [[NSUserDefaults standardUserDefaults]boolForKey:@"autoLogin"];
    return isAutoLogin;
    
}

+ (void)saveLanguage:(BOOL)isChiness{
    [[NSUserDefaults standardUserDefaults] setBool:isChiness forKey:@"userLanguage"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+ (BOOL)getLanguage{
    BOOL isChiness = [[NSUserDefaults standardUserDefaults] boolForKey:@"userLanguage"];
    
    return isChiness;
}

+ (UILabel *_Nonnull)changeTextColor:(UIColor *_Nullable)changeColor ChangeTitle:(NSString *_Nullable)changeTitleText Titile:(NSString *_Nullable)titleText ToLabel:(UILabel *_Nonnull)label{
    NSDictionary *subStringAttribute = @{
                                         NSForegroundColorAttributeName     : changeColor,
                                         NSFontAttributeName                : label.font
                                         };
    label.attributedText = [titleText toAttributedStringWithChangeWords:@[changeTitleText] andAttributes:@[subStringAttribute]];
    return label;
    
}

+ (void)stopSystemPopGestureRecognizerForNavigationController:(UINavigationController *_Nonnull)navigationController{
    // 禁用返回手势
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}


// 方法 判断是否有空格
+ (BOOL)isEmpty:(NSString *_Nonnull)str{
    NSRange range = [str rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return YES; //yes代表包含空格
    }else {
        return NO; //反之
    }
}


+ (void)showAlertToViewController:(UIViewController *_Nullable)viewController alertControllerTitle:(NSString *_Nullable)alertControllerTitle alertControllerMessage:(NSString *_Nullable)message alertCancelTitle:(NSString *_Nullable)cancelTitle alertReportTitle:(NSString *_Nullable)reportTitle cancelHandler:(void(^__nullable)(UIAlertAction * _Nonnull action))cancelHandler reportHandler:(void(^__nullable)(UIAlertAction * _Nonnull action))reportHandler completion:(void (^ __nullable)(void))completion{
    
   
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertControllerTitle message:message preferredStyle:UIAlertControllerStyleAlert];
   
    UIAlertAction *Cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelHandler) {
            cancelHandler(action);
        }
    }];
    [alertController addAction:Cancel];

    if (reportTitle || reportTitle.length > 0) {
        UIAlertAction *Report = [UIAlertAction actionWithTitle:reportTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (reportHandler) {
                reportHandler(action);
            }
        }];
        [alertController addAction:Report];
    }
   
    [viewController presentViewController:alertController animated:YES completion:^{
        if (completion) {
            completion();
        }
    }];

}

+ (UIButton *_Nonnull)createBtnWithButton:(UIButton *_Nonnull)btn buttonType:(UIButtonType)buttonType frame:(CGRect)frame backgroundColor:(UIColor *_Nullable)backgroundColor image:(UIImage *_Nullable)image normalTile:(NSString *_Nullable)normalTile selectedTitle:(NSString *_Nullable)selectedTitle highlightTile:(NSString *_Nullable)highlightTile textAlignment:(NSTextAlignment)textAlignment selected:(BOOL)selected titleNormalColor:(UIColor *_Nullable)titleNormalColor titleSelectedColor:(UIColor *_Nullable)titleSelectedColor titleHighlightedColor:(UIColor *_Nullable)titleHighlightedColor{
    
    if (!backgroundColor) {
        backgroundColor = SYNOColor;
    }
    if (!normalTile || normalTile.length < 1) {
        normalTile = @"";
    }
    if (!highlightTile || highlightTile.length < 1) {
        highlightTile = normalTile;
    }
    if (!selectedTitle || selectedTitle.length < 1) {
        selectedTitle = normalTile;
    }
    if (!textAlignment) {
        textAlignment = 1;
    }
    if (!titleNormalColor) {
        titleNormalColor = SYWhiteColor;
    }
    if (!titleHighlightedColor) {
        titleHighlightedColor = SYWhiteColor;
    }
    if (!titleSelectedColor) {
        titleSelectedColor = SYWhiteColor;
    }
        
    
    btn = [UIButton buttonWithType:buttonType];
    btn.frame = frame;
    btn.backgroundColor = backgroundColor;
    if (image) {
        [btn setImage:image forState:UIControlStateNormal];
    }
    btn.titleLabel.textAlignment = textAlignment;
    [btn setTitle:normalTile forState:UIControlStateNormal];
    [btn setTitle:highlightTile forState:UIControlStateHighlighted];
    [btn setTitle:selectedTitle forState:UIControlStateSelected];
    btn.selected = selected;
    [btn setTitleColor:titleHighlightedColor forState:UIControlStateHighlighted];
    [btn setTitleColor:titleSelectedColor forState:UIControlStateSelected];
    [btn setTitleColor:titleNormalColor forState:UIControlStateNormal];
    return btn;
}




+ (UIView *_Nonnull)creatBackBtnWithTarget:(UIViewController *_Nullable)target Action:(SEL _Nonnull)action{
    UIView *backView = [[UIView alloc] init];
    
    UIImageView *backImage = [[UIImageView alloc] initWithImage:SYImage(@"tb_bl")];
    backImage.frame = CGRectMake(0, 0, 13, 20);
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, 0, 40, 15);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:SYWhiteColor forState:UIControlStateNormal];
    [backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:backImage];
    [backView addSubview:backBtn];
    backView.frame = CGRectMake(0, 0, 60, 30);
    backImage.centerY = backView.centerY;
    backBtn.centerY = backView.centerY;
    
    return backView;
    
}


@end
