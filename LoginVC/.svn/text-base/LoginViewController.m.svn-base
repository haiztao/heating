//
//  LoginViewController.m
//  heating
//
//  Created by haitao on 2017/2/7.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgotPswViewController.h"
#import "RegisterViewController.h"

#import "EmailRegisterViewController.h"
#import "EmailForgotPwdViewController.h"


#import "DeviceListViewController.h"
#import "YSHYSlideViewController.h"

#import "UserModel.h"
#import "XLinkExportObject.h"
#import "DeviceModel.h"
#import "DataManage.h"
@interface LoginViewController ()<UITextFieldDelegate>
{
    //登录线程
    NSThread    *_loginThread;
    //登录标识
    BOOL        _isLoginThreadRun;
    //
    MBProgressHUD *hud;
    BOOL isEmailAccount;
    NSString *lastTextContent;
    NSString *lastPwdContent;
}
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //邮箱或手机账号
    isEmailAccount = NO;
    
    [self setupUI];
    
    [self addNotification];

}

-(void)setupUI{

    self.accountTextField.delegate = self;
    self.accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.accountTextField.delegate = self;
    [BaseViewController textFiledGetCorner:self.accountTextField];
    [BaseViewController textFiledGetCorner:self.pswTextField];

    [BaseViewController viewGetCornerRadius:self.loginButton];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *lastLoginAccount = [[NSUserDefaults standardUserDefaults] objectForKey:LastLoginAccount];
    self.accountTextField.text = lastLoginAccount;
    
    //没有登录的情况下，不监听设备分享
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateDeviceList object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kKickout object:nil];
    
    
    if (self.accountTextField.text.length==0 || self.pswTextField.text.length==0) {
        self.loginButton.enabled = NO;
        self.loginButton.backgroundColor = MainGrayColor;
    }
    
    if (self.pswTextField.text.length>0) {
        self.showBtn.enabled = YES;
    }else{
        self.showBtn.enabled = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldsChanged) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 注册账号
- (IBAction)registerNewAccount:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *vc;
    if (isEmailAccount) {
    vc = (EmailRegisterViewController  *)[storyboard instantiateViewControllerWithIdentifier:@"EmailRegisterViewController"];
    }else{
      vc = (RegisterViewController  *)[storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    }
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 找回密码
- (IBAction)forgetPassword:(id)sender {
    //加载storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    
    UIViewController *vc;

    if (isEmailAccount) {
        vc = (EmailForgotPwdViewController *)[EmailForgotPwdViewController new];
    }else{
        vc = (ForgotPswViewController  *)[storyboard instantiateViewControllerWithIdentifier:@"ForgotPswViewController"];
    }
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)textFieldsChanged{

    if ( self.accountTextField.text.length > 0 && self.pswTextField.text.length > 0) {
        self.loginButton.enabled = YES;
        self.loginButton.backgroundColor = MainYellowColor;
    }else{
        self.loginButton.enabled = NO;
        self.loginButton.backgroundColor = MainGrayColor;
    }
    if (self.pswTextField.text.length>0) {
        self.showBtn.enabled = YES;
    }else{
        self.showBtn.enabled = NO;
    }
    if (self.accountTextField.text.length > 11)
    {//超出字节数，还是原来的内容
        self.accountTextField.text = lastTextContent;
    }else{
        lastTextContent = self.accountTextField.text;
    }
    
    if (self.pswTextField.text.length > 16) {
        self.pswTextField.text = lastPwdContent;
    }else{
        lastPwdContent = self.pswTextField.text;
    }
}

- (IBAction)showPassword:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.pswTextField.secureTextEntry = !self.pswTextField.secureTextEntry;

}

