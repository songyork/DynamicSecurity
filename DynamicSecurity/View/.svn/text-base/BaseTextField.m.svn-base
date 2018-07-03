//
//  BaseTextField.m
//  DynamicSecurity
//
//  Created by SDK on 2017/11/23.
//  Copyright © 2017年 songyan. All rights reserved.
//

#import "BaseTextField.h"

@implementation BaseTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




/**
 禁止对输入框做任何操作

 @param action : ...
 @param sender : ...
 @return   BOOL
 */
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    if(menuController) {
        
        [UIMenuController sharedMenuController].menuVisible=NO;
        
    }
    
    return NO;
    
}



@end
