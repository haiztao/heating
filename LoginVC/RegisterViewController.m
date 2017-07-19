//
//  RegisterViewController.m
//  heating
//
//  Created by haitao on 2017/2/7.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterSucceedViewController.h"
#import "UIButton+WebCache.h"
@interface RegisterViewController ()<UITextFieldDelegate>
{
    NSTimer *codeTimer;
    int countDownValue;
    NSString *lastTextContent;
    NSString *lastPwdContent;
    NSString *nickName;
    MBProgressHUD *hud;
   
}
@property (weak, nonatomic) IBOutlet UITextField *accountTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;

@property (weak, nonatomic) IBOutlet UITextField *ImageCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *imageCheckBtn;//图形验证码
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pwdConstraint;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    countDownValue = 0;
    [self setupUIView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldsChanged) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.accountTextFiled.text.length==0 || self.pwdTextFiled.text.length==0 || self.checkCodeTextField.text.length == 0 || self.nickNameTextFiled.text.length == 0) {
        self.registerBtn.enabled = NO;
        self.registerBtn.backgroundColor = [UIColor colorWithHex:0xbfbfbf];
    }
    if (self.pwdTextFiled.text.length>0) {
        self.showBtn.enabled = YES;
    }else{
        self.showBtn.enabled = NO;
    }
    [self.codeBtn setTitle:NSLocalizedString(@"获取验证码",nil) forState:UIControlStateNormal];
}

