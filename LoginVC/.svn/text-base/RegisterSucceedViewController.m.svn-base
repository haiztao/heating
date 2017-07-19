//
//  RegisterSucceedViewController.m
//  heating
//
//  Created by haitao on 2017/2/8.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "RegisterSucceedViewController.h"

#import "DeviceListViewController.h"
#import "YSHYSlideViewController.h"

@interface RegisterSucceedViewController ()
@property (weak, nonatomic) IBOutlet UIButton *registerSucceedBtn;
@property (weak, nonatomic) IBOutlet UILabel *showPhonenumberLabel;

@end

@implementation RegisterSucceedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [BaseViewController viewGetCornerRadius:self.registerSucceedBtn];
    self.showPhonenumberLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"您的账号是：", nil),self.phoneNumber];
    
}

- (IBAction)registerSucceed:(UIButton *)sender {
    //用户认证(登录)
    [HttpRequest authWithAccount:self.phoneNumber withPassword:self.password didLoadData:^(id result, NSError *err) {
        if (!err) {
            //把认证成功的结果传过去
            [self performSelectorOnMainThread:@selector(loginSuccess:) withObject:result waitUntilDone:NO];
        }
    }];
    
}
#pragma mark - 注册成功 并登录
-(void)loginSuccess:(id)result{
    
    NSDictionary *dic = result;
    //密码保存到本地
    DATASOURCE.userModel = [[UserModel alloc]initWithAccount:self.phoneNumber andPassword:self.password];
    //认证成功的结果，保存到本地
    DATASOURCE.userModel.accessToken = dic[@"access_token"];
    DATASOURCE.userModel.userId = dic[@"user_id"];
    DATASOURCE.userModel.authorize = dic[@"authorize"];
    DATASOURCE.userModel.nickName = self.nickName;
    [DATASOURCE saveUserWithIsUpload:NO];
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *propertyDic = [NSMutableDictionary dictionary];
    
    [propertyDic setObject:@([[NSDate date] timeIntervalSince1970]).stringValue forKey:@"uploadTime"];
    
    [propertyDic setObject:@(1) forKey:@"isExperience"];
    [propertyDic setObject:@(1) forKey:@"pushEnable"];
    [tempDic setObject:propertyDic forKey:@"weichengProperty"];
    
    //网络请求设置扩展属性，就是上传tempDic
    [HttpRequest setUserPropertyDictionary:tempDic withUserID:DATASOURCE.userModel.userId withAccessToken:DATASOURCE.userModel.accessToken didLoadData:^(id result, NSError *err) {
        if (!err) {
            [self performSelectorOnMainThread:@selector(registerSuccess) withObject:nil waitUntilDone:NO];
        }else{
            
        }
    }];
}
#pragma mark - 跳转主界面
-(void)registerSuccess{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    DeviceListViewController  *loginNavi = [storyboard instantiateViewControllerWithIdentifier:@"DeviceListViewController"];
    [[YSHYSlideViewController shareInstance] GotoViewController:loginNavi];
    
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
