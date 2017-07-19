//
//  UpdateFirmwareViewController.m
//  heating
//
//  Created by haitao on 2017/2/9.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "UpdateFirmwareViewController.h"
#import "HTUpdateTableViewCell.h"
#import "VersionModel.h"

@interface UpdateFirmwareViewController ()<UITableViewDataSource,UITableViewDelegate,HTUpdateDelegate>
{
    MBProgressHUD *hud;
    NSInteger upgradeIndex;
}
@property (weak, nonatomic) IBOutlet UIView *noneDeviceView;
    @property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *upgradeArray;
@end

@implementation UpdateFirmwareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUIWithTag:101 headerColorIsWhite:NO andTitle:LocalizedString(@"固件升级") rightBtnText:nil];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, MainWidth, MainHeight - 64) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self judgeTheArrayCountAndChangeUI];
    

    
}
-(void)viewWillAppear:(BOOL)animated{
    //获取版本信息
    [self getDeviceNewestVersion];
}

-(void)getDeviceNewestVersion{
    NSArray *array = DATASOURCE.userModel.deviceModel;
    if (array.count > 0) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        for ( int i = 0 ;i < array.count ; i++) {
            DeviceModel *deviceM = array[i];
            [HttpRequest getVersionWithDeviceID:[NSString stringWithFormat:@"%@",deviceM.deviceID] withProduct_id:HeatingPID withAccessToken:DATASOURCE.userModel.accessToken didLoadData:^(id result, NSError *err) {
                
                [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (err) {
                        NSLog(@"err %@",err);
                        
                        [self setupNetworkUnavailableWithTipMsg:NSLocalizedString(@"获取固件信息失败，请重试", nil) title:nil retryBtnTitle:NSLocalizedString(@"重试", nil)];
                        
                    }else{
                        
                        NSLog(@"固件版本 :%@",result);
                        [self.noneNetworkView removeFromSuperview];
                        VersionModel *versionM = [[VersionModel alloc]initWithDict:result];
                        if ([versionM.newest intValue] > [deviceM.firmware_version intValue]) {
                            deviceM.firmware_version = [NSString stringWithFormat:@"%@",versionM.newest];
                            [self.upgradeArray addObject:deviceM];
                        }
                    
                        [self judgeTheArrayCountAndChangeUI];
                      
                    }
                });
            }];
        }
    }
    
}
#pragma mark - 点击重试
-(void)retryToRefreshDataSuorce{
    [hud removeFromSuperview];
    [self getDeviceNewestVersion];
    
}

-(void)judgeTheArrayCountAndChangeUI{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.upgradeArray.count > 0) {
            self.noneDeviceView.hidden = YES;
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }else{
            if (DATASOURCE.userModel.deviceModel.count == 0) {
                self.tipLabel.text = NSLocalizedString(@"您尚未添加设备", nil);
            }else{
                self.tipLabel.text = NSLocalizedString(@"您的设备固件均为最新版本", nil);  
            }
            self.noneDeviceView.hidden = NO;
            self.tableView.hidden = YES;
        }
    });
}

-(NSMutableArray *)upgradeArray{
    if (_upgradeArray == nil) {
        _upgradeArray = [NSMutableArray new];
    }
    return _upgradeArray;
}

#pragma mark - tableView Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.upgradeArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"HTUpdateTableViewCell";
    HTUpdateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell= (HTUpdateTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:cellIdentifier owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.updateBtn.tag = indexPath.row;
    cell.delegate = self;
    DeviceModel *deviceM = self.upgradeArray[indexPath.row];
    cell.deviceNameLabel.text = deviceM.name;
   
    return cell;
    
}

#pragma mark -点击升级
-(void)clickUpdateWithIndexPath:(NSInteger)indexPath{
    [self deviceIsUpgrading];
    upgradeIndex = indexPath;
    DeviceModel *deviceM = self.upgradeArray[indexPath];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest upgradeWithDeviceID:[NSString stringWithFormat:@"%@",deviceM.deviceID] withProduct_id:HeatingPID withAccessToken:DATASOURCE.userModel.accessToken didLoadData:^(id result, NSError *err) {
        [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
        if (err) {
            
        }else{
            [self deviceUpgradeIsSucceed];
        }
    }];

}

#pragma mark - 固件升级中
-(void)deviceIsUpgrading{
    dispatch_async(dispatch_get_main_queue(), ^{
        AKAlertView *alert = [[AKAlertView alloc]initWithIconName:@"" withTitle:LocalizedString(@"固件升级中") withMessage:[NSString stringWithFormat:@"%@\n%@",LocalizedString(@"系统将自动更新，无需任何操作"),LocalizedString(@"升级完成后，设备将自动重启")]];
        [alert addButton:ButtonTypeOK withTitle:@"确定" handler:^(AKAlertViewItem *item) {
            HTUpdateTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:upgradeIndex inSection:0]];
            cell.updateBtn.enabled = NO;
        }];
        [alert show];
    });
}
#pragma mark - 固件完成
-(void)deviceUpgradeIsSucceed{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        DeviceModel *deviceM = self.upgradeArray[upgradeIndex];
        AKAlertView *alert = [[AKAlertView alloc]initWithIconName:@"" withTitle:LocalizedString(@"版本升级完成") withMessage:[NSString stringWithFormat:@"%@%@",LocalizedString(@"新固件版本：V"),deviceM.firmware_version]];
        [alert addButton:ButtonTypeOK withTitle:LocalizedString(@"确定") handler:^(AKAlertViewItem *item) {
            
        }];
        [alert show];
    });
}

#pragma mark - 头部视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainWidth, 80)];
    float x = 25;
    float y = 15;
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, MainWidth - 2 * x, 25)];
    tipLabel.text = LocalizedString(@"可升级的设备");
    tipLabel.font = [UIFont systemFontOfSize:20];
    [view addSubview:tipLabel];
    
    UILabel *tipLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(x, y + 25, MainWidth - 2*x, 20)];
    tipLabel2.textColor = [UIColor colorWithHex:0x93a1a8];
    tipLabel2.font = [UIFont systemFontOfSize:14];
    tipLabel2.adjustsFontSizeToFitWidth = YES;
    tipLabel2.text = LocalizedString(@"以下设备有新的固件版本，并可以立即开始升级");
    [view addSubview:tipLabel2];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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




/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
