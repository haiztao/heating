//
//  DeviceDetailsViewController.m
//  heating
//
//  Created by haitao on 2017/2/13.
//  Copyright © 2017年 haitao. All rights reserved.
//

#define CloseGrayColor [UIColor colorWithRed:59/255.0 green:72/255.0 blue:78/255.0 alpha:1]
#define kIndoorTemIndex @"31"
#define kOutdoorTemIndex @"32"
#define kOutTemIndex @"33"
#define kInTemIndex @"34"
#define kWorkingORshutdownIndexIndex @"0"
#define kFreezingORwarmingIndex @"1"
#define kBreakdownIndex @"46"

#import "DeviceDetailsViewController.h"
#import "ZHPSlider.h"
#import "JGPopView.h"
#import "RenameDeviceViewController.h"
#import "DataPointEntity.h"
#import "XLinkExportObject.h"


@interface DeviceDetailsViewController ()<selectIndexPathDelegate,RenameDelegate>
{
    ZHPSlider *slider;
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UILabel *onlineStateLabel;//是否在线

@property (weak, nonatomic) IBOutlet UIView *sliderBackView;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceStateLabel;//设备加热模式
@property (weak, nonatomic) IBOutlet UILabel *waterTemperatureLabel;//出水温度
@property (weak, nonatomic) IBOutlet UILabel *indoorTemperatureLabel;//室内温度
@property (weak, nonatomic) IBOutlet UILabel *outdoorTempLabel;//室外温度
@property (weak, nonatomic) IBOutlet UIButton *controlButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indoorConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indoorConstraint2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oudoorConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waterConstraint;


//系统开关机数据端点
@property(nonatomic,strong)DataPointEntity *powerStateDataPoint;
//模式设定数据端点
@property(nonatomic,strong)DataPointEntity *workingStateDataPoint;
//制冷回水温度数据端点
@property(nonatomic,strong)DataPointEntity *freezeInTemDataPoint;
//制热回水温度数据端点
@property(nonatomic,strong)DataPointEntity *warmInTemDataPoint;

//记录当前数据端点的值  传给温度曲线界面
@property(nonatomic,assign)int inTem;
@property(nonatomic,assign)int outTem;
@property(nonatomic,assign)int indoorTem;
@property(nonatomic,assign)int outdoorTem;

@property (nonatomic,assign) int freezeTem;
@property (nonatomic,assign) int warmTem; //加热温度
//定时器
@property(nonatomic,strong) NSTimer *probeTimer;

//是否关机
@property(nonatomic,assign) BOOL isPowerOn;

@property (nonatomic,assign) BOOL isSwichControl;//开关
@end

@implementation DeviceDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //建立视图
    [self setupUIView];
    [self initUIWithTag:102 headerColorIsWhite:NO andTitle:LocalizedString(@"低温空气源热泵") rightBtnText:nil];
    self.titleLabel.text = self.deviceModel.name;
    //温度滑动条
    [self setupSliderView];
   
    //通知
    [self addNotificationCenterObbser];
    //赋值
    [self getDeviceDataSource];
    
