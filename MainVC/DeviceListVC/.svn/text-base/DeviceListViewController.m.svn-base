//
//  DeviceListViewController.m
//  heating
//
//  Created by haitao on 2017/2/8.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "DeviceListViewController.h"
#import "YSHYSlideViewController.h"

#import "HTDeviceTableViewCell.h"

#import "AddDeviceFirstStepViewController.h"
#import "DeviceDetailsViewController.h"

#import "QRCodeViewController.h"//二维码
#import "XLinkExportObject.h"

@interface DeviceListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *hud;
    NSTimer *refreshTimer;
    UIView *failLoadView;
    UIButton *button;
}
@property (weak, nonatomic) IBOutlet UIView *noneDeviceView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *deviceArray;

@end

@implementation DeviceListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUIWithTag:104 headerColorIsWhite:NO andTitle:LocalizedString(@"我的设备") rightBtnText:nil];
    
    //tableView创建
    [self createTableView];
    [self checkDeviceCount];
    //添加设备按钮，浮在页面上，放在最后添加
    [self createAddDeviceBtn];
    //添加通知
    [self addNotificationToChangUIView];
    
//    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(getDeviceList) userInfo:nil repeats:YES];
}

-(void)addNotificationToChangUIView{
    //更新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceList:) name:kUpdateDeviceList object:nil];
    //添加设备成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDeviceList) name:AddDeviceSuccess object:nil];
    //设备离线通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceState:) name:DeviceIsOffline object:nil];
     //设备上线通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceState:) name:DeviceIsOnline object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDeviceList) name:ApplicationDidBecomeActive object:nil];
}

#pragma mark -更新设备状态
-(void)updateDeviceState:(NSNotification *)noti{
    NSDictionary *dict = noti.object;
    NSInteger deviceId = [[dict objectForKey:@"device_id"] integerValue];
    NSString *deviceState = [dict objectForKey:@"deviceState"];
    for (DeviceModel *device in DATASOURCE.userModel.deviceModel) {
        if ([device.deviceID integerValue] == deviceId) {
            NSInteger index = [DATASOURCE.userModel.deviceModel indexOfObject:device];
            if ([deviceState intValue] == 1) {
                device.is_online = YES;
            }else{
                device.is_online = NO;
            }
            [DATASOURCE.userModel.deviceModel replaceObjectAtIndex:index withObject:device];
        }
    }
    [self checkDeviceCount];
}
#pragma mark -更新设备列表
-(void)updateDeviceList:(NSNotification *)noti{
    if (noti.object == nil) {
        [self checkDeviceCount];
        return;
    }
    DeviceEntity *notiDevice = noti.object;
    NSString *changStateMac = [notiDevice getMacAddressString];
    NSLog(@"设备:%@ 连接状态 %d",changStateMac,notiDevice.isConnected);
    for (int i = 0; i < DATASOURCE.userModel.deviceModel.count ; i++) {
        DeviceModel *device = DATASOURCE.userModel.deviceModel[i];
        if ([[device.device getMacAddressString] isEqualToString:changStateMac]) {
            device.is_online = notiDevice.isConnected;
            [DATASOURCE.userModel.deviceModel replaceObjectAtIndex:i withObject:device];
            [self checkDeviceCount];
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[YSHYSlideViewController shareInstance] addGesture];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self checkDeviceCount];
    //开启定时器
//    [refreshTimer setFireDate:[NSDate distantPast]];
    [self getDeviceList];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [refreshTimer invalidate];
//    refreshTimer = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[YSHYSlideViewController shareInstance] removeAllGesture];
    //关闭
//    [refreshTimer setFireDate:[NSDate distantFuture]];
}

