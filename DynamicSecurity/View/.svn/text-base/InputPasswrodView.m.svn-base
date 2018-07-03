//
//  InputPasswrodView.m
//  DynamicSecurity
//
//  Created by SDK on 2017/11/15.
//  Copyright © 2017年 songyan. All rights reserved.
//

#import "InputPasswrodView.h"

@interface InputPasswrodView ()<UITextFieldDelegate>


@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) NSMutableArray *dotArray;



@end

#define syDotSize CGSizeMake (10, 10) //密码点的大小
#define syDotCount 6  //密码个数
#define SY_Field_Height 45  //每一个输入框的高度

@implementation InputPasswrodView


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = SYWhiteColor;
        self.frame = CGRectMake(0, 0, Screen_Width - 80, 45);
        CGPoint centerPoint = CGPointMake(Screen_Width / 2, Screen_Height / 2);
        self.center = centerPoint;
        self.userInteractionEnabled = YES;

        [self initInputPasswrodView];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame inputType:(InputPasswordType)inputype
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = SYNOColor;
        self.frame = frame;
        //CGPoint centerPoint = CGPointMake(Screen_Width / 2, Screen_Height / 2);
        //self.center = centerPoint;
        self.userInteractionEnabled = YES;
        self.inputPasswordType = inputype;
        [self initInputPasswrodView];
        
    }
    return self;
}


- (void)initInputPasswrodView{
    
    self.layer.borderColor = [[UIColor grayColor] CGColor];
    self.layer.borderWidth = 1;

    
    self.verifyTextField.frame = CGRectMake(0, 0, Screen_Width - 80, 45);
    self.verifyTextField.hidden = YES;
    [self.verifyTextField becomeFirstResponder];
    [self addSubview:self.verifyTextField];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.verifyTextField];

    
    self.dotArray = [[NSMutableArray alloc] init];
    CGFloat viewWidth = (self.width) / syDotCount;
    
    
    
    //生成分割线
    for (int i = 0; i < syDotCount - 1; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.verifyTextField.frame) + (i + 1) * viewWidth, 0, 1, SY_Field_Height)];
        lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:lineView];
    }
    
    
    for (int i = 0; i < syDotCount; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.verifyTextField.frame) + (viewWidth - syDotCount) / 2 + i * viewWidth, CGRectGetMinY(self.verifyTextField.frame) + (SY_Field_Height - syDotSize.height) / 2, syDotSize.width, syDotSize.height)];
        dotView.backgroundColor = [UIColor blackColor];
        dotView.layer.cornerRadius = syDotSize.width / 2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES; //先隐藏
        [self addSubview:dotView];
        //把创建的黑色点加入到数组中
        [self.dotArray addObject:dotView];
    }

    
  //  [self layoutSubviews];
    
    UITapGestureRecognizer *tapTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchClick:)];
    [self addGestureRecognizer:tapTouch];
}


- (void)touchClick:(UITapGestureRecognizer *)tapGR{
    
    SYLog(@"点击了view");
    if (!self.verifyTextField.isFirstResponder) {
        [self.verifyTextField becomeFirstResponder];
    }
}

#pragma mark ----------------------------------------------UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    SYLog(@"变化%@", string);
     if(string.length == 0) {
        //判断是不是删除键
        return YES;
    }
    if(textField.text.length >= syDotCount) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        SYLog(@"输入的字符个数大于6，忽略输入");
        return NO;
    }
    return YES;
}
 


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.isFirstResponder) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

/**
 *  清除密码
 */
- (void)clearUpPassword
{
    self.verifyTextField.text = @"";
    [self textFieldDidChange:self.verifyTextField];
}


- (void)textFieldDidChange:(UITextField *)textField{
    
    SYLog(@"%@", textField.text);
    for (UIView *dotView in self.dotArray) {
        dotView.hidden = YES;
    }
    for (int i = 0; i < textField.text.length; i++) {
        if (i < 6) {
            ((UIView *)[self.dotArray objectAtIndex:i]).hidden = NO;

        }
    }
    if (textField.text.length == syDotCount) {
        SYLog(@"输入完毕");
        
        
        if (self.inputPasswordType == 0) {
            if (self.SetBlock) {
                self.SetBlock(textField.text);
            }
        }else if (self.inputPasswordType == 1){
            if (self.SetBlock) {
                self.SetBlock(textField.text);
            }
        }else if (self.inputPasswordType == 2){
           
            if ([textField.text isEqualToString:[PublicTool loadPasswordForIntoApp]]) {
                if (self.PassBlock) {
                    self.PassBlock(YES);
                    [textField resignFirstResponder];
                    
                }
            }else{
                if (self.PassBlock) {
                    self.PassBlock(NO);
                    [self clearUpPassword];
                    [textField resignFirstResponder];

                }
            }
        }
    }
}


# pragma mark --------------------------------------------------------------- 输入框输入的文字限制
/*输入框输入的文字限制*/

-(void)textFieldEditChanged:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    [self limitTextLengthFor:textField length:syDotCount];
    
    
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



- (BaseTextField *)verifyTextField{
    if (!_verifyTextField) {
        _verifyTextField = [[BaseTextField alloc] init];//
        // self.verifyTextField.center = self.BGView.center;
        _verifyTextField.backgroundColor = SYWhiteColor;
        _verifyTextField.textColor = SYWhiteColor;
        _verifyTextField.tintColor = SYWhiteColor;
        _verifyTextField.layer.borderColor = [[UIColor grayColor] CGColor];
        _verifyTextField.layer.borderWidth = 1;
        
        
        /*首字母不会自动大写*/
        _verifyTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        
        _verifyTextField.delegate = self;
        _verifyTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _verifyTextField.textAlignment = 0;
        _verifyTextField.keyboardType = UIKeyboardTypeNumberPad;
        //_verifyTextField.font = [UIFont systemFontOfSize:14];
        //_verifyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //_verifyTextField.secureTextEntry = YES;
        _verifyTextField.returnKeyType = UIReturnKeyDone;
        //_verifyTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        [_verifyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _verifyTextField;
}

@end
