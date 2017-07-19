//
//  TipsView.h
//  heating
//
//  Created by haitao on 2017/3/28.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipsView : UIView{
    UIView *_coverView; //背景
    UIView *_alertView;
    UILabel *_labelTitle;
    UILabel *_labelmessage;
    
    UIScrollView *_contentScrollView;
    
    NSString *_title;
    NSString *_message;
    //标题图片
    UIImageView *_iconView;
    UIImage *_iconImage;
}


/**
 *  初始化对话框
 *
 *  @param iconName 图标
 *  @param title    标题
 *  @param message  提示语
 *
 *  @return self
 */
- (instancetype)initWithIconName:(NSString *)iconName withTitle:(NSString *)title withMessage:(NSString *)message;

/**
 *  显示对话框
 */
- (void)show;

/**
 *  消息对话框
 */
- (void)dismiss;

@end
