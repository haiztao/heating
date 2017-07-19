//
//  ForgotPswViewController.m
//  heating
//
//  Created by haitao on 2017/2/7.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "ForgotPswViewController.h"
#import "ForgotPwdAndResetViewController.h"


@interface ForgotPswViewController ()<UITextFieldDelegate>
{
    NSInteger countDownValue;
    NSTimer *codeTimer;
    MBProgressHUD *hud;
    NSString *lastTextContent;
    
}
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *checkPwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *checkCodeBtn;//手机注册版本独有
@property (weak, nonatomic) IBOutlet UITextField *imageCheckTextField;
@property (weak, nonatomic) IBOutlet UIButton *imageCheckBtn;
@property (weak, nonatomic) IBOutlet UIView *imageCheckLine;
@property (nonatomic,strong) NSString *verityCode;
@end

@implementation ForgotPswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = YColorRGB(239, 239, 244);
    [self initUIWithTag:103 headerColorIsWhite:NO andTitle:LocalizedString(@"忘记密码") rightBtnText:LocalizedString(@"下一步")];

    //手机注册版
    [self setupMyView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldsChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
}

-(void)setupMyView{
    [BaseViewController viewGetCornerRadius:self.checkCodeBtn];
    
    [BaseViewController textFiledGetCorner:self.accountTextField];
    [BaseViewController textFiledGetCorner:self.checkPwdTextField];
    
    [BaseViewController textFiledGetCorner:self.imageCheckTextField];
    
    self.accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.accountTextField.delegate = self;
    self.checkPwdTextField.delegate = self;
    self.imageCheckTextField.delegate = self;
    self.imageCheckTextField.hidden = YES;
    self.imageCheckBtn.hidden = YES;
    self.imageCheckLine.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    countDownValue = 0;
    [self.checkCodeBtn setTitle:NSLocalizedString(@"获取验证码",nil) forState:UIControlStateNormal];
    if (self.accountTextField.text.length==0 || self.checkPwdTextField.text.length==0 ) {
        self.rightbutton.enabled = NO;
        [self.rightbutton setTitleColor:[UIColor colorWithHex:0x82662c] forState:UIControlStateNormal];
    }
    if (self.accountTextField.text.length==0 ){
        self.checkCodeBtn.enabled = NO;
        self.checkCodeBtn.backgroundColor = MainGrayColor;
    }
}
-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [codeTimer invalidate];
    codeTimer = nil;
}
-(void)textFieldsChanged {
    
    if (self.accountTextField.text.length > 11)
    {//超出字节数，还是原来的内容
        self.accountTextField.text = lastTextContent;
    }else{
        lastTextContent = self.accountTextField.text;
    }
    Boolean isPhone = [NSTools validatePhone:self.accountTextField.text];
    
    if (isPhone && countDownValue==0) {
        self.checkCodeBtn.enabled = YES;
    }else{
        self.checkCodeBtn.enabled = NO;
    }
    if (self.accountTextField.text.length > 0) {
        self.checkCodeBtn.enabled = YES;
        self.checkCodeBtn.backgroundColor = MainYellowColor;
    }else{
        self.checkCodeBtn.enabled = NO;
        self.checkCodeBtn.backgroundColor = MainGrayColor;
    }
    
    
    if (self.accountTextField.text.length>0 || self.checkPwdTextField.text.length>0 ) {
        self.rightbutton.enabled = YES;
        [self.rightbutton setTitleColor:MainYellowColor forState:UIControlStateNormal];
    }else{
        self.rightbutton.enabled = NO;
        [self.rightbutton setTitleColor:[UIColor colorWithHex:0x82662c] forState:UIControlStateNormal];
    }
}
#pragma mark - 右边按钮完成
-(void)rightButtonToTurnBack{
    [self.view endEditing:YES];
    Boolean isPhone = [NSTools validatePhone:self.accountTextField.text];
    if (!isPhone) {
        [self showErrorWithMessage:NSLocalizedString(@"请输入正确手机号码", nil)];
        return;
    }
    if (self.checkPwdTextField.text.length != 6) {
        [self showErrorWithMessage:NSLocalizedString(@"验证码有误，请重新输入", nil)];
        return;
    }
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest checkTheVerityCodeWithPhoneNumber:self.accountTextField.text code:self.checkPwdTextField.text didLoadData:^(id result, NSError *err) {
        NSLog(@"result 验证码 %@",result);
        
        //移除HUD
        [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
        
        if (!err) {
            self.verityCode = [result objectForKey:@"verifycode"];
            [self performSelectorOnMainThread:@selector(successAction) withObject:err waitUntilDone:NO];
        }else{
            [self performSelectorOnMainThread:@selector(failAction:) withObject:err waitUntilDone:NO];
        }
    }];
    
  
}
#pragma mark - 返回结果
-(void)successAction{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    ForgotPwdAndResetViewController  *vc = [storyboard instantiateViewControllerWithIdentifier:@"ForgotPwdAndResetViewController"];
    vc.phoneNumber = self.accountTextField.text;
    vc.checkCode = self.verityCode;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)failAction:(NSError *)err{
    
    NSString *errStr;
    NSString *titleStr = LocalizedString(@"重置失败");
    if (err.code==4001004) {
        errStr = LocalizedString(@"验证码有误，请重新输入");
        
    }else if(err.code==4001003 || err.code==4001005){
        errStr = LocalizedString(@"验证码有误，请重新输入");
        
    }else{
        titleStr = LocalizedString(@"网络异常");
        errStr = LocalizedString(@"网络连接失败，请检查网络是否正常！");
    }
    [self showErrorWithMessage:errStr];

    
    
}

