//
//  BaseViewController.m
//  heating
//
//  Created by haitao on 2017/2/6.
//  Copyright © 2017年 haitao. All rights reserved.
//



#import "BaseViewController.h"
#import "XLinkExportObject.h"

#import "YSHYSlideViewController.h"
#import "LoginViewController.h"

#import "DataManage.h"
#import "TipsView.h"

@interface BaseViewController ()@property (strong, nonatomic) UIView *coverView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置头部视图字体及左右按钮(101:左;102:右) 103右边按钮为文字
-(void)initUIWithTag:(NSInteger)tagValue headerColorIsWhite:(BOOL)isWhite andTitle:(NSString *)title rightBtnText:(NSString *)btnText
{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainWidth, 64)];
    [self.view addSubview:headerView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(110/2, 20, MainWidth-110, 40)];
    self.titleLabel.text = title;

    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:19];
    [headerView addSubview:self.titleLabel];
    

    
    if ( tagValue == 101) {//按钮在左边
        
        self.leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftbutton.frame = CGRectMake(0, 20, 40, 40);
        self.leftbutton.contentMode = UIViewContentModeScaleToFill;
        [self.leftbutton setImage:[UIImage imageNamed:@"back_ic"] forState:UIControlStateNormal];
        self.leftbutton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        
        [self.leftbutton addTarget:self action:@selector(leftButtonToTurnBack) forControlEvents:UIControlEventTouchUpInside];
        
        [headerView addSubview:self.leftbutton];
        
        
    }
    else if (tagValue == 102 ){//左右都有
        
        self.leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftbutton.frame = CGRectMake(0, 20, 40, 40);
        self.leftbutton.contentMode = UIViewContentModeScaleToFill;
        [self.leftbutton setImage:[UIImage imageNamed:@"back_ic"] forState:UIControlStateNormal];
        self.leftbutton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        
        [self.leftbutton addTarget:self action:@selector(leftButtonToTurnBack) forControlEvents:UIControlEventTouchUpInside];
        
        [headerView addSubview:self.leftbutton];
        
        self.rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightbutton.frame = CGRectMake(MainWidth- 45, 20, 40, 40);
        _rightbutton.contentMode = UIViewContentModeScaleToFill;
        [_rightbutton setImage:[UIImage imageNamed:@"control_more_ic"] forState:UIControlStateNormal];
        _rightbutton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_rightbutton addTarget:self action:@selector(rightButtonToTurnBack) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:_rightbutton];
        
    }else if(tagValue == 103){ //more进入下层界面的tag值
        //left
        self.leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftbutton.frame = CGRectMake(0, 20, 40, 40);
        self.leftbutton.contentMode = UIViewContentModeScaleToFill;
        [self.leftbutton setImage:[UIImage imageNamed:@"back_ic"] forState:UIControlStateNormal];
        self.leftbutton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [self.leftbutton addTarget:self action:@selector(leftButtonToTurnBack) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:self.leftbutton];
        
        //right
        _rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightbutton.frame = CGRectMake(MainWidth - 65, 20, 60, 40);
        [_rightbutton setTitle:btnText forState:UIControlStateNormal];
        _rightbutton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_rightbutton setTitleColor:[UIColor colorWithHex:0xffb400] forState:UIControlStateNormal];
//        [_rightbutton setTitleColor:[UIColor colorWithHex:0xffb410] forState:UIControlStateHighlighted];
        [_rightbutton addTarget:self action:@selector(rightButtonToTurnBack) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:_rightbutton];
        
    }else if (tagValue == 104){
        self.leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftbutton.frame = CGRectMake(0, 20, 40, 40);
        self.leftbutton.contentMode = UIViewContentModeScaleToFill;
        [self.leftbutton setImage:[UIImage imageNamed:@"index_menu_ic"] forState:UIControlStateNormal];
        self.leftbutton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [self.leftbutton addTarget:self action:@selector(leftButtonToTurnBack) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:self.leftbutton];
        
    }
    if (isWhite == YES) {
        headerView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor blackColor];
        [self.leftbutton setImage:[UIImage imageNamed:@"back_dark_ic"] forState:UIControlStateNormal];
    }else{
        headerView.backgroundColor = YColorRGB(44, 54, 58);
        self.titleLabel.textColor = [UIColor whiteColor];
        if (tagValue != 104) {
            [self.leftbutton setImage:[UIImage imageNamed:@"back_ic"] forState:UIControlStateNormal];
        }

    }
    
}

