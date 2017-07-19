//
//  SearchDeviceViewController.m
//  heating
//
//  Created by haitao on 2017/2/13.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "SearchDeviceViewController.h"
#import "SelectDeviceViewController.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#import "HFSmartLink.h"


@interface SearchDeviceViewController ()
{
    HFSmartLink * smtlk;
    BOOL isconnecting;
    NSMutableArray *deviceMacList;
    NSTimer *comfigureTimer;
    NSInteger timeCount;
    BOOL isplay;
}
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *searchLabel;
@property (weak, nonatomic) IBOutlet UIImageView *activeImageView;

@end

@implementation SearchDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUIWithTag:100 headerColorIsWhite:YES andTitle:LocalizedString(@"搜索设备") rightBtnText:nil];
    [BaseViewController viewGetCornerRadius:self.cancelBtn];
    //配置WiFi
    [self configureWiFi];
    NSLog(@"ssid :%@ pwd :%@",self.ssid,self.wifiPassword);
    [self addAnimationToImageView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
}

- (IBAction)cancleSearchDevice:(id)sender {
    [self stopAnimate];
    smtlk = [HFSmartLink shareInstence];
    [smtlk stopWithBlock:^(NSString *stopMsg, BOOL isOk) {
        NSLog(@"stopMsg %@  isOk:%zi",stopMsg,isOk);
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)countDownTime{
    
    timeCount --;
    self.searchLabel.text = [NSString stringWithFormat:@"%@  %lds",NSLocalizedString(@"正在搜索设备,请稍后...", nil),(long)timeCount];
    [self startAnimate];
    if (timeCount == 0) {
        [comfigureTimer invalidate];
        [self stopAnimate];
        [smtlk stopWithBlock:^(NSString *stopMsg, BOOL isOk) {
            NSLog(@"stopMsg %@  isOk:%zi",stopMsg,isOk);
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            AKAlertView *alert = [[AKAlertView alloc]initWithIconName:@"" withTitle:LocalizedString(@"配置失败") withMessage:LocalizedString(@"是否重新配置？")];
            
            [alert addButton:ButtonTypeCancel withTitle:LocalizedString(@"取消") handler:^(AKAlertViewItem *item) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addButton:ButtonTypeCancel withTitle:LocalizedString(@"重试") handler:^(AKAlertViewItem *item) {
                [self configureWiFi];
            }];
            
            
            [alert show];
        });
    }
}



#pragma mark - 配网
-(void)configureWiFi{
    
    timeCount = 120;
    comfigureTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTime) userInfo:nil repeats:YES];
    
    //**配置wifi
    deviceMacList = [NSMutableArray array];
    
    smtlk = [HFSmartLink shareInstence];
    smtlk.waitTimers = 10;
    //可配置多个？
    smtlk.isConfigOneDevice = NO;
    
    [smtlk startWithSSID:self.ssid Key:self.wifiPassword withV3x:NO processblock:^(NSInteger process) {
        
    } successBlock:^(HFSmartLinkDeviceInfo *dev) {
        NSLog(@"deviceMacList %@",dev.mac);
        //得到mac地址
        [deviceMacList addObject:dev.mac];
        
    } failBlock:^(NSString *failmsg) {
        
        
    } endBlock:^(NSDictionary *deviceDic) {
        //配置结束 扫描设备
        if (deviceMacList.count > 0) {
            NSLog(@"deviceMacList %@",deviceMacList);
            [comfigureTimer invalidate];
            [self gotoSelectDeviceVC];
            
        }else{
            //添加失败
            
        }
        
    }];
}

#pragma mark - 跳转选择设备界面
-(void)gotoSelectDeviceVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    SelectDeviceViewController *searchVC = [storyboard instantiateViewControllerWithIdentifier:@"SelectDeviceViewController"];
    searchVC.deviceMacList = deviceMacList;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - 图片转动动画
-(void)addAnimationToImageView{
    //添加动画
    CABasicAnimation *monkeyAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    monkeyAnimation.toValue = [NSNumber numberWithFloat:2.0 *M_PI];
    monkeyAnimation.duration = 1.5f;
    monkeyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    monkeyAnimation.cumulative = NO;
    monkeyAnimation.removedOnCompletion = NO; //No Remove
    
    monkeyAnimation.repeatCount = FLT_MAX;
    [self.activeImageView.layer addAnimation:monkeyAnimation forKey:@"AnimatedKey"];
    [self.activeImageView stopAnimating];
    
    // 加载动画 但不播放动画
    self.activeImageView.layer.speed = 0.0;
    
}

//开始动画
- (void)startAnimate {
    if (!isplay) {
        isplay = YES;
        self.activeImageView.layer.speed = 1.0;
        self.activeImageView.layer.beginTime = 0.0;
        CFTimeInterval pausedTime = [self.activeImageView.layer timeOffset];
        CFTimeInterval timeSincePause = [self.activeImageView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        self.activeImageView.layer.beginTime = timeSincePause;
    }
}
//停止动画并保存当前的角度
- (void)stopAnimate{
    if (isplay) {
        isplay = NO;
        CFTimeInterval pausedTime = [self.activeImageView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.activeImageView.layer.speed = 0.0;
        self.activeImageView.layer.timeOffset = pausedTime;
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
