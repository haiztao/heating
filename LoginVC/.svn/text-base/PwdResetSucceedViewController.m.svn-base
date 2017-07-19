//
//  PwdResetSucceedViewController.m
//  heating
//
//  Created by haitao on 2017/2/8.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "PwdResetSucceedViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface PwdResetSucceedViewController ()
@property (weak, nonatomic) IBOutlet UIButton *gotoLoginBtn;

@end

@implementation PwdResetSucceedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUIWithTag:100 headerColorIsWhite:NO andTitle:LocalizedString(@"重置密码") rightBtnText:nil];
    [BaseViewController viewGetCornerRadius:self.gotoLoginBtn];
}
- (IBAction)gotoLoginView:(id)sender {

    //改变登录页账号信息
    [[NSUserDefaults standardUserDefaults] setObject:self.account forKey:LastLoginAccount];
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