#pragma mark - 左边按钮返回上一页面
-(void)leftButtonToTurnBack{
    NSLog(@"return");
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 右边按钮返回上一页面
-(void)rightButtonToTurnBack{
    NSLog(@"complete");
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)setupNetworkUnavailableWithTipMsg:(NSString *)msg title:(NSString *)title retryBtnTitle:(NSString *)retryBtnTitle{
    [self.noneNetworkView removeFromSuperview];
    self.noneNetworkView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, MainWidth, MainHeight - 64)];
    [self.view addSubview:self.noneNetworkView];
    self.noneNetworkView.backgroundColor = [UIColor colorWithHex:0xf1f1f1];
    float y = self.noneNetworkView.height/2 - 100;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((MainWidth-85)/2, y, 85, 85)];
    imageView.image = [UIImage imageNamed:@"share_fail_ic"];
    [self.noneNetworkView addSubview:imageView];
    y = y + 100;
    if (title != nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, y, MainWidth, 25)];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor colorWithHex:0xc3cacd];
        [self.noneNetworkView addSubview:label];
        y = y + 25;
    }
    
    UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, y , MainWidth, 25)];
    msgLabel.text = msg;
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.font = [UIFont systemFontOfSize:16];
    msgLabel.textColor = [UIColor colorWithHex:0xc3cacd];
    [self.noneNetworkView addSubview:msgLabel];
    
    y = y + 70;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(30, y, MainWidth - 60, 44)];
    button.backgroundColor = MainYellowColor;
    [button setTitle:retryBtnTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(retryToRefreshDataSuorce) forControlEvents:UIControlEventTouchUpInside];
    
    [self.noneNetworkView addSubview:button];
    
}
//点击重试
-(void)retryToRefreshDataSuorce{
    
}

#pragma mark - 去到登录界面
-(void)gotoLoginViewController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginViewController  *loginNavi = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [[YSHYSlideViewController shareInstance] GotoViewController:loginNavi];
}

#pragma mark - textfield获取圆角
+(void)textFiledGetCorner:(UITextField *)textFiled{
    textFiled.layer.cornerRadius = 5;
    textFiled.layer.masksToBounds = YES;
//    textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    textFiled.leftView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    textFiled.leftViewMode = UITextFieldViewModeAlways;
}

+(void)viewGetCornerRadius:(UIView *)view{
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
}


#pragma mark -网络异常
+(void)netWordIsDisconnected{
    dispatch_async(dispatch_get_main_queue(), ^{
        AKAlertView *alert = [[AKAlertView alloc]initWithIconName:@"" withTitle:LocalizedString(@"网络异常") withMessage:LocalizedString(@"网络连接失败，请检查网络是否正常！")];
        [alert addButton:ButtonTypeOK withTitle:LocalizedString(@"确定") handler:^(AKAlertViewItem *item) {
        }];
        [alert show];
    });

}
    
-(void)operateSucceedWithMessage:(NSString *)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        TipsView *alert = [[TipsView alloc]initWithIconName:@"password_success_ic" withTitle:message withMessage:nil];
      
        [alert show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismiss];
        });
    });
}
-(void)operateErrorWithMessage:(NSString *)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        TipsView *alert = [[TipsView alloc]initWithIconName:@"password_fail_ic" withTitle:nil withMessage:message];
        [alert show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismiss];
        });
    });
}

