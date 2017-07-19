//
//  EmailRegisterSucceedViewController.m
//  heating
//
//  Created by haitao on 2017/2/10.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "EmailRegisterSucceedViewController.h"

@interface EmailRegisterSucceedViewController ()
{
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UILabel *sendEmailSucceedLabel;//邮件提示
@property (weak, nonatomic) IBOutlet UIButton *turnLoginBtn;//完成、返回登录
@property (weak, nonatomic) IBOutlet UIButton *reSendBtn;//重发邮件
@property (weak, nonatomic) IBOutlet UILabel *tipTitleLabel;//注册成功提示

@end

@implementation EmailRegisterSucceedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [BaseViewController viewGetCornerRadius:self.turnLoginBtn];
    
    [self setupUIView];
    

}

-(void)setupUIView{
    NSString *originStr = LocalizedString(@"重发邮件");
    NSDictionary *attrDict1 = @{
                                NSUnderlineColorAttributeName: MainYellowColor,
                                NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                NSFontAttributeName: [UIFont systemFontOfSize:16] };
    
    NSAttributedString * attStr = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict1];
    [self.reSendBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;//设置对齐方式
    //    paragraph.tailIndent = MainWidth - 80;//行尾缩进
    //  paragraph.firstLineHeadIndent = 30;//首行缩进
    NSDictionary *ats = @{
                          NSParagraphStyleAttributeName : paragraph,
                          };
    
    NSString *emailStr = @"";

    if (self.isRegister) {
        emailStr = [NSString stringWithFormat:@"%@ %@ %@",LocalizedString(@"我们向"),self.registerEmail,LocalizedString(@"发送了一封确认邮件，请点击邮件中的链接以完成账号激活。")];
        self.tipTitleLabel.text = LocalizedString(@"注册成功!");
        [self.turnLoginBtn setTitle:LocalizedString(@"返回登录") forState:UIControlStateNormal];
    }else{
        emailStr = [NSString stringWithFormat:@"%@\n%@",LocalizedString(@"一封找回密码的邮件已发送到您的邮箱"),self.registerEmail];
        self.tipTitleLabel.text = LocalizedString(@"发送成功!");
        [self.turnLoginBtn setTitle:LocalizedString(@"完成") forState:UIControlStateNormal];
    }

    self.sendEmailSucceedLabel.attributedText = [[NSMutableAttributedString alloc]initWithString:emailStr attributes:ats];
    
}


- (IBAction)resendEmail:(id)sender {
    
    //显示HUD
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (self.isRegister) {
        [self resendRegisterEmail];
    }else{
        [self resendForgotPasswordEmail];
    }
    
}
#pragma mark - 重发注册邮件
-(void)resendRegisterEmail{
    [HttpRequest registerWithAccount:self.registerEmail withNickname:self.nickName withVerifyCode:@"" withPassword:self.password didLoadData:^(id result, NSError *err) {
        //移除HUD
        [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
        
        if (err) {
            [self performSelectorOnMainThread:@selector(failAction:) withObject:err waitUntilDone:NO];
        }else{
            
            [self showAlertViewWithTitle:LocalizedString(@"重新发送成功") message:@""  sureBtnTitle:LocalizedString(@"确定") cancelBtnTitle:nil];
        }
    }];
}

#pragma mark - 重发忘记密码
-(void)resendForgotPasswordEmail{
    
    
    [HttpRequest forgotPasswordWithAccount:self.registerEmail captcha:nil didLoadData:^(id result, NSError *err) {
        //移除HUD
        [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
        
        if (!err) {
            [self showAlertViewWithTitle:LocalizedString(@"重新发送成功") message:@""  sureBtnTitle:LocalizedString(@"确定") cancelBtnTitle:nil];
            
        }
        else {
            [self showAlertViewWithTitle:LocalizedString(@"网络异常") message:LocalizedString(@"网络连接失败,请检查网络是否正常")    sureBtnTitle:LocalizedString(@"确定") cancelBtnTitle:nil];
        }
        
    }];

}

- (void)failAction:(NSError *)err{
    NSString *titleStr = LocalizedString(@"注册失败");
    NSString *errStr;
    NSString *accStr = [NSString stringWithFormat:@"%@", self.registerEmail];
    
    if (err.code==4001005) {
        errStr = [NSString stringWithFormat:@"%@%@%@",LocalizedString(@"该手机号"),accStr,LocalizedString(@"已注册，请直接登录！")];
        
    }else if(err.code==4001006){
        errStr = [NSString stringWithFormat:@"%@%@%@",LocalizedString(@"该邮箱"),accStr,LocalizedString(@"已注册，请直接登录！")];
    }else if (err.code == 4001003){
        errStr = LocalizedString(@"手机验证码不存在！");
        
    }else if(err.code == 4001004){
        errStr = LocalizedString(@"验证码错误，请输入正确的验证码！");
        
    }else{
        titleStr = LocalizedString(@"网络异常");
        errStr = LocalizedString(@"网络连接失败，请检查网络是否正常！");
    }
    [self showErrorWithMessage:errStr];
//    [self showAlertViewWithTitle:titleStr message:errStr sureBtnTitle:LocalizedString(@"确定") cancelBtnTitle:nil];
}


- (IBAction)turnToLogin:(id)sender {
    //改变登录页账号信息
    [[NSUserDefaults standardUserDefaults] setObject:self.registerEmail forKey:LastLoginAccount];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:LastLoginPwd];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self gotoLoginViewController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
