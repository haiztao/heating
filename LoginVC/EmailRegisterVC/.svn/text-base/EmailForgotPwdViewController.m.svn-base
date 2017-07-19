//
//  EmailForgotPwdViewController.m
//  heating
//
//  Created by haitao on 2017/2/21.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "EmailForgotPwdViewController.h"
#import "EmailRegisterSucceedViewController.h"

@interface EmailForgotPwdViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    MBProgressHUD *hud;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITextField *accountTextField;
@end

@implementation EmailForgotPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUIWithTag:103 headerColorIsWhite:NO andTitle:LocalizedString(@"忘记密码") rightBtnText:LocalizedString(@"发送")];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, MainWidth, MainHeight - 64) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.rightbutton.userInteractionEnabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldsChanged) name:UITextFieldTextDidChangeNotification object:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)];
    tap.numberOfTapsRequired = 1;
    [self.tableView addGestureRecognizer:tap];
}
-(void)singleTap{
    [self.view endEditing:YES];
}

-(void)textFieldsChanged {
    Boolean isEmail = [NSTools validateEmail:self.accountTextField.text];
    if (isEmail) {
        self.rightbutton.userInteractionEnabled = YES;
    }else{
        self.rightbutton.userInteractionEnabled = NO;
    }
}

//右边按钮返回上一页面
-(void)rightButtonToTurnBack{
    
    [self.view endEditing:YES];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
    [HttpRequest forgotPasswordWithAccount:self.accountTextField.text captcha:nil  didLoadData:^(id result, NSError *err) {
        //移除HUD
        [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
        
        if (!err) {
            [self performSelectorOnMainThread:@selector(successAction) withObject:err waitUntilDone:NO];
            
        }
        else {
            [self showAlertViewWithTitle:LocalizedString(@"网络异常") message:LocalizedString(@"网络连接失败,请检查网络是否正常")    sureBtnTitle:LocalizedString(@"确定") cancelBtnTitle:nil];
        }

    }];
    
}
#pragma mark - 注册成功
-(void)successAction{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    EmailRegisterSucceedViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"EmailRegisterSucceedViewController"];
    vc.registerEmail = self.accountTextField.text;
    vc.isRegister = NO;
    [self.navigationController pushViewController:vc animated:YES];
    
}



#pragma mark - tableView Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EmailCell"];
    self.accountTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, MainWidth, 44)];
    self.accountTextField.delegate = self;
    [BaseViewController textFiledGetCorner:self.accountTextField];
    [cell.contentView addSubview:self.accountTextField];
    self.accountTextField.placeholder = LocalizedString(@"请输入邮箱地址");
    return cell;
    
}

#pragma mark - 头部视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainWidth, 80)];
    float x = 15;
    float y = 15;
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, MainWidth - 2 * x, 50)];
    tipLabel.text = LocalizedString(@"请输入您的注册邮箱，我们会将重设密码的链接发到您的邮箱中");
    tipLabel.font = [UIFont systemFontOfSize:16];
    tipLabel.textColor = YColorRGB(211, 211, 211);
    tipLabel.numberOfLines = 0;
    [view addSubview:tipLabel];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
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