#pragma mark - 显示alert
-(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message sureBtnTitle:(NSString *)sureBtnTitle cancelBtnTitle:(NSString *)cancelBtnTitle {
    dispatch_async(dispatch_get_main_queue(), ^{
        AKAlertView *alert = [[AKAlertView alloc]initWithIconName:@"" withTitle:title withMessage:message];
        if (cancelBtnTitle != nil) {
            [alert addButton:ButtonTypeCancel withTitle:cancelBtnTitle handler:^(AKAlertViewItem *item) {
            }];
        }

        [alert addButton:ButtonTypeOK withTitle:sureBtnTitle handler:^(AKAlertViewItem *item) {
            
        }];
        [alert show];
    });
}


#pragma mark - 浮层提示

/**
 *  显示只有文字的提示信息
 *
 *  @param message 提示信息 默认1s后消失
 */
- (void)showNoticeMessage:(NSString *)message{
    [self showNoticeMessage:message hideAfterDelay:1];
}

/**
 *  显示只有文字的提示信息
 *
 *  @param message 提示信息
 *  @param delay   几秒后消失
 */
- (void)showNoticeMessage:(NSString *)message hideAfterDelay:(NSTimeInterval)delay{
    [self showHubWithImageName:@"" WithMessage:message hideAfterDelay:delay];
}


#pragma mark - 显示正在等待的提示
/**
 *  等待的提示信息
 *
 *  @param view    要显示在上面的view
 *  @param message 消息
 *
 *  @return hud
 */
-(MBProgressHUD *)showWaitingHudToView:(UIView *)view WithMessage:(NSString *)message{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    // Set the custom view mode to show any view.
    UIImage *image = [UIImage imageNamed:@"icon_start_loading_orange"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    anima.toValue = @(M_PI*2);
    anima.duration = 1.0f;
    anima.repeatCount = MAXFLOAT;
    anima.removedOnCompletion = NO;
    [imgView.layer addAnimation:anima forKey:nil];
    hud.customView = imgView;
    
    hud.label.text = message;
    
    hud.label.font = [UIFont systemFontOfSize:18];
    hud.label.numberOfLines = 0;
    hud.label.textColor = [UIColor blackColor];
    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    hud.bezelView.color = [UIColor colorWithHex:0xffffff];
    return hud;
}

#pragma mark - 显示失败信息
/**
 *  错误提示 1秒后自动消失
 *
 *  @param message       消息
 */
- (void)showErrorWithMessage:(NSString *)message{
    [self showErrorWithMessage:message hideAfterDelay:1];
}

/**
 *  错误、失败提示
 *
 *  @param message       消息
 *  @param detialMessage 详细消息
 *  @param time          几秒后消失
 */
- (void)showErrorWithMessage:(NSString *)message withDetialMessage:(NSString *)detialMessage hideAfterDelay:(NSTimeInterval)time{
    [self showHubWithImageName:@"" WithMessage:message andDetialMessage:detialMessage hideAfterDelay:time];
}

/**
 *  错误、失败提示
 *
 *  @param message       消息
 *  @param time          几秒后消失
 */
- (void)showErrorWithMessage:(NSString *)message  hideAfterDelay:(NSTimeInterval)time{
    [self showHubWithImageName:@"" WithMessage:message hideAfterDelay:time];
}

#pragma mark - 创建一个hud
- (void)showHubWithImageName:(NSString *)imageName WithMessage:(NSString *)message  hideAfterDelay:(NSTimeInterval)time{
    [self showHubWithImageName:imageName WithMessage:message andDetialMessage:nil hideAfterDelay:time];
}

- (void)showHubWithImageName:(NSString *)imageName WithMessage:(NSString *)message andDetialMessage:(NSString *)detialMessage hideAfterDelay:(NSTimeInterval)time{
    UIView *view = self.view;
    if (self.parentViewController) {
        view = self.parentViewController.view;
    }
    if (self.parentViewController.parentViewController) {
        view = self.parentViewController.parentViewController.view;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    if (imageName.length) {
        // Set an image view with a checkmark.
        UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        hud.backgroundColor = [UIColor whiteColor];
        hud.customView = [[UIImageView alloc] initWithImage:image];
    }
    
    // Looks a bit nicer if we make it square.
    hud.square = NO;
    // Optional label text.
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:20];
    hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    
    hud.label.numberOfLines = 0;
    hud.bezelView.color = [UIColor colorWithHex:0xf8f8f8];
    hud.label.textColor = [UIColor colorWithHex:0x4a4a4a];
    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    if (detialMessage.length) {
        hud.detailsLabel.text = detialMessage;
        hud.detailsLabel.textColor = [UIColor colorWithHex:0x4a4a4a];
    }
    hud.margin = 25;
    [hud hideAnimated:YES afterDelay:time];
}


@end
