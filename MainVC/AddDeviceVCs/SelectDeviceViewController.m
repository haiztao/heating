//
//  SelectDeviceViewController.m
//  heating
//
//  Created by haitao on 2017/2/13.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "SelectDeviceViewController.h"
#import "AddDeviceSucceedViewController.h"
#import "SelectDeviceTableViewCell.h"

#import "XLinkExportObject.h"
#import "DeviceModel.h"

@interface SelectDeviceViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    DeviceEntity *addDeviceEntity;
    DeviceModel *addDeviceModel;
    MBProgressHUD *hud;
   
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *deviceArray;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeCountLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) NSTimer *addTimer;

@end

@implementation SelectDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUIWithTag:101 headerColorIsWhite:YES andTitle:LocalizedString(@"选择设备") rightBtnText:nil];

    [BaseViewController viewGetCornerRadius:self.nextStepBtn];

    [self dataSource];
   
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSubscription:) name:kOnSubscription object:nil];
    
    
}
-(void)dataSource{

    self.deviceArray = [NSMutableArray array];
    
    for (int i = 0 ; i < self.deviceMacList.count; i++) {
        [self.deviceArray addObject:@(0)];
    }
    [_tableView reloadData];
}
#pragma mark - 添加设备
- (IBAction)gotoNextViewController:(id)sender {
    if (addDeviceEntity) {
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        _count = 60;
        
        _addTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addDevice) userInfo:nil repeats:YES];
        
    }else{

        [self showAlertViewWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请选择需要添加的设备", nil) sureBtnTitle:NSLocalizedString(@"确定", nil) cancelBtnTitle:nil];
    }

    
}

-(void)addDevice{
    
    self.timeCountLabel.text = [NSString stringWithFormat:@"%lds",(long)_count];
    if (_count > 0) {
        _count--;
        
        for (DeviceModel *deviceModel in DATASOURCE.userModel.deviceModel) {
            if ([addDeviceEntity.macAddress isEqualToData:deviceModel.device.macAddress]) {
                
                continue;
            }
        }
        
        if ([addDeviceEntity.productID isEqualToString:HeatingPID]) {
            DeviceModel *deviceModel = [[DeviceModel alloc] init];
            deviceModel.device = addDeviceEntity;
            deviceModel.name = addDeviceEntity.deviceName;
            deviceModel.isSubscription = @(0);
            
            addDeviceModel = deviceModel;
            
            DeviceModel *willDelDeviceModel = [DATASOURCE getWillDelDeviceModelWithMac:[deviceModel.device getMacAddressSimple]];
            
            if ([willDelDeviceModel.device.productID isEqualToString:HeatingPID]) {
                [DATASOURCE.userModel.willDelDeviceModel removeObject:willDelDeviceModel];
            }
            
            [[XLinkExportObject sharedObject] connectDevice:deviceModel.device andAuthKey:deviceModel.device.accessKey];
            
        }
    }else{
        [_addTimer invalidate];
        //  添加失败
        [self failToAddDevice];
    }
}
-(void)failToAddDevice{
    
    [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
    [self showAlertViewWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"添加设备失败", nil) sureBtnTitle:NSLocalizedString(@"确定", nil) cancelBtnTitle:nil];
}

#pragma mark XLinkExportObject Notification
-(void)onSubscription:(NSNotification *)noti{
    
    NSDictionary *dic = noti.object;
    
    int result = [dic[@"result"] intValue];
    
    NSLog(@"订阅返回---%zd",result);
    
    if (result == 0) {
        if (addDeviceModel) {
            
            [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
            
            [_addTimer invalidate];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kAddDevice object:addDeviceModel];
            [self performSelectorOnMainThread:@selector(addDeviceDone) withObject:nil waitUntilDone:NO];
            [DATASOURCE saveUserWithIsUpload:YES];
            
            addDeviceModel = nil;
        }
        
    }else if(result==13){
        
        [_addTimer invalidate];
        //添加失败
        [self failToAddDevice];
    }
}



#pragma mark - //完成添加
-(void)addDeviceDone{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    AddDeviceSucceedViewController *searchVC = [storyboard instantiateViewControllerWithIdentifier:@"AddDeviceSucceedViewController"];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - tableView 数据

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.deviceMacList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SelectDeviceTableViewCell";
    SelectDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell= (SelectDeviceTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:cellIdentifier owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@%02ld",LocalizedString(@"空气能热水器"),indexPath.section+1];
    cell.isSelect = [self.deviceArray[indexPath.section] boolValue];
    return cell;
}
#pragma mark - 选中的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

//    SelectDeviceTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
//    cell.isSelect = !cell.isSelect;
    
    if ([self.deviceArray[indexPath.section] boolValue]) {
        [self.deviceArray replaceObjectAtIndex:indexPath.section withObject:@(0)];
        
    }else{
        [self.deviceArray replaceObjectAtIndex:indexPath.section withObject:@(1)];
        
        addDeviceEntity = self.deviceMacList[indexPath.section];
    }
    
    for (int i=0; i<self.deviceArray.count; i++) {
        if (i != indexPath.section) {
            [self.deviceArray replaceObjectAtIndex:i withObject:@(0)];
        }
    }
    
    [_tableView reloadData];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

-(NSMutableArray *)deviceArray{
    if (_deviceArray == nil) {
        _deviceArray = [[NSMutableArray alloc]init];
    }
    return _deviceArray;
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
