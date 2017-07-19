//
//  EmailRegisterViewController.m
//  heating
//
//  Created by haitao on 2017/2/10.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "EmailRegisterViewController.h"
#import "EmailRegisterSucceedViewController.h"
@interface EmailRegisterViewController ()<UITextFieldDelegate>
{
     MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;

@end

@implementation EmailRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUIview];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldsChanged) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)setupUIview{
    [BaseViewController textFiledGetCorner:self.accountTextField];
    [BaseViewController textFiledGetCorner:self.nickNameTextField];
    [BaseViewController textFiledGetCorner:self.pwdTextField];
    [BaseViewController viewGetCornerRadius:self.registerBtn];
    self.accountTextField.delegate = self;
    self.nickNameTextField.delegate = self;
    self.pwdTextField.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.registerBtn.enabled = NO;
    
    if (self.pwdTextField.text.length>0) {
        self.showBtn.enabled = YES;
    }else{
        self.showBtn.enabled = NO;
    }

}

#pragma mark Notification
-(void)textFieldsChanged{
    
    if (self.pwdTextField.text.length>0) {
        self.showBtn.enabled = YES;
    }else{
        self.showBtn.enabled = NO;
    }
    
    Boolean isEmail = [NSTools validateEmail:self.accountTextField.text];
    
    if (isEmail && (self.pwdTextField.text.length<21 && self.pwdTextField.text.length>5) ) {
        self.registerBtn.enabled = YES;
    }else{
        self.registerBtn.enabled = NO;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)showPassword:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.pwdTextField.secureTextEntry = !self.pwdTextField.secureTextEntry;
}
- (IBAction)registerEmailAccount:(UIButton *)sender {
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     [self registerWithEmail:self.accountTextField.text withNickname:self.nickNameTextField.text withPassword:self.pwdTextField.text];
}
- (void)registerWithEmail:(NSString *)account withNickname:(NSString *)nickname withPassword:(NSString *)pwd {
    
    //网络请求注册账号
    [HttpRequest registerWithAccount:account withNickname:nickname withVerifyCode:@"" withPassword:pwd didLoadData:^(id result, NSError *err) {
        //移除HUD
        [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
        
        if (!err) {
            [self performSelectorOnMainThread:@selector(successAction) withObject:err waitUntilDone:NO];
        }else{
            [self performSelectorOnMainThread:@selector(failAction:) withObject:err waitUntilDone:NO];
        }
    }];
}
#pragma mark - 注册成功
-(void)successAction{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    EmailRegisterSucceedViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"EmailRegisterSucceedViewController"];
    vc.registerEmail = self.accountTextField.text;
    vc.password = self.pwdTextField.text;
    vc.nickName = self.nickNameTextField.text;
    vc.isRegister = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)failAction:(NSError *)err{
    NSString *titleStr = LocalizedString(@"注册失败");
    NSString *errStr;
    NSString *accStr = [NSString stringWithFormat:@"%@", self.accountTextField.text];
    
    if (err.code==4001005) {
        errStr = [NSString stringWithFormat:@"%@%@%@",LocalizedString(@"该手机号"),accStr,LocalizedString(@"已注册，请直接登录！")];
        
    }else if(err.code==4001006){
        errStr = [NSString stringWithFormat:@"%@%@%@",LocalizedString(@"该邮箱"),accStr,LocalizedString(@"已注册，请直接登录！")];
    }else if (err.code == 4001003){
        errStr = LocalizedString(@"手机验证码不存在！");
        
    }else if(err.code == 4001004){
        errStr = LocalizedString(@"验证码错误，请输入正确的验证码！");
        
    }else if (err.code == 503){
        titleStr = LocalizedString(@"注册失败");
        errStr = LocalizedString(@"服务器发生异常");
    }
    else{
        titleStr = LocalizedString(@"网络异常");
        errStr = LocalizedString(@"网络连接失败，请检查网络是否正常！");
    }
    [self showErrorWithMessage:errStr];
//    [self showAlertViewWithTitle:titleStr message:errStr sureBtnTitle:LocalizedString(@"确定") cancelBtnTitle:nil];
}
- (IBAction)TurnBackToLogin:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//
//#pragma mark - Navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//
//    EmailRegisterSucceedViewController *vc = (EmailRegisterSucceedViewController *)[segue destinationViewController];
//    vc.registerEmail = @"abc@example.com";
//    
//}


@end
