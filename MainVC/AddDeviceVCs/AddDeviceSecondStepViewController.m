//
//  AddDeviceSecondStepViewController.m
//  heating
//
//  Created by haitao on 2017/2/13.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "AddDeviceSecondStepViewController.h"
#import "ConnectWLANViewController.h"
@interface AddDeviceSecondStepViewController ()
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;

@end

@implementation AddDeviceSecondStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUIWithTag:101 headerColorIsWhite:YES andTitle:LocalizedString(@"连接空气能热水器") rightBtnText:nil];
    [BaseViewController viewGetCornerRadius:self.nextStepBtn];
    
}
- (IBAction)gotoConnectWlan:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    ConnectWLANViewController *wlanVC = [storyboard instantiateViewControllerWithIdentifier:@"ConnectWLANViewController"];
    [self.navigationController pushViewController:wlanVC animated:YES];
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