#pragma mark - 获取验证码
- (IBAction)gainCheckCode:(UIButton *)sender {
    [self.view endEditing:YES];
    BOOL isPhone = [NSTools validatePhone:self.accountTextField.text];
    if (!isPhone) {
        [self showErrorWithMessage:NSLocalizedString(@"请输入正确手机号码", nil)];
        return;
    }
    //网络
    if (![NSTools isConnectionAvailable]) {
        [self showErrorWithMessage:NSLocalizedString(@"请检查网络设置", nil)];
        return;
    }
    //用户请求发送验证码
    [HttpRequest forgotPasswordWithAccount:self.accountTextField.text captcha:self.imageCheckTextField.text didLoadData:^(id result, NSError *err) {
         dispatch_async(dispatch_get_main_queue(), ^{
            if (!err) {
               
                self.checkCodeBtn.enabled = NO;
                countDownValue = 59;
                [codeTimer invalidate];
                codeTimer = nil;
                codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
            }else{
                NSLog(@"errorcode %ld",(long)err.code);
                if (err.code == 4001154) {
                    self.imageCheckTextField.hidden = NO;
                    self.imageCheckBtn.hidden = NO;
                    self.imageCheckLine.hidden = NO;
                    [self getImageCheckCode];
              
                }else if (err.code == 4001156){
                    [self getImageCheckCode];
                    [self showErrorWithMessage:NSLocalizedString(@"图片验证码有误，请重新输入", nil)];
                }else if (err.code == 4001155){
                    [self getImageCheckCode];
                    [self showErrorWithMessage:NSLocalizedString(@"图片验证码已失效,请点击图形码刷新", nil)];
                }
            }
        });
    }];
}
    
-(void)getImageCheckCode{
    [HttpRequest getPasswordImageVerifyCodeWithPhone:self.accountTextField.text didLoadData:^(id result, NSError *err) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!err) {
                NSString *url = [result objectForKey:@"url"];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
                [self.imageCheckBtn setBackgroundImage:image forState:UIControlStateNormal];
            }else{
//                [self showErrorWithMessage:NSLocalizedString(@"图形码输入有误", nil)];
            }
        });
    }];
}

- (IBAction)refreshImageCheckCode:(id)sender {
    [self getImageCheckCode];
}

-(void)countDown{
    if (countDownValue == 0) {
        self.checkCodeBtn.enabled = YES;
        [self.checkCodeBtn setTitle:NSLocalizedString(@"获取验证码",nil) forState:UIControlStateNormal];
        [codeTimer invalidate];
        return;
    }
    
    NSString *titleStr = [NSString stringWithFormat:@"%lds",(long)countDownValue];//NSLocalizedString(@"秒后重发",nil)
    [self.checkCodeBtn setTitle:titleStr forState:UIControlStateNormal];
    countDownValue--;
}

#pragma mark - 左边按钮返回上一页面
-(void)leftButtonToTurnBack{
    
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
