//
//  ChangPasswordViewController.m
//  heating
//
//  Created by haitao on 2017/2/9.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "ChangPasswordViewController.h"

@interface ChangPasswordViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) UITextField *oldPwdTextFiled;
@property (nonatomic,strong) UITextField *pwdNewTextField;
@property (nonatomic,strong) UITextField *checkPwdTextField;

@end

@implementation ChangPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUIWithTag:103 headerColorIsWhite:NO andTitle:LocalizedString(@"修改密码") rightBtnText:LocalizedString(@"完成")];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    
    //tableView 添加单击手势，收起键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)];
    tap.numberOfTapsRequired = 1;
    [self.tableView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldsChanged) name:UITextFieldTextDidChangeNotification object:nil];
    self.rightbutton.enabled = NO;
    [self.rightbutton setTitleColor:[UIColor colorWithHex:0x82662c] forState:UIControlStateNormal];
}
-(void)singleTap{
    [self.view endEditing:YES];
}
-(void)textFieldsChanged{
    

    if (self.pwdNewTextField.text.length > 0 && self.checkPwdTextField.text.length > 0 && self.oldPwdTextFiled.text > 0) {
        self.rightbutton.enabled = YES;
        [self.rightbutton setTitleColor:MainYellowColor forState:UIControlStateNormal];
    }else{
        self.rightbutton.enabled = NO;
        [self.rightbutton setTitleColor:[UIColor colorWithHex:0x82662c] forState:UIControlStateNormal];
    }
}

-(BOOL)checkTextFiledIsRight:(UITextField *)textFiled{
    BOOL isRight = textFiled.text.length > 5 && textFiled.text.length < 16;
    return isRight;
}

//右边按钮返回上一页面
-(void)rightButtonToTurnBack{
    [self.view endEditing:YES];
    BOOL oldPwdRight = [self checkTextFiledIsRight:self.oldPwdTextFiled];
    BOOL isLegal = [NSTools validatePassword:self.oldPwdTextFiled.text];
    if (!oldPwdRight && isLegal) {
        [self showErrorWithMessage:NSLocalizedString(@"原密码错误，请重试！", nil)];
        return;
    }
    BOOL pwdNewRight = [self checkTextFiledIsRight:self.pwdNewTextField];
    isLegal = [NSTools validatePassword:self.pwdNewTextField.text];
    if (!pwdNewRight && isLegal) {
        [self showErrorWithMessage:NSLocalizedString(@"请输入6-16位新密码！", nil)];
        return;
    }
    if (![self.pwdNewTextField.text isEqualToString:self.checkPwdTextField.text]) {
        [self showErrorWithMessage:NSLocalizedString(@"两次输入的新密码不一致！", nil)];
        return;
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 
    [HttpRequest resetPasswordWithOldPassword:self.oldPwdTextFiled.text withNewPassword:self.pwdNewTextField.text withAccessToken:DATASOURCE.userModel.accessToken didLoadData:^(id result, NSError *err) {
        
        [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
        if (err) {
            [self performSelectorOnMainThread:@selector(modifyFail:) withObject:err waitUntilDone:NO];
        }else{
            [self performSelectorOnMainThread:@selector(modifySucceed) withObject:nil waitUntilDone:NO];
        }
    }];
    
}

-(void)modifySucceed{
    
    DATASOURCE.userModel.password = self.pwdNewTextField.text;
    [[NSUserDefaults standardUserDefaults] setObject:self.pwdNewTextField.text forKey:LastLoginPwd];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self operateSucceedWithMessage:NSLocalizedString(@"密码修改成功!", nil)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });

}

-(void)modifyFail:(NSError *)err{
    [self showErrorWithMessage:NSLocalizedString(@"密码修改失败，请重试！", nil) hideAfterDelay:2];
}

#pragma mark - tableView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 : 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"changePwdCell"];

    switch (indexPath.row) {
        case 0:
        {
            if (indexPath.section == 0) {
                self.oldPwdTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, MainWidth, 44)];
                [BaseViewController textFiledGetCorner:self.oldPwdTextFiled];
                self.oldPwdTextFiled.placeholder = LocalizedString(@"请输入旧密码");
                self.oldPwdTextFiled.delegate = self;
                self.oldPwdTextFiled.secureTextEntry = YES;
                [cell.contentView addSubview:self.oldPwdTextFiled];
            }else{
                self.pwdNewTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, MainWidth, 44)];
                [BaseViewController textFiledGetCorner:self.pwdNewTextField];
                self.pwdNewTextField.placeholder = LocalizedString(@"请输入新密码");
                self.pwdNewTextField.delegate = self;
                self.pwdNewTextField.secureTextEntry = YES;
                [cell.contentView addSubview:self.pwdNewTextField];
            }
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
            break;
        }
        default:
            break;
    }
    
    return cell;
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
