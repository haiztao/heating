//
//  ConnectWLANViewController.m
//  heating
//
//  Created by haitao on 2017/2/13.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "ConnectWLANViewController.h"
#import "SearchDeviceViewController.h"

#import <SystemConfiguration/CaptiveNetwork.h>

//#import "HFSmartLink.h"
//#import "XLinkExportObject.h"
//#import "UserModel.h"

@interface ConnectWLANViewController ()



@property (weak, nonatomic) IBOutlet UIView *wlanView;
@property (weak, nonatomic) IBOutlet UILabel *wifiNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *wifiPwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UIButton *showPwdBtn;
@property (nonatomic,strong) NSString *ssid;

@end

@implementation ConnectWLANViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUIView];
    [self initUIWithTag:101 headerColorIsWhite:YES andTitle:LocalizedString(@"连接WLAN") rightBtnText:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeWLANSSID) name:ApplicationDidBecomeActive object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldsChanged) name:UITextFieldTextDidChangeNotification object:nil];
    [self textFieldsChanged];
}
#pragma mark Notification
-(void)textFieldsChanged{
    
    if (self.wifiPwdTextField.text.length>0) {
        self.showPwdBtn.enabled = YES;
    }else{
        self.showPwdBtn.enabled = NO;
    }
}



- (IBAction)showPassword:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.wifiPwdTextField.secureTextEntry = !self.wifiPwdTextField.secureTextEntry;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showWifiSsid];
    self.showPwdBtn.enabled = NO;
}

-(void)changeWLANSSID{
    [self showWifiSsid];
}

-(void)setupUIView{
    
    [BaseViewController viewGetCornerRadius:self.wlanView];
    [BaseViewController textFiledGetCorner:self.wifiPwdTextField];
    [BaseViewController viewGetCornerRadius:self.nextBtn];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (BOOL)acceptOnInterface:(NSString *)interface port:(UInt16)port error:(NSError **)errPtr{
    return YES;
}
- (void)showWifiSsid
{
    BOOL wifiOK= FALSE;
    NSDictionary *ifs;
    NSString *ssid;
    UIAlertView *alert;
    if (!wifiOK)
    {
        ifs = [self fetchSSIDInfo];
        ssid = [ifs objectForKey:@"SSID"];
        if (ssid != nil)
        {
            wifiOK= TRUE;
            self.wifiNameLabel.text = ssid;
            self.ssid = ssid;
        }
        else
        {
            alert= [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请打开WLAN并连接WiFi", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
            alert.delegate=self;
            [alert show];
        }
    }
}
//wifi信息
- (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return info;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark - 跳转下一界面
- (IBAction)gotoNextViewController:(id)sender {

    [self startComfigure];
    
}

-(void)startComfigure{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    SearchDeviceViewController *searchVC = [storyboard instantiateViewControllerWithIdentifier:@"SearchDeviceViewController"];
    searchVC.ssid = self.ssid;
    searchVC.wifiPassword = self.wifiPwdTextField.text;
    [self.navigationController pushViewController:searchVC animated:YES];
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