    [self judgeDevicePower];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self sendProbe];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  
    });
    //发送probe包，通过数据端点返回实时更新设备当前状态
    [self.probeTimer invalidate];
    self.probeTimer = nil;
    self.probeTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(sendProbe) userInfo:nil repeats:YES];

    self.isOnline = self.deviceModel.device.isConnected;
    [self deviceOnlineStateChangeView];
}
#pragma mark - 获取数据端点值
-(void)sendProbe{
    
    [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
    [[XLinkExportObject sharedObject] probeDevice:self.deviceModel.device];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.probeTimer invalidate];
    self.probeTimer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//添加通知
-(void)addNotificationCenterObbser{
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //设备在线情况
    [center addObserver:self selector:@selector(updateDeviceState:) name:kOnDeviceStatusChange object:nil];
    //设置数据端点返回值
    [center addObserver:self selector:@selector(hadSetCloudDataPoint:) name:kOnSetCloudDataPoint object:nil];
    [center addObserver:self selector:@selector(hadSetLocalDataPoint:) name:kOnSetLocalDataPoint object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCloudDataPointUpdate:) name:kOnCloudDataPointUpdate object:nil];
    //设备离线通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceStateByDataPoint:) name:DeviceIsOffline object:nil];
    //设备上线通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceStateByDataPoint:) name:DeviceIsOnline object:nil];
}
//数据端点返回设备离线
-(void)updateDeviceStateByDataPoint:(NSNotification *)noti{
    NSDictionary *dict = noti.object;
    NSInteger deviceId = [[dict objectForKey:@"device_id"] integerValue];
    NSString *deviceState = [dict objectForKey:@"deviceState"];
    if ([self.deviceModel.deviceID integerValue] == deviceId ) {
        if ([deviceState intValue] == 1) {
            self.isOnline = YES;
        }else{
            self.isOnline = NO;
        }
        [self deviceOnlineStateChangeView];
    }
    
}
#pragma mark - 数据端点
-(void)onCloudDataPointUpdate:(NSNotification *)noti{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
        self.isOnline = YES;
        DeviceEntity *deviceEntity = noti.object[@"device"];
        
        if (deviceEntity.deviceID == [self.deviceModel.deviceID intValue]) {
            NSArray *dataPointArr = noti.object[@"datapoints"];
            for (DataPointEntity *dataPoint in dataPointArr) {
                
                if ([dataPoint.value isKindOfClass:[NSString class]]) {
                    continue;
                }
                
                if (dataPoint.index == 0) {
                    
                    BOOL isPower;
                    short value = [dataPoint.value shortValue];
                    if(value == 0){
                        isPower = NO;
                    }else{
                        isPower = YES;
                    }
                    self.isPowerOn = isPower;
                    self.powerStateDataPoint = dataPoint;
                    [self judgeDevicePower];
                }
                else if (dataPoint.index == 1){
                    
                    BOOL isWarm;
                    short value = [dataPoint.value shortValue];
                    if(value == 0){
                        isWarm = NO;
                    }else{
                        isWarm = YES;
                    }
                    self.workingStateDataPoint = dataPoint;
                    
                }
                else if (dataPoint.index == 2){
                    self.freezeTem = [dataPoint.value intValue];
                    self.freezeInTemDataPoint = dataPoint;
                }
                else if (dataPoint.index == 3){
                    self.warmTem = [dataPoint.value shortValue];
                    self.warmInTemDataPoint = dataPoint;
                }
                else if (dataPoint.index == 31){
                    int16_t indoorTem = [dataPoint.value intValue];
                    self.indoorTem = indoorTem;
                }
                else if (dataPoint.index == 32){
                    int16_t outdoorTem = [dataPoint.value intValue];
                    self.outdoorTem = outdoorTem;
                }
                else if (dataPoint.index == 33){
                    int16_t outTem = [dataPoint.value intValue];
                    self.outTem = outTem;
                }
                else if (dataPoint.index == 34){
                    int16_t inTem = [dataPoint.value intValue];
                    self.inTem = inTem;
                    
                    [self getDeviceDataSource];
                }
            }
        }
    });
    
}


#pragma mark - 设备在线情况
-(void)updateDeviceState:(NSNotification *)noti{
    DeviceEntity *notiDevice = noti.object;
    
    if (notiDevice.deviceID == [self.deviceModel.deviceID integerValue]) {
        self.isOnline = notiDevice.isConnected;
        [self deviceOnlineStateChangeView];
    }
}
-(void)judgeDevicePower{
    if (self.isPowerOn) {
        [self deviceOpenState];
    }else{
        [self deviceCloseState];
    }
    [self deviceOnlineStateChangeView];
}

#pragma mark - 赋值
-(void)getDeviceDataSource{

    dispatch_async(dispatch_get_main_queue(), ^{
        self.temperatureLabel.text = [NSString stringWithFormat:@"%d",self.inTem];
        if (self.warmTem > 0) {
            if (self.warmTem > 100) {
                self.warmTem = self.warmTem / 10;
            }
//            slider.value = self.warmTem;
        }

        self.waterTemperatureLabel.text = [NSString stringWithFormat:@"%d",self.outTem];
        
        self.indoorTemperatureLabel.text = [NSString stringWithFormat:@"%d",self.indoorTem];
        
        self.outdoorTempLabel.text = [NSString stringWithFormat:@"%d",self.outdoorTem];
    });

}