#pragma mark - 弹出菜单
-(void)leftButtonToTurnBack{
    [[YSHYSlideViewController shareInstance] SwitchMenuState];
}
#pragma mark - 获取设备列表
-(void)getDeviceList{
    if (DATASOURCE.userModel == nil) {
        return;
    }
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest getDeviceListWithUserID:DATASOURCE.userModel.userId withAccessToken:DATASOURCE.userModel.accessToken withVersion:@(0) didLoadData:^(id result, NSError *err) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
            [hud removeFromSuperview];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!err) {
                 self.tableView.frame = CGRectMake(0, 64, MainWidth, MainHeight - 64);
                [failLoadView removeFromSuperview];
                //得到了云端的设备
                NSArray *deviceList = [result objectForKey:@"list"];
                NSLog(@"云端 deviceList %@", deviceList);
                
                //  往本地，添加云端存在，本地没有的设备
                for (NSDictionary *deviceDic in deviceList) {
                    //遍历云端设备
                    NSString *mac = [deviceDic objectForKey:@"mac"];
                    DeviceModel * deviceModel = [[DeviceModel alloc]initWithDictionary:deviceDic];
                    //创建实体
                    DeviceEntity *deviceEntity = [[DeviceEntity alloc] initWithMac:mac andProductID:[deviceDic objectForKey:@"product_id"]];
                    deviceEntity.accessKey = [deviceDic objectForKey:@"access_key"];
                    deviceEntity.version = [[deviceDic objectForKey:@"firmware_version"] intValue];
                    deviceEntity.deviceID = [[deviceDic objectForKey:@"id"] intValue];
                    
                    deviceModel.device = deviceEntity;
                    deviceModel.isSubscription = @(1);
                    
                    //发送通知,添加设备
                    [[NSNotificationCenter defaultCenter] postNotificationName:kAddDevice object:deviceModel];
                }
                [self performSelectorOnMainThread:@selector(checkDeviceCount) withObject:nil waitUntilDone:NO];
            }else{
                self.tableView.frame = CGRectMake(0, 104, MainWidth, MainHeight - 104);
                if (self.deviceArray.count > 0) {
                    for (int i = 0; i < self.deviceArray.count; i ++) {
                        DeviceModel *device = self.deviceArray[i];
                        device.is_online = NO;
                        [self.deviceArray replaceObjectAtIndex:i withObject:device];
                    }
                    [self.tableView reloadData];
                }
                [self failToGetCloudDeviceWithText:NSLocalizedString(@"同步云端设备列表失败，请重试！", nil) haveBtn:YES];
            }

        });
    }];
}
#pragma mark - 请求失败的界面
-(void)failToGetCloudDeviceWithText:(NSString *)text haveBtn:(BOOL)haveBtn{
    
    [failLoadView removeFromSuperview];
    failLoadView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, MainWidth, 40)];
    failLoadView.backgroundColor = MainYellowColor;
    [self.view addSubview:failLoadView];
    UILabel *failLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MainWidth - 40, 40)];
    failLabel.text = text;
    failLabel.textColor = [UIColor whiteColor];
    failLabel.textAlignment = NSTextAlignmentCenter;
    [failLoadView addSubview:failLabel];
    if (haveBtn == YES) {
        button = [[UIButton alloc]initWithFrame:CGRectMake(MainWidth - 60, 0, 40, 40)];
        [button addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"refresh_ic"] forState:UIControlStateNormal];
        [failLoadView addSubview:button];
    }
    
}

-(void)refreshData:(UIButton *)btn{
    [hud removeFromSuperview];
    button.enabled = NO;

    [self getDeviceList];
}


-(void)createAddDeviceBtn{
    UIButton *addDeviceBtn = [[UIButton alloc]initWithFrame:CGRectMake((MainWidth - 85)/2, MainHeight - 85, 85, 85)];
    [addDeviceBtn setImage:[UIImage imageNamed:@"index_add_btn"] forState:UIControlStateNormal];
    [addDeviceBtn addTarget:self action:@selector(addNewDevice:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addDeviceBtn];
}
#pragma mark - 添加新设备
-(void)addNewDevice:(UIButton *)btn{
//  //配置wifi
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    AddDeviceFirstStepViewController *addDeviceVC = [storyboard instantiateViewControllerWithIdentifier:@"AddDeviceFirstStepViewController"];
    //二维码
    QRCodeViewController *addDeviceVC = [QRCodeViewController new];
    addDeviceVC.isAddShareDevice = NO;
    [self.navigationController pushViewController:addDeviceVC animated:YES];
    
}

-(void)createTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, MainWidth, MainHeight - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    [self.tableView registerNib:[UINib nibWithNibName:@"HTDeviceTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTDeviceTableViewCell"];

}
#pragma mark - 判断设备个数
-(void)checkDeviceCount{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.deviceArray = [NSMutableArray arrayWithArray:DATASOURCE.userModel.deviceModel];
        if (self.deviceArray.count > 0) {
            [self.tableView reloadData];
            self.tableView.hidden = NO;
            self.noneDeviceView.hidden = YES;
        }else{
            self.noneDeviceView.hidden = NO;
            self.tableView.hidden = YES;
        }
    });

}



#pragma mark - tableView dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.deviceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"HTDeviceTableViewCell";
    HTDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (self.deviceArray.count > 0) {
        DeviceModel *device = self.deviceArray[indexPath.row];
        cell.deviceModel = device;
    }
    return cell;
}

#pragma mark -选中设备查看详情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    DeviceDetailsViewController *detailsVC = [storyboard instantiateViewControllerWithIdentifier:@"DeviceDetailsViewController"];
    DeviceModel *deviceM = self.deviceArray[indexPath.row];
    detailsVC.deviceModel =deviceM;
    [self.navigationController pushViewController:detailsVC animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(NSMutableArray *)deviceArray{
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
