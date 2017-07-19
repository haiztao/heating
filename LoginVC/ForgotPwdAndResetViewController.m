//
//  ForgotPwdAndResetViewController.m
//  heating
//
//  Created by haitao on 2017/2/20.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "ForgotPwdAndResetViewController.h"
#import "PwdResetSucceedViewController.h"

@interface ForgotPwdAndResetViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    MBProgressHUD *hud;
    NSString *lastPwdContent;
    NSString *checkPwdContent;
    UIButton *showBtn;
    UIButton *showCheckPwdBtn;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UITextField *pwdNewTextField;
@property (nonatomic,strong) UITextField *checkPwdTextField;


@end

@implementation ForgotPwdAndResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    
    [self initUIWithTag:103 headerColorIsWhite:NO andTitle:LocalizedString(@"重置密码") rightBtnText:LocalizedString(@"完成")];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldsChanged) name:UITextFieldTextDidChangeNotification object:nil];
    //tableView 添加单击手势，收起键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)];
    tap.numberOfTapsRequired = 1;
    [self.tableView addGestureRecognizer:tap];
    
    if (self.pwdNewTextField.text.length==0 || self.checkPwdTextField.text.length==0 ) {
        self.rightbutton.enabled = NO;
        [self.rightbutton setTitleColor:[UIColor colorWithHex:0x82662c] forState:UIControlStateNormal];
    }
}
-(void)singleTap{
    [self.view endEditing:YES];
}

//右边按钮完成
-(void)rightButtonToTurnBack{
    [self.view endEditing:YES];
    
    if (self.pwdNewTextField.text.length < 6) {
        [self showErrorWithMessage:NSLocalizedString(@"请输入6-16位字符密码", nil)];
        return;
    }
    BOOL isLegal = [NSTools validatePassword:self.pwdNewTextField.text];
    if (!isLegal) {
        [self showErrorWithMessage:NSLocalizedString(@"密码不可包含特殊符号", nil)];
        return;
    }
    BOOL isSame = [self.pwdNewTextField.text isEqualToString:self.checkPwdTextField.text];

    if (self.checkPwdTextField.text.length < 6 || !isSame) {
        [self showErrorWithMessage:NSLocalizedString(@"两次输入的密码不一致，请重新输入", nil)];
        return;
    }

    //网络状态
    if (![NSTools isConnectionAvailable]) {
        [BaseViewController netWordIsDisconnected];
        return;
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest foundBackPasswordWithAccount:self.phoneNumber withVerifyCode:self.checkCode withNewPassword:self.pwdNewTextField.text didLoadData:^(id result, NSError *err) {
        
        [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
        
        if (!err) {
            [self performSelectorOnMainThread:@selector(successAction) withObject:nil waitUntilDone:NO];
        }else{
            [self performSelectorOnMainThread:@selector(failAction:) withObject:err waitUntilDone:NO];
        }
        
    }];


}
-(void)failAction:(NSError *)err{
    
    NSString *errStr;
    NSString *titleStr = LocalizedString(@"重置失败");
    if (err.code==4001004) {
        errStr = LocalizedString(@"验证码错误，请输入正确的验证码！");
        
    }else if(err.code==4001003 || err.code==4001005){
        errStr = LocalizedString(@"手机验证码不存在，请重新获取验证码！");
        
    }else{
        titleStr = LocalizedString(@"网络异常");
        errStr = LocalizedString(@"网络连接失败，请检查网络是否正常！");
    }
    [self showErrorWithMessage:errStr];

}


#pragma mark - 重置成功
-(void)successAction{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    PwdResetSucceedViewController  *vc = [storyboard instantiateViewControllerWithIdentifier:@"PwdResetSucceedViewController"];
    vc.account = self.phoneNumber;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)textFieldsChanged {
    if (self.pwdNewTextField.text.length > 16) {
        self.pwdNewTextField.text = lastPwdContent;
    }else{
        lastPwdContent = self.pwdNewTextField.text;
    }
    if (self.checkPwdTextField.text.length > 16) {
        self.checkPwdTextField.text = checkPwdContent;
    }else{
        checkPwdContent = self.checkPwdTextField.text;
    }
    if (self.pwdNewTextField.text.length>0 && self.checkPwdTextField.text.length>0 ) {
        self.rightbutton.enabled = YES;
        [self.rightbutton setTitleColor:MainYellowColor forState:UIControlStateNormal];
    }else{
        self.rightbutton.enabled = NO;
        [self.rightbutton setTitleColor:[UIColor colorWithHex:0x82662c] forState:UIControlStateNormal];
    }
}
#pragma mark - tableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"changePwdCell"];
    
    switch (indexPath.row) {
        case 0:
        {

            self.pwdNewTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, MainWidth, 44)];
                [BaseViewController textFiledGetCorner:self.pwdNewTextField];
            self.pwdNewTextField.placeholder = LocalizedString(@"请输入6-16字符的新密码");
            self.pwdNewTextField.delegate = self;
            self.pwdNewTextField.secureTextEntry = YES;
            [cell.contentView addSubview:self.pwdNewTextField];
            showBtn = [[UIButton alloc]initWithFrame:CGRectMake(MainWidth - 46, 0, 46, 44)];
            [showBtn setImage:[UIImage imageNamed:@"hide_ic.png"] forState:UIControlStateNormal];
            [showBtn addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:showBtn];
            break;
        }
        case 1:
        {
            self.checkPwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, MainWidth, 44)];
            [BaseViewController textFiledGetCorner:self.checkPwdTextField];
            self.checkPwdTextField.placeholder = LocalizedString(@"请确认新密码");
             self.checkPwdTextField.delegate = self;
            self.checkPwdTextField.secureTextEntry = YES;
            [cell.contentView addSubview:self.checkPwdTextField];
            showCheckPwdBtn = [[UIButton alloc]initWithFrame:CGRectMake(MainWidth - 46, 0, 46, 44)];
            [showCheckPwdBtn setImage:[UIImage imageNamed:@"hide_ic.png"] forState:UIControlStateNormal];
            [showCheckPwdBtn addTarget:self action:@selector(showCheckPassword:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:showCheckPwdBtn];
            break;
        }
        default:
            break;
    }
    
    return cell;
}
-(void)showCheckPassword:(UIButton *)button{
    button.selected = !button.selected;
   
    self.checkPwdTextField.secureTextEntry = !self.checkPwdTextField.secureTextEntry;
    
}
-(void)showPassword:(UIButton *)button{
    button.selected = !button.selected;
    
    self.pwdNewTextField.secureTextEntry = !self.pwdNewTextField.secureTextEntry;
    
}
    
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
//把tableView的线对齐
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
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
