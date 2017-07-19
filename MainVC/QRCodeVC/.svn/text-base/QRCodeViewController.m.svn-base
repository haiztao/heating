//
//  QRCodeViewController.m
//  heating
//
//  Created by haitao on 2017/2/15.
//  Copyright © 2017年 haitao. All rights reserved.
//
#define kPIDLength 32

#import "QRCodeViewController.h"
#import "ZHScanView.h"

@interface QRCodeViewController ()
{
    MBProgressHUD *hud;
//    DeviceEntity *addDeviceEntity;
}
@property (nonatomic,strong) ZHScanView *scanf;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUIWithTag:101 headerColorIsWhite:NO andTitle:LocalizedString(@"扫描二维码") rightBtnText:nil];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [self setupScanView];
}


-(void) setupScanView{
    
    [_scanf removeFromSuperview];
    
    _scanf = [ZHScanView scanViewWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    _scanf.promptMessage = LocalizedString(@"请扫描二维码标签");
    [self.view addSubview:_scanf];
    
    [_scanf startScaning];
    
    [_scanf outPutResult:^(NSString *result) {
        
        NSLog(@"扫描结果 %@",result);
        if (self.isAddShareDevice) {//添加分享设备
            [self addShareDeviceWithInviteCode:result];
        }else{
           [self checkQRCode:result];//添加作为管理者
        }
       
        
    }];
    
}

-(void)addShareDeviceWithInviteCode:(NSString *)inviteCode{
    NSArray *arrString = [inviteCode componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:arrString[0] options:0];
    NSString *decodeStr = [[NSString alloc]initWithData:decodeData encoding:NSUTF8StringEncoding];

    NSLog(@"邀请码 %@",decodeStr);
    if (decodeStr.length != 16) {
        [self failToGetDevice];
        return;
    }
    //显示HUD
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest acceptShareWithInviteCode:decodeStr withAccessToken:DATASOURCE.userModel.accessToken didLoadData:^(id result, NSError *err) {
        [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
        if (!err) {
            
            [self performSelectorOnMainThread:@selector(getDevicesucceed) withObject:err waitUntilDone:NO];
        }else{
            [self performSelectorOnMainThread:@selector(failAction:) withObject:err waitUntilDone:NO];
        }
    }];
}

#pragma mark - 验证二维码 添加作为管理者
-(void)checkQRCode:(NSString *)strQRcode{
    NSArray *arrString = [strQRcode componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSLog(@"二维码扫描结果:%@",arrString[0]);
    if (arrString.count == 1) {
        
        NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:arrString[0] options:0];
        NSString *decodeStr = [[NSString alloc]initWithData:decodeData encoding:NSUTF8StringEncoding];
        NSLog(@"++++++%@",decodeStr);

        
        // ++++++XQR:T:D;V:1;AUTH:RW;PID:160fa2b091ef0a00160fa2b091ef0a01;QK:58a4062cc5740e080ed7cef4;MAC:33FFDD053357313418750657;;
        //截取字符串
        if ([decodeStr containsString:@"PID:"]) {
            
            NSRange startRange = [decodeStr rangeOfString:@"PID:"];
            NSRange range = NSMakeRange(startRange.location + startRange.length, kPIDLength);
            NSString *pid = [decodeStr substringWithRange:range];
            NSLog(@"pid ：%@",pid);
            if ([pid isEqualToString:HeatingPID]) {
                //获取二维码 直接添加
                [self subscribeDeviceWithQrcodeContent:decodeStr];
            }else{
                //不是本项目的二维码
                [self failToGetDevice];
            }
        }else{
            //不是本项目的二维码
            [self failToGetDevice];
            
        }
    }else{
        //不是本项目的二维码
        [self failToGetDevice];
    }
}



-(void)subscribeDeviceWithQrcodeContent:(NSString *)qrcodeContent{

    //显示HUD
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpRequest qrcodeSubscribeWithUserID:DATASOURCE.userModel.userId withAccessToken:DATASOURCE.userModel.accessToken  withqrcodeContent:qrcodeContent didLoadData:^(id result, NSError *err) {
        if (result) {
            NSLog(@"添加成功result:%@",result);
        }
        [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
        
        if (!err) {

            [self performSelectorOnMainThread:@selector(getDevicesucceed) withObject:nil waitUntilDone:NO];
        }else{
            [self performSelectorOnMainThread:@selector(failAction:) withObject:err waitUntilDone:NO];
        }

    }];
}

#pragma mark - 设备获取成功
-(void)getDevicesucceed{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AddDeviceSuccess object:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        AKAlertView *alert = [[AKAlertView alloc]initWithIconName:@"" withTitle:LocalizedString(@"获取成功") withMessage:[NSString stringWithFormat:@"%@",LocalizedString(@"已被添加到设备列表")]];
        [alert addButton:ButtonTypeCancel withTitle:LocalizedString(@"继续添加") handler:^(AKAlertViewItem *item) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                  [self setupScanView];
            });
          
        }];
        [alert addButton:ButtonTypeOK withTitle:LocalizedString(@"查看设备") handler:^(AKAlertViewItem *item) {
            
            //返回首页
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alert show];
    });
}
-(void)failToGetDevice{
    dispatch_async(dispatch_get_main_queue(), ^{
        AKAlertView *alert = [[AKAlertView alloc]initWithIconName:@"" withTitle:LocalizedString(@"获取失败") withMessage:[NSString stringWithFormat:@"%@",LocalizedString(@"不能识别该二维码，请重试！")]];
        [alert addButton:ButtonTypeOK withTitle:LocalizedString(@"我知道了") handler:^(AKAlertViewItem *item) {
            [self setupScanView];
        }];
        [alert show];
    });
}

#pragma mark - 添加失败
-(void)failAction:(NSError *)err{

    NSString *titleStr = NSLocalizedString(@"添加失败", nil);
    NSString *errStr;
    if (err.code == 4001054) {
        errStr = NSLocalizedString(@"设备不在线", nil);
    }else if(err.code == 4031009){
        errStr = NSLocalizedString(@"您已添加过该设备，不能重复添加！", nil);
    }
    else if(err.code == 5031001){ // 服务器异常
        errStr = NSLocalizedString(@"扫描二维码失败，请重试", nil);
    }
    else if(err.code == 4001033){
         errStr = NSLocalizedString(@"你已经添加该设备,不能重复添加！", nil);
    }
    else if(err.code==-1001||err.code==-1004||err.code==-1005||err.code==-1009||err.code==404){
         errStr = NSLocalizedString(@"扫描二维码失败，请重试", nil);
    }
    else{
         errStr = NSLocalizedString(@"扫描二维码失败，请重试", nil);
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        AKAlertView *alert = [[AKAlertView alloc]initWithIconName:@"" withTitle:titleStr withMessage:errStr];

        [alert addButton:ButtonTypeOK withTitle:LocalizedString(@"确定") handler:^(AKAlertViewItem *item) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //重开扫描
                [self setupScanView];
            });

        }];
        [alert show];
    });

}



@end
