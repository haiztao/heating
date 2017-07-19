//
//  DeviceShareViewController.m
//  heating
//
//  Created by haitao on 2017/2/9.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "DeviceShareViewController.h"
#import "ShareDetailViewController.h"
#import "DeviceModel.h"
#import "QRCodeViewController.h"

#import "RoleModel.h"

@interface DeviceShareViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *hud;
    int shareCount;
}
@property (weak, nonatomic) IBOutlet UIView *noneDeviceView;
    @property (weak, nonatomic) IBOutlet UIButton *addDeviceBtn;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *deviceArray;

@end

@implementation DeviceShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self initUIWithTag:102 headerColorIsWhite:NO andTitle:LocalizedString(@"设备分享") rightBtnText:nil];
    [self.rightbutton setImage:[UIImage imageNamed:@"scan_ic"] forState:UIControlStateNormal];
    [BaseViewController viewGetCornerRadius:self.addDeviceBtn];
    [self createTableView];

    [self judgeArrayCountAndChangeUI];

}

-(void)judgeArrayCountAndChangeUI{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.deviceArray.count == 0){
            self.noneDeviceView.hidden = NO;
            self.tableView.hidden = YES;
        }else{
            self.noneDeviceView.hidden = YES;
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }
    });
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getShareDeviceList];
}
    //添加新设备、作为管理员
- (IBAction)addNewManageDevice:(id)sender {
    QRCodeViewController *addDeviceVC = [QRCodeViewController new];
    addDeviceVC.isAddShareDevice = NO;
    [self.navigationController pushViewController:addDeviceVC animated:YES];
}

#pragma mark - 获取设备分享信息
-(void)getShareDeviceList{
    self.deviceArray = [NSMutableArray arrayWithArray:DATASOURCE.userModel.deviceModel];
    if (self.deviceArray.count == 0) {
        return;
    }
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    for (int i = 0; i<self.deviceArray.count; i++) {
        DeviceModel *deviceM = self.deviceArray[i];
        if ([deviceM.role intValue] == 0) {

            [HttpRequest getUserListWithDeviceID:deviceM.deviceID withUserID:DATASOURCE.userModel.userId withAccessToken:DATASOURCE.userModel.accessToken didLoadData:^(id result, NSError *err) {
                //移除HUD
                [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
                if (!err) {
                    NSArray *array = result[@"list"];
                    NSLog(@"分享 %@",array);
                    shareCount = 0;
                    for (NSDictionary *dict in array) {
                        RoleModel *roleModel = [[RoleModel alloc]initWithDict:dict];
                        BOOL masterIsSelf = [roleModel.from_id integerValue] == [DATASOURCE.userModel.userId integerValue] ? YES : NO;
                        if ([roleModel.role intValue] == 1 && masterIsSelf) {
                            shareCount += 1;
                            if ([roleModel.from_id integerValue] == [DATASOURCE.userModel.userId integerValue]) {
                                deviceM.role = @"0";
                            }
                        }
                    }
                    deviceM.shareCount = shareCount;
                    [self.deviceArray replaceObjectAtIndex:i withObject:deviceM];
                }
            }];

        }else{
            //移除HUD
            [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
            [self.deviceArray removeObject:deviceM];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //刷新界面
        [self judgeArrayCountAndChangeUI];
    });


}

-(void)createTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, MainWidth, MainHeight - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
}

#pragma mark - 扫描二维码
-(void)rightButtonToTurnBack{
    QRCodeViewController *addDeviceVC = [QRCodeViewController new];
    addDeviceVC.isAddShareDevice = YES;
    [self.navigationController pushViewController:addDeviceVC animated:YES];
}
#pragma mark - tableView dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.deviceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ShareCell"];
    cell.textLabel.textColor = [UIColor colorWithHex:0x2c363a];
    cell.detailTextLabel.textColor = [UIColor colorWithHex:0xbfbfbf];
 
    cell.imageView.image = [UIImage imageNamed:@"share_device_ic"];
    DeviceModel *deviceM = self.deviceArray[indexPath.row];
    cell.textLabel.text = deviceM.name;
    if ([deviceM.role integerValue] == 0) {
        if (deviceM.shareCount == 0) {
            cell.detailTextLabel.text = NSLocalizedString(@"未分享", nil);
        }else{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld%@",(long)deviceM.shareCount,NSLocalizedString(@"人使用", nil)];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
//    else{
//        cell.detailTextLabel.text = NSLocalizedString(@"成员", nil);
//    }
    
    return cell;
}

#pragma mark - 选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DeviceModel *deviceM = self.deviceArray[indexPath.row];
    if ([deviceM.role integerValue] != 0) {
        return;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    ShareDetailViewController *shareDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"ShareDetailViewController"];
    shareDetailVC.deviceM = deviceM;
    [self.navigationController pushViewController:shareDetailVC animated:YES];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(NSMutableArray *)messageArray
{
    if (_deviceArray == nil) {
        _deviceArray = [[NSMutableArray alloc]init];
    }
    return _deviceArray;
}
//把tableView的线对齐
-(void)viewDidLayoutSubviews{
    
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



@end
