//
//  BaseViewController.h
//  heating
//
//  Created by haitao on 2017/2/6.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

//导航界面
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *leftbutton;
@property (nonatomic,strong) UIButton *rightbutton;

//视图初始化
-(void)initUIWithTag:(NSInteger)tagValue headerColorIsWhite:(BOOL)isWhite andTitle:(NSString *)title rightBtnText:(NSString *)btnText;

-(void)gotoLoginViewController;

//网络问题图
@property (nonatomic,strong) UIView *noneNetworkView;
-(void)setupNetworkUnavailableWithTipMsg:(NSString *)msg title:(NSString *)title retryBtnTitle:(NSString *)retryBtnTitle;
    //点击重试
-(void)retryToRefreshDataSuorce;

//textFiled圆角
+(void)textFiledGetCorner:(UITextField *)textFiled;
+(void)viewGetCornerRadius:(UIView *)view;
//网络异常
+(void)netWordIsDisconnected;

//警告框
-(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message sureBtnTitle:(NSString *)sureBtnTitle cancelBtnTitle:(NSString *)cancelBtnTitle;


#pragma mark - 操作成功的toast
-(void)operateSucceedWithMessage:(NSString *)message;
//操作失败的toast
-(void)operateErrorWithMessage:(NSString *)message;

#pragma mark - 浮层提示
/**
 *  显示只有文字的提示信息
 *
 *  @param message 提示信息 默认1s后消失
 */
- (void)showNoticeMessage:(NSString *)message;

/**
 *  显示只有文字的提示信息
 *
 *  @param message 提示信息
 *  @param delay   几秒后消失
 */
- (void)showNoticeMessage:(NSString *)message hideAfterDelay:(NSTimeInterval)delay;

#pragma mark - 显示正在等待的提示
/**
 *  等待的提示信息
 *
 *  @param view    要显示在上面的view
 *  @param message 消息
 *
 *  @return hud
 */
-(MBProgressHUD *)showWaitingHudToView:(UIView *)view WithMessage:(NSString *)message;



#pragma mark - 错误提示
/**
 *  错误、失败提示
 *
 *  @param message       消息
 *  @param detialMessage 详细消息
 *  @param time          几秒后消失
 */
- (void)showErrorWithMessage:(NSString *)message withDetialMessage:(NSString *)detialMessage hideAfterDelay:(NSTimeInterval)time;


/**
 *  错误提示
 *
 *  @param message       消息
 *  @param time          几秒后消失
 */
- (void)showErrorWithMessage:(NSString *)message hideAfterDelay:(NSTimeInterval)time;

/**
 *  错误提示 3秒后自动消失
 *
 *  @param message       消息 按钮标题我知道了
 */
- (void)showErrorWithMessage:(NSString *)message;


@end