#pragma mark - 设置云端数据端点成功
-(void)hadSetCloudDataPoint:(NSNotification *)noti{
    NSString *result = noti.object[@"result"];
    NSLog(@"云端result %@ - msgID: %@",result,noti.object[@"msgID"]);
    [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([result intValue] == 0) {
            NSLog(@"设置成功");

//            [self showErrorWithMessage:NSLocalizedString(@"操作成功", nil)];
        }else{
            
//            slider.value = self.warmTem;

        [self showErrorWithMessage:NSLocalizedString(@"操作失败", nil)];
        }
    });

   
}
//本地
-(void)hadSetLocalDataPoint:(NSNotification *)noti{
    [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
    NSString *result = noti.object[@"result"];
     NSLog(@"本地result %@ - msgID: %@",result,noti.object[@"msgID"]);
    if ([result intValue] == 0) {
        NSLog(@"设置成功");
    }else{
        [self showErrorWithMessage:NSLocalizedString(@"操作失败" , nil)];
    }
}

-(void)setupUIView{
    [BaseViewController viewGetCornerRadius:self.onlineStateLabel];
    self.indoorConstraint.constant *= MainWidth/320;
    self.indoorConstraint2.constant *= MainWidth/320;
    self.oudoorConstraint.constant *= MainWidth/320;
    self.waterConstraint.constant *= MainWidth/320;
}

#pragma mark- 弹出菜单
-(void)rightButtonToTurnBack{
    [self setupPopView];
}
#pragma mark - popView
-(void)setupPopView
{
    
    CGPoint point = CGPointMake(MainWidth - 20,50);
    JGPopView *popView;
    if ([self.deviceModel.role intValue] == 1) {
       popView = [[JGPopView alloc] initWithOrigin:point Width:121 Height:62 Type:JGTypeOfUpRight Color:[UIColor clearColor] backGroundImageName:@"control_pop2_bg"];
        popView.dataArray = @[LocalizedString(@"取消控制")];

    }else{
        popView = [[JGPopView alloc] initWithOrigin:point Width:121 Height:107 Type:JGTypeOfUpRight Color:[UIColor clearColor] backGroundImageName:@"control_pop_bg"];
        popView.dataArray = @[LocalizedString(@"重命名"),LocalizedString(@"删除设备")];
    }
    popView.fontSize = 17;
    popView.row_height = 45;
    popView.titleTextColor = [UIColor whiteColor];
    popView.delegate = self;
    [popView popView];
}
#pragma mark -重命名和删除设备
- (void)selectIndexPathRow:(NSInteger)index{
    
    if ([self.deviceModel.role intValue] == 1) {
        AKAlertView *alert = [[AKAlertView alloc]initWithIconName:@"" withTitle:LocalizedString(@"提示") withMessage:LocalizedString(@"是否要取消控制？")];
        [alert addButton:ButtonTypeCancel withTitle:LocalizedString(@"取消") handler:^(AKAlertViewItem *item) {
        }];
        [alert addButton:ButtonTypeOK withTitle:LocalizedString(@"确定") handler:^(AKAlertViewItem *item) {
            
            if (![NSTools isConnectionAvailable]) {
                [BaseViewController netWordIsDisconnected];
            }else{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteDevice object:self.deviceModel];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }];
        [alert show];
    }else{
        if (index == 0) {
            RenameDeviceViewController *vc = [RenameDeviceViewController new];
            vc.deviceName = self.deviceModel.name;
            vc.titleString = LocalizedString(@"重命名");
            vc.isAccountTurn = NO;//修改昵称标志
            vc.device = self.deviceModel;
            vc.renameDelegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            AKAlertView *alert = [[AKAlertView alloc]initWithIconName:@"" withTitle:LocalizedString(@"提示") withMessage:LocalizedString(@"是否要删除设备？")];
            [alert addButton:ButtonTypeCancel withTitle:LocalizedString(@"取消") handler:^(AKAlertViewItem *item) {
            }];
            [alert addButton:ButtonTypeOK withTitle:LocalizedString(@"确定") handler:^(AKAlertViewItem *item) {
                
                if (![NSTools isConnectionAvailable]) {
                    [BaseViewController netWordIsDisconnected];
                }else{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteDevice object:self.deviceModel];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }];
            [alert show];
            
        }
    }


}
#pragma mark  - 修改设备名称 成功
-(void)renameSucceedWithNickName:(NSString *)nickName{
    self.titleLabel.text = nickName;
}


#pragma mark -滑动条
-(void)setupSliderView{
    slider = [[ZHPSlider alloc] initWithFrame:CGRectMake(0, 0, 60, 220)];
    slider.directionType = DirectionVertical;
    slider.sortType = SortPositive;
    slider.minimumValue = 30.0f;
    slider.maximumValue = 70.0f;
    slider.value = 38.0f;// 此处注意value要在设置好decimalPlaces，maximumValue和minimumValue以后设置哦！
    
    slider.labelOnThumb.font = [UIFont systemFontOfSize:12];
    slider.labelOnThumb.hidden = YES;
    slider.labelAboveThumb.hidden = YES;
    slider.backgroundImageView.image = [UIImage imageNamed:@"progress_bg"];
    slider.thumbImageView.image = [UIImage imageNamed:@"control_switcher_btn"];//按钮图片
    [self.sliderBackView addSubview:slider];
    //监听滑动块最后的值
    [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
   // 监听滑动块最后的值
    [slider addTarget:self action:@selector(sliderLastValue:) forControlEvents:UIControlEventTouchUpOutside];
}
#pragma mark - 滑动 最终温度值
-(void)sliderLastValue:(ZHPSlider *)sliderView{
    //开启定时器
    [self.probeTimer setFireDate:[NSDate distantPast]];  //很远的过去
    
    NSLog(@"sliderView.value %.f",sliderView.value);
    if (self.isOnline == NO || self.workingStateDataPoint == nil || self.warmInTemDataPoint == nil) {
        [self showErrorWithMessage:NSLocalizedString(@"设备未连接，无法进行控制" , nil)];
        return;
    }
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 
    
    int temp = [[NSString stringWithFormat:@"%.f",sliderView.value] intValue];
    NSMutableArray <DataPointEntity *> *mArr = [[NSMutableArray alloc]init];
    if (30 <= temp && temp <= 70) {
        //加热
        DataPointEntity *workingStateDataPoint = self.workingStateDataPoint;
        workingStateDataPoint.value = @(1);
        DataPointEntity *warmInTemDataPoint = self.warmInTemDataPoint;
        warmInTemDataPoint.value = [NSNumber numberWithShort:temp];
        [mArr addObject:workingStateDataPoint];
        [mArr addObject:warmInTemDataPoint];
        NSLog(@"warmInTemDataPoint %@ index:%d, value:%@",warmInTemDataPoint ,warmInTemDataPoint.index,warmInTemDataPoint.value);
    }

    [[XLinkExportObject sharedObject]setCloudDataPoints:mArr withDevice:self.deviceModel.device];
    
}

#pragma mark - 滑动条的值
- (void)sliderValueChange:(ZHPSlider *)sliderView{
    //暂停定时器
    [self.probeTimer setFireDate:[NSDate distantFuture]];  //很远的将来
    self.temperatureLabel.text = [NSString stringWithFormat:@"%.f",sliderView.value];
}


#pragma mark - 控制开关
- (IBAction)controlDeviceState:(UIButton *)sender {

    if (self.isOnline == NO || self.powerStateDataPoint == nil) {
        [self showErrorWithMessage:NSLocalizedString(@"设备未连接，无法进行控制" , nil)];
        self.isOnline = NO;
        [self deviceOnlineStateChangeView];
        return;
    }

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
    //发送关机指令
    DataPointEntity *powerStateDataPoint = self.powerStateDataPoint;
    if (self.isPowerOn == YES) {//关机
        self.isPowerOn = NO;
        powerStateDataPoint.value = [NSNumber numberWithShort:0];
        if (self.deviceModel.device.isLANOnline) {
            //内网
            [[XLinkExportObject sharedObject] setLocalDataPoints:@[powerStateDataPoint] withDevice:self.deviceModel.device];
        }else{
            //外网
            [[XLinkExportObject sharedObject]setCloudDataPoints:@[powerStateDataPoint] withDevice:self.deviceModel.device];
        }
        
    }else{//开机
        self.isPowerOn = YES;
      
        powerStateDataPoint.value = [NSNumber numberWithShort:1];
        if (self.deviceModel.device.isLANOnline) {
            //内网
            [[XLinkExportObject sharedObject] setLocalDataPoints:@[powerStateDataPoint] withDevice:self.deviceModel.device];
        }else{
            //外网
            [[XLinkExportObject sharedObject]setCloudDataPoints:@[powerStateDataPoint] withDevice:self.deviceModel.device];
        }
    }
    
}
#pragma mark - 开启状态
-(void)deviceOpenState{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.controlButton.selected = NO;
        self.temperatureLabel.textColor = MainYellowColor;
        self.unitLabel.textColor = MainYellowColor;
        self.deviceStateLabel.textColor = MainYellowColor;

        slider.thumbImageView.image = [UIImage imageNamed:@"control_switcher_btn"];
        slider.userInteractionEnabled = YES;
        self.deviceStateLabel.text =LocalizedString(@"制热中");
        [self getDeviceDataSource];
    });
}
#pragma mark - 关闭
-(void)deviceCloseState{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.controlButton.selected = YES;
        self.unitLabel.textColor = CloseGrayColor;
        self.deviceStateLabel.textColor = CloseGrayColor;
        self.deviceStateLabel.text =LocalizedString(@"关机");
        slider.thumbImageView.image = [UIImage imageNamed:@"control_switcher_off_btn"];
        slider.userInteractionEnabled = NO;
    });
}