#pragma mark - 开始登录
- (IBAction)loginTheAccount:(UIButton *)sender {
    [self.view endEditing:YES];
    
    BOOL isPhone = [NSTools validatePhone:self.accountTextField.text];
    if (!isPhone) {
        [self showErrorWithMessage:NSLocalizedString(@"请输入正确手机号码", nil)];
        return;
    }
    if (self.pswTextField.text.length < 6) {
        [self showErrorWithMessage:NSLocalizedString(@"请输入6-16位字符密码", nil)];
        return;
    }
    BOOL isLegal = [NSTools validatePassword:self.pswTextField.text];
    if (!isLegal) {
        [self showErrorWithMessage:NSLocalizedString(@"密码不可包含特殊符号", nil)];
        return;
    }
    //网络
    if (![NSTools isConnectionAvailable]) {
        [self showErrorWithMessage:NSLocalizedString(@"请检查网络设置", nil)];
        return;
    }
    //登录
    [self checkUserData];

}


#pragma mark - private 用户登录
-(void)checkUserData{

    //开启自动登录线程
    [self startAutoLoginThread];
    //请求登录
    [self loginWithAccount:self.accountTextField.text Pwd:self.pswTextField.text isBackground:NO];
}
#pragma mark loginThread
-(void)startAutoLoginThread{
    if (!_loginThread) {
        //登录线程对象为空，就创建一个
        _isLoginThreadRun = YES;
        _loginThread = [[NSThread alloc] initWithTarget:self selector:@selector(autoLoginThreadRun) object:nil];
        [_loginThread start];
    }
}

-(void)loginWithAccount:(NSString *)account Pwd:(NSString *)pwd isBackground:(BOOL)isBackground{
    
    if (!isBackground) {
        //不是
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    //网络请求，用户认证
    [HttpRequest authWithAccount:account withPassword:pwd didLoadData:^(id result, NSError *err) {
        if (!err) {
            //网络请求回调结果里包括用户id和授权字符等
            NSDictionary *dic = result;
//            NSLog(@"括用户id和授权字 result %@",result);
            if (!DATASOURCE.userModel.account) {
                //为用户模型里没有
                //登录外网
                [[XLinkExportObject sharedObject] loginWithAppID:[[dic objectForKey:@"user_id"] intValue] andAuthStr:[dic objectForKey:@"authorize"]];
                //保存一份
                DATASOURCE.userModel = [[UserModel alloc] initWithAccount:account andPassword:pwd];
                
            }else{
                //有，就直接拿出来，登录
                [[XLinkExportObject sharedObject]loginWithAppID:DATASOURCE.userModel.userId.intValue andAuthStr:DATASOURCE.userModel.authorize];
             
            }
            //用户认证网络请求的回调result里的内容，存到当前用户模型
            DATASOURCE.userModel.accessToken = dic[@"access_token"];
            DATASOURCE.userModel.userId = dic[@"user_id"];
            DATASOURCE.userModel.authorize = dic[@"authorize"];
            
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"user_id"] forKey:@"userId"];
            //标记自动登录
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isAutoLogin];
            //最近一次登录的用户和密码
            [[NSUserDefaults standardUserDefaults] setObject:DATASOURCE.userModel.account forKey:LastLoginAccount];
            [[NSUserDefaults standardUserDefaults] setObject:DATASOURCE.userModel.password forKey:LastLoginPwd];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //获取当前用户模型中将要删除的设备
            NSArray *willDelDeviceModels = DATASOURCE.userModel.willDelDeviceModel;
            for (DeviceModel *deviceModel in willDelDeviceModels) {
                //遍历，发送网络请求，逐一取消订阅
                [HttpRequest unsubscribeDeviceWithUserID:DATASOURCE.userModel.userId withAccessToken:DATASOURCE.userModel.accessToken withDeviceID:@(deviceModel.device.deviceID) didLoadData:^(id result, NSError *err) {
                    if (!err) {
                        //请求不出错，就移除该设备
                        [DATASOURCE removeWillDelDeviceModel:deviceModel];
                        //NO表示本地更新用户信息而己
                        [DATASOURCE saveUserWithIsUpload:NO];
                    }else if (err.code == 4001034){
                        //用户没有订阅此设备(已删除)
                        [DATASOURCE removeWillDelDeviceModel:deviceModel];
                        [DATASOURCE saveUserWithIsUpload:NO];
                    }
                }];
            }
            //启动数据管理服务，监听，定时尝试连接等
            [[DataManage share] start];
            
            [DATASOURCE saveUserWithIsUpload:NO];
            
            if (isBackground) {
                //获取用户信息
                [self performSelector:@selector(getUserInfoWithDic:) onThread:_loginThread withObject:@{                                              @"isBackground" : @(1)                                                                                                          } waitUntilDone:NO];
                //获取用户扩展属性
                [self performSelector:@selector(getUserPropertyWithDic:) onThread:_loginThread withObject:@{                                                   @"isBackground" : @(1)                                                             } waitUntilDone:NO];
                //获取设备列表
                [self performSelector:@selector(getDeviceListWithDic:) onThread:_loginThread withObject:@{                                                @"isBackground" : @(1)                                                                                                             } waitUntilDone:NO];
            }else{
                //不是后台登录，标记为0
                [self performSelector:@selector(getUserInfoWithDic:) onThread:_loginThread withObject:@{                                                              @"isBackground" : @(0)                                                       } waitUntilDone:NO];
            }
            //delay时间登录一次
            [self performSelector:@selector(delayCallLoginWithDic:) onThread:_loginThread withObject:@{                                                 @"delay" : @(30 * 60),                                                              @"account" : account,                                                           @"password" : pwd,                                                              @"isBackgroundLogin" : @(1)                                                        }waitUntilDone:NO];
            
        }else{
            //网络请求出错
            if (!isBackground) {
                //不是后台登录
                //移除MBHUD
                [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
                
                //显示出错的原因
                [self performSelectorOnMainThread:@selector(showLoginFailErr:) withObject:err waitUntilDone:NO];
                
            }else{
                
                if (err.code == 4001007) {
                    //账号或密码不正确
                    //清空当前用户模型里的密码
                    DATASOURCE.userModel.password = nil;
                    //本地保存改变
                    [DATASOURCE saveUserWithIsUpload:NO];
                    //标记非登录状态
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isAutoLogin];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    //回主线程显示界面
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self gotoLoginViewController];
                        [self showAlertViewWithTitle:NSLocalizedString(@"登录失败", nil) message:NSLocalizedString(@"账号或密码错误，请再次确认账号与密码的一致性！", nil) sureBtnTitle:NSLocalizedString(@"确定", nil) cancelBtnTitle:nil];
                        
                    });
                    //停止自动登录的子线程
                    [self stopAutoLoginThread];
                    //清空当前用户模型
                    DATASOURCE.userModel = nil;
                    
                    return ;
                }
                //请求出错的其他情况，20秒重连一次
                [self performSelector:@selector(delayCallLoginWithDic:) onThread:_loginThread withObject:@{
                                                                                                           @"delay" : @(20),
                                                                                                           @"account" : account,
                                                                                                           @"password" :pwd,
                                                                                                           @"isBackgroundLogin" : @(1)
                                                                                                           } waitUntilDone:NO];
            }
        }
    }];
}


