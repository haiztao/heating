//
//  UIButton+Extension.m
//  CbyGE
//
//  Created by AllenKwok on 15/12/5.
//  Copyright © 2015年 GE. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

- (void)addLine{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
//    [str addAttribute:NSForegroundColorAttributeName value:ThemeLoginButtonTextColor range:strRange];
    [self setAttributedTitle:str forState:UIControlStateNormal];
}

@end
