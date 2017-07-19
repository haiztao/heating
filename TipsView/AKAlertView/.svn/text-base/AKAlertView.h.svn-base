//
//  AKAlertView.h
//  AKAlertView
//
//  Created by AllenKwok on 15/10/16.
//  Copyright © 2015年 xlink.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum ButtonType{
    ButtonTypeOK,   //确认
    ButtonTypeCancel,//取消
    ButtonTypeOther//其他
}ButtonType;

@class AKAlertViewItem;
typedef void(^AKAlertViewHandler)(AKAlertViewItem *item);


@interface AKAlertView : UIView{
UIView *_coverView;
UIView *_alertView;
UILabel *_labelTitle;
UILabel *_labelmessage;
    
UIScrollView *_buttonScrollView;
UIScrollView *_contentScrollView;

NSMutableArray *_items;
NSString *_title;
NSString *_message;
//标题图片
UIImageView *_iconView;

UIImage *_iconImage;
    NSArray *_contentArray;
}

//icon是否旋转
@property(assign,nonatomic,getter=isRotate)BOOL rotate;
//按钮宽度,如果赋值,菜单按钮宽之和,超过alert宽,菜单会滚动
@property(assign,nonatomic)CGFloat buttonWidth;
//将要显示在alert上的自定义view
@property(strong,nonatomic)UIView *contentView;

/**
 *  初始化对话框
 *
 *  @param title   标题
 *  @param message 提示语
 *
 *  @return self
 */
- (instancetype)initWithTitle:(NSString *)title withMessage:(NSString *)message;

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
 *  添加一个按钮
 *
 *  @param title 按钮标题
 *
 *  @return 按钮的index
 */
- (NSInteger)addButtonWithTitle:(NSString *)title;

/**
 *  添加一个按钮
 *
 *  @param type    按钮类型
 *  @param title   按钮标题
 *  @param handler 按钮点击事件
 */
- (void)addButton:(ButtonType)type withTitle:(NSString *)title handler:(AKAlertViewHandler)handler;

/**
 *  显示对话框
 */
- (void)show;

/**
 *  消息对话框
 */
- (void)dismiss;

@end

@interface AKAlertViewItem : NSObject
/**
 *  按钮标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  按钮类型
 */
@property (nonatomic) ButtonType type;

/**
 *  按钮tag
 */
@property (nonatomic) NSUInteger tag;

/**
 *  点击时间
 */
@property (nonatomic, copy) AKAlertViewHandler action;

@end
