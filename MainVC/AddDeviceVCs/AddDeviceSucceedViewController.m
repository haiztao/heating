//
//  AddDeviceSucceedViewController.m
//  heating
//
//  Created by haitao on 2017/2/13.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "AddDeviceSucceedViewController.h"

@interface AddDeviceSucceedViewController ()
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;

@end

@implementation AddDeviceSucceedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [BaseViewController viewGetCornerRadius:self.completeBtn];

}
- (IBAction)completeAddDevice:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
