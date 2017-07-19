//
//  HTLeftMenuViewController.m
//  heating
//
//  Created by haitao on 2017/2/8.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "HTLeftMenuViewController.h"

#import "YSHYSlideViewController.h"

#import "AccountManageViewController.h"
#import "MessageViewController.h"
#import "DeviceShareViewController.h"
#import "UpdateFirmwareViewController.h"
#import "VersionViewController.h"

@interface HTLeftMenuViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *dataArray;
}
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation HTLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    dataArray = @[LocalizedString(@"账号管理"),LocalizedString(@"消息中心"),LocalizedString(@"设备分享"),LocalizedString(@"固件升级"),LocalizedString(@"版本信息")];

    CGFloat widthRation = kMenuWidth/(CGFloat)kScreenWidthFor6;
    float width = widthRation * kScreenWidth;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((width - 165) /2, 64, 165, 85)];
    imageView.image = [UIImage imageNamed:@"logo_pic"];
    [self.view addSubview:imageView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 164, width, MainHeight - 164)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    self.view.frame = CGRectMake(0, 0, width, MainHeight);
    self.view.backgroundColor = YColorRGB(44, 54, 58);
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.userInteractionEnabled = YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"leftCell"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];

    UIViewController *vc;
    switch (indexPath.row) {
        case 0:
        {
            
            vc = (AccountManageViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AccountManageViewController"];
            break;
        }
            case 1:
        {
            vc = (MessageViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
            break;
        }
        case 2:
        {
            vc = (DeviceShareViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DeviceShareViewController"];
            break;
        }
        case 3:
        {
            vc = (UpdateFirmwareViewController *)[storyboard instantiateViewControllerWithIdentifier:@"UpdateFirmwareViewController"];
            break;
        }
        case 4:
        {
            vc = (VersionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"VersionViewController"];
            break;
        }
        default:
            break;
    }
    if ([vc isKindOfClass:[UIViewController class]]) {
        [[YSHYSlideViewController shareInstance] GotoViewController:vc];
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