-(void)viewWillDisappear:(BOOL)animated{
    [codeTimer invalidate];
    codeTimer = nil;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setupUIView{
    [BaseViewController textFiledGetCorner:self.accountTextFiled];
    [BaseViewController textFiledGetCorner:self.checkCodeTextField];
    [BaseViewController textFiledGetCorner:self.pwdTextFiled];
    [BaseViewController textFiledGetCorner:self.nickNameTextFiled];
    [BaseViewController viewGetCornerRadius:self.codeBtn];
    [BaseViewController viewGetCornerRadius:self.registerBtn];
    
    //图形验证码
    [BaseViewController textFiledGetCorner:self.ImageCodeTextField];
    self.ImageCodeTextField.delegate = self;
    self.ImageCodeTextField.hidden = YES;
    self.imageCheckBtn.hidden = YES;
    self.pwdConstraint.constant = 10;
    
    self.codeBtn.layer.borderWidth = 0.5;
    [self.codeBtn setBackgroundColor:[UIColor whiteColor]];
    [self.codeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.codeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.codeBtn.enabled = NO;
    
    self.accountTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nickNameTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.accountTextFiled.delegate = self;
    self.pwdTextFiled.delegate = self;
    self.checkCodeTextField.delegate = self;
    self.nickNameTextFiled.delegate = self;
    
}

#pragma mark - 获取验证码
- (IBAction)gainTheCheckCode:(UIButton *)sender {
    [self.view endEditing:YES];
    BOOL isPhone = [NSTools validatePhone:self.accountTextFiled.text];
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
    [HttpRequest getVerifyCodeWithPhone:self.accountTextFiled.text captcha:self.ImageCodeTextField.text didLoadData:^(id result, NSError *err) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (err) {
                NSLog(@"注册errcode %ld",(long)err.code);
                if (err.code == 4001154) {
                    
                    self.pwdConstraint.constant = 64;
                    self.imageCheckBtn.hidden = NO;
                    self.ImageCodeTextField.hidden = NO;
                    [self getImageCheckCode];
                    
                }else if (err.code == 4001156){
                    [self getImageCheckCode];
                    [self showErrorWithMessage:NSLocalizedString(@"图片验证码有误，请重新输入", nil)];
                }else if (err.code == 4001155){
                    [self getImageCheckCode];
                    [self showErrorWithMessage:NSLocalizedString(@"图片验证码已失效,请点击图形码刷新", nil)];
                }
            }else{
             
                self.codeBtn.enabled = NO;
                [self.codeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                self.codeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
                countDownValue = 59;
                [codeTimer invalidate];
                codeTimer = nil;
                codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
                
            }
        });
    }];
    


}
//获取图形验证码
-(void)getImageCheckCode{
    [HttpRequest getImageVerifyCodeWithPhone:self.accountTextFiled.text didLoadData:^(id result, NSError *err) {
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

- (IBAction)retryToGetImageCheckCode:(UIButton *)sender {
    [self getImageCheckCode];
}

-(void)countDown{
    if (countDownValue == 0) {
        [codeTimer invalidate];
        
        self.codeBtn.enabled = YES;
        [self.codeBtn setTitle:NSLocalizedString(@"获取验证码",nil) forState:UIControlStateNormal];
        [self.codeBtn setTitleColor:[UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:1.00] forState:UIControlStateNormal];
        self.codeBtn.layer.borderColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:1.00].CGColor;
        return;
    }
    
    NSString *titleStr = [NSString stringWithFormat:@"%ds",countDownValue];
    [self.codeBtn setTitle:titleStr forState:UIControlStateNormal];
    countDownValue--;
}
#pragma mark - 进行注册
- (IBAction)registerAccount:(UIButton *)sender {
    [self.view endEditing:YES];
    
    BOOL isLegalNickName = [NSTools isChineseCharacterAndLettersAndNumbersAndUnderScore:self.nickNameTextFiled.text];
    if (!isLegalNickName) {
        [self showErrorWithMessage:NSLocalizedString(@"请输入正确昵称", nil)];
        return;
    }
    if (self.nickNameTextFiled.text.length < 3 || self.nickNameTextFiled.text.length > 20) {
        [self showErrorWithMessage:NSLocalizedString(@"请输入3-20位字符昵称", nil)];
        return;
    }
    BOOL isPhone = [NSTools validatePhone:self.accountTextFiled.text];
    if (!isPhone) {
        [self showErrorWithMessage:NSLocalizedString(@"请输入正确手机号码", nil)];
        return;
    }
    if (self.checkCodeTextField.text.length != 6) {
        [self showErrorWithMessage:NSLocalizedString(@"验证码有误，请重新输入", nil)];
        return;
    }
    if (self.pwdTextFiled.text.length < 6 || self.pwdTextFiled.text.length > 16) {
        [self showErrorWithMessage:NSLocalizedString(@"请输入6-16位字符密码", nil)];
        return;
    }

    BOOL isLegal = [NSTools validatePassword:self.pwdTextFiled.text];
    if (!isLegal) {
        [self showErrorWithMessage:NSLocalizedString(@"密码不可包含特殊符号", nil)];
        return;
    }
    //网络
    if (![NSTools isConnectionAvailable]) {
        [self showErrorWithMessage:NSLocalizedString(@"请检查网络设置", nil)];
        return;
    }

    
    [self registerWithPhone:self.accountTextFiled.text withNickname:self.nickNameTextFiled.text withPassword:self.pwdTextFiled.text codeStr:self.checkCodeTextField.text];
}



- (IBAction)turnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 显示密码
- (IBAction)showPassword:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.pwdTextFiled.secureTextEntry = !self.pwdTextFiled.secureTextEntry;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - 监听输入框内容
-(void)textFieldsChanged{
    
    if (self.pwdTextFiled.text.length>0) {
        self.showBtn.enabled = YES;
    }else{
        self.showBtn.enabled = NO;
    }
    
    if (self.accountTextFiled.text.length > 11)
    {//超出字节数，还是原来的内容
        self.accountTextFiled.text = lastTextContent;
    }else{
        lastTextContent = self.accountTextFiled.text;
    }
    
    if (self.pwdTextFiled.text.length > 16) {
        self.pwdTextFiled.text = lastPwdContent;
    }else{
        lastPwdContent = self.pwdTextFiled.text;
    }
    if (self.nickNameTextFiled.text.length > 20) {
        self.nickNameTextFiled.text = nickName;
    }else{
        nickName = self.nickNameTextFiled.text;
    }
    if (self.accountTextFiled.text.length>0 && self.pwdTextFiled.text.length>0 && self.checkCodeTextField.text.length>0 && self.nickNameTextFiled.text.length>0) {
        self.registerBtn.enabled = YES;
        self.registerBtn.backgroundColor = MainYellowColor;
    }else{
        self.registerBtn.enabled = NO;
        self.registerBtn.backgroundColor = [UIColor colorWithHex:0xbfbfbf];
    }
    
    if (self.accountTextFiled.text.length > 0) {
        self.codeBtn.enabled = YES;
        [self.codeBtn setTitleColor:[UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:1.00] forState:UIControlStateNormal];
        self.codeBtn.layer.borderColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:1.00].CGColor;
    }else{
        self.codeBtn.enabled = NO;
        [self.codeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.codeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([self.accountTextFiled isFirstResponder]) {
        [self.checkCodeTextField becomeFirstResponder];
        
    }else if([self.nickNameTextFiled isFirstResponder]){
        [self.accountTextFiled becomeFirstResponder];
        
    }
    else if([self.checkCodeTextField isFirstResponder]){
        [self.pwdTextFiled becomeFirstResponder];
        
    }else if ([self.pwdTextFiled isFirstResponder]) {
        [textField endEditing:YES];
    }
    
    return YES;
}


#pragma mark - private
- (void)registerWithPhone:(NSString *)account withNickname:(NSString *)nickname withPassword:(NSString *)pwd codeStr:(NSString *)code{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    //网络请求注册账号
    [HttpRequest registerWithAccount:account withNickname:nickname withVerifyCode:code withPassword:pwd didLoadData:^(id result, NSError *err) {
        //移除HUD
        [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
        
        if (!err) {
            [self performSelectorOnMainThread:@selector(successAction) withObject:nil waitUntilDone:NO];
        }else{
            NSLog(@"errcode %ld",err.code);
            [self performSelectorOnMainThread:@selector(failAction:) withObject:err waitUntilDone:NO];
            
        }
    }];
}
#pragma mark - 注册成功
-(void)successAction{
    
    [self.codeBtn setTitle:NSLocalizedString(@"获取验证码",nil) forState:UIControlStateNormal];
    [codeTimer invalidate];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    RegisterSucceedViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"RegisterSucceedViewController"];
    vc.phoneNumber = self.accountTextFiled.text;
    vc.password = self.pwdTextFiled.text;
    vc.nickName = self.nickNameTextFiled.text;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)failAction:(NSError *)err{

    NSString *errStr;
    NSString *accStr = [NSString stringWithFormat:@"%@", self.accountTextFiled.text];
    
    if (err.code==4001005) {
        errStr = LocalizedString(@"该手机号已被注册");
    }else if(err.code==4001006){
        errStr = [NSString stringWithFormat:@"%@%@%@",LocalizedString(@"该邮箱"),accStr,LocalizedString(@"已注册，请直接登录！")];
    }else if (err.code == 4001003){
        errStr = LocalizedString(@"手机验证码不存在！");
        
    }else if(err.code == 4001004){
        errStr = LocalizedString(@"验证码已超时，请重新输入！");
        
    }else{
        errStr = LocalizedString(@"请检查网络设置");
    }
    [self showErrorWithMessage:errStr];

    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == self.checkCodeTextField || textField == self.pwdTextFiled || textField == self.ImageCodeTextField) {
        // 添加对键盘的监控
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{

    if (textField == self.checkCodeTextField || textField == self.pwdTextFiled || textField == self.ImageCodeTextField) {
        // 添加对键盘的监控
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
}


#pragma mark - 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    if ([self.accountTextFiled isFirstResponder] || [self.nickNameTextFiled isFirstResponder]) {
        return;
    }
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect btnFrame = self.view.frame;
    float height = 0;
    if (MainHeight > 568) {
        height = 40;
    }else{
        height = 100;
    }
    btnFrame.origin.y = -height;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
    
    // set views with new info
    self.view.frame = btnFrame;
    // commit animations
    [UIView commitAnimations];
    
    
}

#pragma mark - 键盘即将隐藏
- (void)keyBoardWillHide:(NSNotification *) note {
    if ([self.accountTextFiled isFirstResponder]) {
        return;
    }
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect btnFrame = self.view.frame;

    btnFrame.origin.y = 0;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    self.view.frame = btnFrame;
    
    // commit animations
    [UIView commitAnimations];
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
