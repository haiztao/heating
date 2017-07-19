//
//  RenameDeviceViewController.m
//  heating
//
//  Created by haitao on 2017/2/14.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "RenameDeviceViewController.h"

@interface RenameDeviceViewController ()
{
    
    MBProgressHUD *hud;
    NSString *textContent;
}
@property (nonatomic,strong) UITextField *textFiled;

@end

@implementation RenameDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUIWithTag:103 headerColorIsWhite:NO andTitle:LocalizedString(@"重命名") rightBtnText:LocalizedString(@"完成")];
    self.titleLabel.text = self.titleString;
    self.textFiled = [[UITextField alloc]initWithFrame:CGRectMake(-2, 80, MainWidth + 4, 44)];
    self.textFiled.placeholder = self.deviceName;
    [self.view addSubview:self.textFiled];

    self.textFiled.layer.borderWidth = 1;
    self.textFiled.layer.borderColor = [UIColor colorWithHex:0xe9e9e9].CGColor;
    self.textFiled.leftView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, 17, 0)];
    self.textFiled.leftViewMode = UITextFieldViewModeAlways;
    self.textFiled.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithHex:0xebebeb];
    
    self.rightbutton.enabled = NO;
    [self.rightbutton setTitleColor:[UIColor colorWithHex:0x82662c] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldsChanged) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)textFieldsChanged {
    if (self.textFiled.text.length > 0) {
        self.rightbutton.enabled = YES;
        [self.rightbutton setTitleColor:MainYellowColor forState:UIControlStateNormal];
    }else{
        self.rightbutton.enabled = NO;
        [self.rightbutton setTitleColor:[UIColor colorWithHex:0x82662c] forState:UIControlStateNormal];
    }
    NSInteger limit = self.isAccountTurn ? 20 : 10 ;
    if (self.textFiled.text.length > limit) {
        self.textFiled.text = textContent;
    }else{
        textContent = self.textFiled.text;
    }
    
}
#pragma mark - 完成命名
-(void)rightButtonToTurnBack{
    [self.view endEditing:YES];
    if (self.textFiled.text.length == 0) {
        return;
    }
    if (![NSTools isChineseCharacterAndLettersAndNumbersAndUnderScore:self.textFiled.text]) {
         [self showErrorWithMessage:NSLocalizedString(@"请输入正确昵称", nil)];
        return;
    }
    if (_isAccountTurn) {
        if (self.textFiled.text.length < 3 || self.textFiled.text.length > 21 ) {
            [self showErrorWithMessage:NSLocalizedString(@"请输入3-20位字符昵称", nil)];
            return;
        }
    }
    if (![NSTools isChineseCharacterAndLettersAndNumbersAndUnderScore:self.textFiled.text]) {
        [self showErrorWithMessage:NSLocalizedString(@"请输入正确昵称", nil)];
        return;
    }
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    if (self.isAccountTurn) {//修改用户昵称
        [HttpRequest modifyAccountNickname:self.textFiled.text withUserID:DATASOURCE.userModel.userId withAccessToken:DATASOURCE.userModel.accessToken didLoadData:^(id result, NSError *err) {
            [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
            if (err) {
                [self performSelectorOnMainThread:@selector(modifyFail:) withObject:err waitUntilDone:NO];
            }else{
                [self performSelectorOnMainThread:@selector(modifySucceed) withObject:nil waitUntilDone:NO];
            }
        }];

    }else{//设备昵称
        
        NSDictionary * extenDic = [NSDictionary dictionaryWithObject:self.textFiled.text forKey:@"name"];
        [HttpRequest modifyDeviceInfoWithDeviceID:self.device.deviceID withInfoDic:extenDic withProductID:HeatingPID withAccessToken:DATASOURCE.userModel.accessToken didLoadData:^(id result, NSError *err) {
            [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
            if (err) {
                //add tips
                [self performSelectorOnMainThread:@selector(modifyFail:) withObject:err waitUntilDone:YES];
                return ;
            }else{
                
                [self performSelectorOnMainThread:@selector(modifySucceed) withObject:nil waitUntilDone:NO];
            }

        }];

    }
}

-(void)modifySucceed{


    if ([self.renameDelegate respondsToSelector:@selector(renameSucceedWithNickName:)]) {
        [self.renameDelegate renameSucceedWithNickName:self.textFiled.text];
    }
    
    if (self.isAccountTurn) {
        DATASOURCE.userModel.nickName = self.textFiled.text;

        [self operateSucceedWithMessage:NSLocalizedString(@"昵称修改成功", nil)];
    }else{

        [self operateSucceedWithMessage:NSLocalizedString(@"重命名成功", nil)];
        self.device.name = self.textFiled.text;
        for (int i = 0; i < DATASOURCE.userModel.deviceModel.count; i++) {
            DeviceModel *deviceModel = DATASOURCE.userModel.deviceModel[i];
            if ([self.device.deviceID integerValue] == [deviceModel.deviceID integerValue]) {
                [DATASOURCE.userModel.deviceModel replaceObjectAtIndex:i withObject:self.device];
            }
        }

    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });

}

- (void)modifyFail:(NSError *)err{
    if (self.isAccountTurn) {
        [self operateErrorWithMessage:LocalizedString(@"昵称修改失败")];
    }else{
        [self operateErrorWithMessage:LocalizedString(@"重命名失败，请重试！")];
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