#pragma mark - 停止自动登录
-(void)stopAutoLoginThread{
    [self performSelector:@selector(callStopAutoLoginThread) onThread:_loginThread withObject:nil waitUntilDone:NO];
}

-(void)callStopAutoLoginThread{
    _isLoginThreadRun = NO;
}


-(void)autoLoginThreadRun{
    //子线程是不会自动运行的，把登录线程运行起来
    //当前程线，刚刚创建了
    [[NSThread currentThread] setName:@"Auto Auth Thread"];
    //distantFuture需要一个比较长的时间，就从现在开始到未来的某一天，重复执行
    [NSTimer scheduledTimerWithTimeInterval:[[NSDate distantFuture] timeIntervalSinceNow] target:self selector:@selector(__run) userInfo:nil repeats:YES];
    while (_isLoginThreadRun) {
        //阻塞在指定模式下的输入，直到给定的日期
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    _loginThread = nil;
}

-(void)__run{
    
}
#pragma mark -自动登录
-(void)AutoLogin{
    
    [self addNotification];
    
    [self startAutoLoginThread];
    
    if (!DATASOURCE.userModel.account) {
        
        [[DataManage share] start];
        NSString *lastLoginAccount = [[NSUserDefaults standardUserDefaults] objectForKey:LastLoginAccount];
        NSString *lastAccountPwd = [[NSUserDefaults standardUserDefaults] objectForKey:LastLoginPwd];
        
        [self performSelector:@selector(loginWithDic:) onThread:_loginThread withObject:@{                                              @"account" : lastLoginAccount,                                @"password" : lastAccountPwd,                             @"isBackgroundLogin" : @(1)                                              } waitUntilDone:NO];
    }

}

-(void)loginWithDic:(NSDictionary *)dic{
    NSString *account = dic[@"account"];
    NSString *password = dic[@"password"];
    NSNumber *isBackground = dic[@"isBackgroundLogin"];
    [self loginWithAccount:account Pwd:password isBackground:isBackground.boolValue];
}

#pragma mark Notification
//添加通知监听
-(void)addNotification{

    //登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogin:) name:kOnLogin object:nil];
    //退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOut) name:kLogout object:nil];
    
    //分享设备
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDeviceListIsBackground:) name:kGetShareDevice object:nil];

}
#pragma mark - 网络请求设备
-(void)getDeviceListIsBackground:(BOOL)isBackground{
    
    [HttpRequest getDeviceListWithUserID:DATASOURCE.userModel.userId withAccessToken:DATASOURCE.userModel.accessToken withVersion:@(0) didLoadData:^(id result, NSError *err) {
        if (!err) {
            //得到了云端的设备
            NSArray *deviceList = [result objectForKey:@"list"];
            NSLog(@"云端 deviceList %@", deviceList);

            //  往本地，添加云端存在，本地没有的设备
            for (NSDictionary *deviceDic in deviceList) {
                //遍历云端设备
                NSString *mac = [deviceDic objectForKey:@"mac"];
                DeviceModel * deviceModel = [[DeviceModel alloc]initWithDictionary:deviceDic];
                //创建实体
                DeviceEntity *deviceEntity = [[DeviceEntity alloc] initWithMac:mac andProductID:[deviceDic objectForKey:@"product_id"]];
                deviceEntity.accessKey = [deviceDic objectForKey:@"access_key"];
                deviceEntity.version = [[deviceDic objectForKey:@"firmware_version"] intValue];
                deviceEntity.deviceID = [[deviceDic objectForKey:@"id"] intValue];
                

                deviceModel.device = deviceEntity;
                deviceModel.isSubscription = @(1);
                
                //发送通知,添加设备
                [[NSNotificationCenter defaultCenter] postNotificationName:kAddDevice object:deviceModel];
            
            }

            if (!isBackground) {
                [self performSelectorOnMainThread:@selector(goIndexController) withObject:nil waitUntilDone:YES];
            }
            
        }else{
            
            if (!isBackground) {
                [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
                [self performSelectorOnMainThread:@selector(showLoginFailErr:) withObject:err waitUntilDone:NO];
            }else{
                [self performSelector:@selector(delayCallGetDeviceListWithDic:) onThread:_loginThread withObject:@{
                                                                                                                   @"delay" : @(20),
                                                                                                                   @"isBackground" : @(1)
                                                                                                                   } waitUntilDone:NO];
            }
        }
    }];
}

-(DeviceModel *)getDeviceModelWithMac:(NSString *)mac{
    NSArray *deviceModels = DATASOURCE.userModel.deviceModel;
    for (DeviceModel *deviceModel in deviceModels) {
        NSLog(@"deviceModels本地列表 ：%@",[deviceModel.device getMacAddressSimple]);
        if ([mac isEqualToString:[deviceModel.device getMacAddressSimple]]) {
            return deviceModel;
        }
    }
    return nil;
}

#pragma mark getUserInfo
-(void)delayCallGetUserInfoWithDic:(NSDictionary *)dic{
    
    NSNumber *delay = dic[@"delay"];
    [self performSelector:@selector(getUserInfoWithDic:) withObject:dic afterDelay:delay.doubleValue];
}

-(void)getUserInfoWithDic:(NSDictionary *)dic{
    
    NSNumber *isBackground = dic[@"isBackground"];
    [self getUserInfoIsBackground:isBackground.boolValue];
}


- (void)getUserInfoIsBackground:(BOOL)isBackground{
    //根据用户ID获取用户信息
    [HttpRequest getUserInfoWithUserID:DATASOURCE.userModel.userId withAccessToken:DATASOURCE.userModel.accessToken didLoadData:^(id result, NSError *err) {
        if (!err) {
            NSDictionary *dic = result;
            NSLog(@"根据用户ID获取用户信息 %@",dic);
            //请求没有出错，就
            DATASOURCE.userModel.nickName = dic[@"nickname"];
            DATASOURCE.userModel.avatarUrl = dic[@"avatar"];
            [DATASOURCE saveUserWithIsUpload:NO];
            
            if (!isBackground) {
                //不是后台，就获取用户扩展信息
                [self performSelector:@selector(getUserPropertyWithDic:) onThread:_loginThread withObject:@{@"isBackground" : @(0) } waitUntilDone:NO];
            }
        }else{
            //请求出错
            if (!isBackground) {
                //不是后台
                [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
                [self performSelectorOnMainThread:@selector(showLoginFailErr:) withObject:err waitUntilDone:NO];
            }else{
                [self performSelector:@selector(delayCallGetUserInfoWithDic:) onThread:_loginThread withObject:@{
                                                                                                                 @"delay" : @(20),
                                                                                                                 @"isBackground" : @(1)
                                                                                                                 } waitUntilDone:NO];
            }
        }
    }];
}

#pragma mark getUserProperty 用户扩展属性
-(void)delayCallGetUserPropertyWithDic:(NSDictionary *)dic{
    NSNumber *delay = dic[@"delay"];
    [self performSelector:@selector(getUserPropertyWithDic:) withObject:dic afterDelay:delay.doubleValue];
}

-(void)getUserPropertyWithDic:(NSDictionary *)dic{
    NSNumber *isBackground = dic[@"isBackground"];
    [self getUserPropertyIsBackground:isBackground.boolValue];
}

-(void)getUserPropertyIsBackground:(BOOL)isBackground{
    //获取用户扩展属性
    [HttpRequest getUserPropertyWithUserID:DATASOURCE.userModel.userId withAccessToken:DATASOURCE.userModel.accessToken didLoadData:^(id result, NSError *err) {
        if (!err) {
            NSLog(@"获取用户扩展属性 %@", result);
            //如果用户扩展属性 为空
            if ([result count] == 0 ) {
                [self setUserProperty];
            }
            //产品专有的扩展属性
            [DATASOURCE.userModel setWeichengProperty:[result objectForKey:@"weichengProperty"]];
            
            NSString *deviceToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceToken"];
            NSLog(@"deviceToken %@",deviceToken);
            if (deviceToken) {
                if (DATASOURCE.userModel.pushEnable) {
                    //用户注册APN服务
                    [HttpRequest registerAPNServiceWithUserID:DATASOURCE.userModel.userId withDeviceToken:deviceToken  withAccessToken:DATASOURCE.userModel.accessToken didLoadData:^(id result, NSError *err) {
                        if (!err) {
                            NSLog(@"APNS注册成功 result %@",result);
                        }else{
                            NSLog(@"APNS注册失败 err %@",err);
                        }
                    }];
                    
                }else{
                    
                    //用户停止APN服务
                    [HttpRequest disableAPNServiceWithUserID:DATASOURCE.userModel.userId withAppID:APN_APP_ID withAccessToken:deviceToken didLoadData:^(id result, NSError *err) {
                        if (!err) {
                            NSLog(@"停止 APNS推送 %@",result);
                        }else{
                            NSLog(@"停止失败 %@",err);
                        }
                    }];
                }
            }
            //发送更新用户属性 和设备列表更新的 通知

            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDeviceList object:nil];
            
            if (!isBackground) {
                [self performSelector:@selector(getDeviceListWithDic:) onThread:_loginThread withObject:@{@"isBackground" : @(0)} waitUntilDone:NO];
            }
            
        }else{
            if (err.code == 4041011) {
                NSLog(@"新用户，没有设置过property");
                //新用户，没有设置过property
                [self setUserProperty];
            }else if (!isBackground) {
                [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
                [self performSelectorOnMainThread:@selector(showLoginFailErr:) withObject:err waitUntilDone:NO];
            }else{
                [self performSelector:@selector(delayCallGetUserPropertyWithDic:) onThread:_loginThread withObject:@{
                                                                                                                     @"delay" : @(20),
                                                                                                                     @"isBackground" : @(1)
                                                                                                                     } waitUntilDone:NO];
            }
        }
    }];
}
#pragma mark - 设置用户扩展属性
-(void)setUserProperty{
    //设置用户扩展属性
    DATASOURCE.userModel.uploadTime = @([[NSDate date] timeIntervalSince1970]).stringValue;
    DATASOURCE.userModel.isExperience = @(1);
    DATASOURCE.userModel.pushEnable = @(1);
    
    NSDictionary *userDictionary = [DATASOURCE.userModel getDictionary];
    
    NSDictionary *weichengPropertyDic = @{@"weichengProperty" : [userDictionary objectForKey:@"weichengProperty"]};
    //上传
    [HttpRequest setUserPropertyDictionary:weichengPropertyDic withUserID:DATASOURCE.userModel.userId withAccessToken:DATASOURCE.userModel.accessToken didLoadData:^(id result, NSError *err) {
        if (!err) {
            [self performSelector:@selector(getDeviceListWithDic:) onThread:_loginThread withObject:@{
                                                                                                      @"isBackground" : @(0)
                                                                                                      } waitUntilDone:NO];
        }else{
            [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(showLoginFailErr:) withObject:err waitUntilDone:NO];
        }
    }];
}
#pragma mark - 获取设备列表
-(void)getDeviceListWithDic:(NSDictionary *)dic{
    NSNumber *isBackground = dic[@"isBackground"];
    [self getDeviceListIsBackground:isBackground.boolValue];
}

-(void)delayCallLoginWithDic:(NSDictionary *)dic{
    NSNumber *delay = dic[@"delay"];
    [self performSelector:@selector(loginWithDic:) withObject:dic afterDelay:delay.doubleValue];
}
-(void)delayCallGetDeviceListWithDic:(NSDictionary *)dic{
    NSNumber *delay = dic[@"delay"];
    [self performSelector:@selector(getDeviceListWithDic:) withObject:dic afterDelay:delay.doubleValue];
}
#pragma mark - 登录失败
-(void)showLoginFailErr:(NSError *)err{
    NSString *errStr;
    NSString *titleStr = LocalizedString(@"登录失败");
    NSString *accStr = [NSString stringWithFormat:@"%@", self.accountTextField.text];
    if (err.code==4041011) {
        if ([NSTools validatePhone:self.accountTextField.text]) {
            errStr = NSLocalizedString(@"该手机号未注册，请注册后登录", nil);
        }else{
            errStr = [NSString stringWithFormat: NSLocalizedString(@"邮箱%@暂未注册，请注册再登录！",nil),accStr];
        }
        
    }else if (err.code == 4001007) {
        errStr = LocalizedString(@"账号或密码错误");
        
    }else if(err.code == 4001061){
        errStr = LocalizedString(@"密码错误次数超过上限，请稍后重试!");
        
    }else if (err.code == 4001008) {
        errStr = [NSString stringWithFormat:@"邮箱%@暂未激活，请激活再登录！",accStr];
        
    }else{
        titleStr = LocalizedString(@"网络异常");
        errStr = LocalizedString(@"请检查网络设置");
    }
    [self showErrorWithMessage:errStr];
    
    
    //停止自动登录线程
    [self stopAutoLoginThread];
    DATASOURCE.userModel = nil;
}

#pragma mark - 退出登录
-(void)logOut{
    
    [[XLinkExportObject sharedObject] logout];
    [[DataManage share]stop];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isAutoLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self stopAutoLoginThread];
    
    DATASOURCE.userModel = nil;
    
    return;
}

#pragma mark -成功登录
-(void)goIndexController{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    DeviceListViewController  *loginNavi = [storyboard instantiateViewControllerWithIdentifier:@"DeviceListViewController"];
    [[YSHYSlideViewController shareInstance] GotoViewController:loginNavi];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