#pragma mark -设备故障
-(void)deviceIsBroken{
    dispatch_async(dispatch_get_main_queue(), ^{
        AKAlertView *alert = [[AKAlertView alloc]initWithIconName:@"control_warning_ic" withTitle:LocalizedString(@"设备故障") withMessage:[NSString stringWithFormat:@"%@",LocalizedString(@"")]];
        
        [alert addButton:ButtonTypeOK withTitle:LocalizedString(@"确定") handler:^(AKAlertViewItem *item) {
            
        }];
        [alert show];
    });
}

#pragma mark - 设备是否在线
-(void)deviceOnlineStateChangeView{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isOnline) {
            self.onlineStateLabel.text = LocalizedString(@"设备在线");
            self.onlineStateLabel.backgroundColor = [UIColor clearColor];
            self.onlineStateLabel.textColor = [UIColor colorWithHex:0x6f848e];
            [self getDeviceDataSource];
        }else{
            self.onlineStateLabel.text = LocalizedString(@"设备已离线,请检查网络连接！");
            self.onlineStateLabel.backgroundColor = [UIColor colorWithHex:0xdc5050];
            self.onlineStateLabel.textColor = [UIColor whiteColor];
            [self deviceisOffline];
        }
    });
    
}

#pragma mark - 设备离线
-(void)deviceisOffline{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.controlButton.selected = YES;
        self.temperatureLabel.textColor = CloseGrayColor;
        self.temperatureLabel.text = @"_ _";
        self.unitLabel.textColor = CloseGrayColor;
        self.deviceStateLabel.textColor = CloseGrayColor;
        self.deviceStateLabel.text =LocalizedString(@"离线");
        self.indoorTemperatureLabel.text = @"_ _";
        self.outdoorTempLabel.text = @"_ _";
        self.waterTemperatureLabel.text = @"_ _";
        slider.thumbImageView.image = [UIImage imageNamed:@"control_switcher_off_btn"];
        slider.userInteractionEnabled = NO;
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
