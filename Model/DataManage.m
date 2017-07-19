//
//  DataManage.m
//  
//
//  Created by 黄 庆超 on 16/7/13.
//  Copyright © 2016年 xlink. All rights reserved.
//

#import "DataManage.h"

#import "XLinkExportObject.h"
#import "DeviceEntity.h"

#import "DataSource.h"
#import "UserModel.h"
#import "DeviceModel.h"

#import "DataPointEntity.h"


@implementation DataManage{
    NSTimer *_tryConnectTimer;
    BOOL    _status;
    
    NSMutableArray *_tempDeviceList;
}

+(DataManage *)share{
    static dispatch_once_t once;
    static DataManage *dataManage;
    dispatch_once(&once, ^{
        dataManage = [[DataManage alloc] init];
        dataManage->_status = 0;
    });
    return dataManage;
}

-(void)start{
    if (!_status) {
        _status = 1;
        [self addNotification];
        _tempDeviceList = [NSMutableArray array];
        [self performSelectorInBackground:@selector(tryConnectTimerRun) withObject:nil];
    }
    
}

-(void)stop{
    if (_status) {
        _status = 0;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [_tryConnectTimer invalidate];
        
        NSArray *array = DATASOURCE.userModel.deviceModel;
        
        for (int i = 0 ; i < array.count ; i++) {
            DeviceModel *deviceModel = array[i];
            if (deviceModel.device.isConnected) {
                [[XLinkExportObject sharedObject] disconnectDevice:deviceModel.device withReason:0];
            }
        }
    }
    [[XLinkExportObject sharedObject] logout];
}

-(void)tryConnectTimerRun{
    _tryConnectTimer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(tryConnect) userInfo:nil repeats:YES];
    [_tryConnectTimer fire];
    [NSThread currentThread].name = @"Auto Try Connect Device Thread";
    [[NSRunLoop currentRunLoop] run];
}

-(void)tryConnect{
    NSArray *deviceModels = DATASOURCE.userModel.deviceModel;
    
    for (int i = 0; i < deviceModels.count; i ++) {
        DeviceModel *deviceModel = deviceModels[i];
        if (deviceModel.device) {
            if (deviceModel.device.isConnected) {
                
            }else{
                [[XLinkExportObject sharedObject] connectDevice:deviceModel.device andAuthKey:deviceModel.device.accessKey];
            }
        }
    }

}

-(void)addNotification{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onConnectDevice:) name:kOnConnectDevice object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceStateChange:) name:kOnDeviceStatusChange object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDevice:) name:kAddDevice object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delDevice:) name:kDeleteDevice object:nil];
    //数据端点
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCloudDataPointUpdate:) name:kOnCloudDataPointUpdate object:nil];
}

-(void)onConnectDevice:(NSNotification *)noti{
    DeviceEntity *device = noti.object;
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDeviceList object:device];
    if ([_tempDeviceList containsObject:device]) {
        return;
    }
    [_tempDeviceList addObject:device];
    
    if (device.isConnected) {
        [[XLinkExportObject sharedObject] probeDevice:device];
    }
    
}


-(void)onDeviceStateChange:(NSNotification *)noti{
    DeviceEntity *device = noti.object;
    if (!device.isConnected) {
        if ([_tempDeviceList containsObject:device]) {
            [_tempDeviceList removeObject:device];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDeviceList object:device];
        }
    }
}

-(void)addDevice:(NSNotification *)noti{
    
    DeviceModel *deviceModel = noti.object;
    deviceModel.isSubscription = @(1);
    if (deviceModel.mac == nil) {
        return;
    }
    BOOL isAdd = NO;
    NSArray *array = DATASOURCE.userModel.deviceModel;
    if (array.count > 0) {
        for (int i = 0; i < array.count; i++) {
            DeviceModel *device = array[i];
            if ([deviceModel.deviceID integerValue] == [device.deviceID integerValue]) {
                isAdd = YES;
            }
        }
    }
    if (isAdd == NO) {
        [DATASOURCE.userModel.deviceModel addObject:deviceModel];
        NSLog(@"刚添加设备链接状态 %d",deviceModel.device.isConnected);
        if (!deviceModel.device.isConnected) {
            [[XLinkExportObject sharedObject] connectDevice:deviceModel.device andAuthKey:deviceModel.device.accessKey];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDeviceList object:nil];
    }
 
    
}

-(void)delDevice:(NSNotification *)noti{
    
    DeviceModel *deviceModel;
    NSNumber *isSubscription;
    if ([noti.object isKindOfClass:[DeviceModel class]]) {
        deviceModel = noti.object;
        isSubscription = deviceModel.isSubscription;
    }else{
        return;
    }
    NSLog(@"删除的设备 deviceModel %@",deviceModel.deviceID);
    if (deviceModel.device.isConnected) {
        [[XLinkExportObject sharedObject] disconnectDevice:deviceModel.device withReason:0];
    }
    if (isSubscription.boolValue) {
        [DATASOURCE addWillDelDeviceModel:deviceModel];
        
        [HttpRequest unsubscribeDeviceWithUserID:DATASOURCE.userModel.userId withAccessToken:DATASOURCE.userModel.accessToken withDeviceID:deviceModel.deviceID didLoadData:^(id result, NSError *err) {
            if (!err || err.code == 4001034) {
                [DATASOURCE removeWillDelDeviceModel:deviceModel];
            }
        }];
    }
    
    [DATASOURCE removeDeviceModel:deviceModel];
    NSLog(@"删除设备 %@",deviceModel);
    [DATASOURCE saveUserWithIsUpload:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDeviceList object:nil];
}


#pragma mark- 本地或云端数据已经更新，发送通知更新设备状
-(void)onCloudDataPointUpdate:(NSNotification *)noti{
//    DeviceEntity *deviceEntity = noti.object[@"device"];

    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSArray *dataPointArr = noti.object[@"datapoints"];
    for (DataPointEntity *dataPoint in dataPointArr) {
        if (dataPoint.value == nil || [dataPoint.value isEqualToString:@""]) {
            continue;
        }
        if (dataPoint.index == 0) {
            BOOL isPower;
            short value = [dataPoint.value shortValue];
            NSString *tipMSg ;
            if(value == 0){
                isPower = NO;
                tipMSg = NSLocalizedString(@"已关机", nil);
            }else{
                isPower = YES;
                tipMSg = NSLocalizedString(@"已开机", nil);
            }
//            [self showAlertViewWithTitle:NSLocalizedString(@"提示", nil) message: [NSString stringWithFormat:@"%@%d%@",NSLocalizedString(@"设备", nil),deviceEntity.deviceID,tipMSg] sureBtnTitle:NSLocalizedString(@"确定", nil)];
           
        }
        else if (dataPoint.index == 1){
            
            BOOL isWarm;
            short value = [dataPoint.value shortValue];
            if(value == 0){
                isWarm = NO;
            }else{
                isWarm = YES;
            }
            
            [center postNotificationName:kOnGotDeviceWorkingState object:@{@"workingState":@(isWarm),@"workingStateDataPoint":dataPoint}];
        }
        else if (dataPoint.index == 2){
            int16_t freezeTem = [dataPoint.value intValue];
            [center postNotificationName:kOnGotFreezeTem object:@{@"freezeTem":@(freezeTem),@"freezeDataPoint":dataPoint}];
        }
        else if (dataPoint.index == 3){
            int warmTem = [dataPoint.value shortValue];
            [center postNotificationName:kOnGotWarmTem object:@{@"warmTem":@(warmTem),@"warmDataPoint":dataPoint}];
        }
        else if (dataPoint.index == 31){
            int16_t indoorTem = [dataPoint.value intValue];
            [center postNotificationName:kOnGotIndoorTem object:@{@"indoorTem":@(indoorTem)}];
        }
        else if (dataPoint.index == 32){
            int16_t outdoorTem = [dataPoint.value intValue];
            [center postNotificationName:kOnGotOutdoorTem object:@{@"outdoorTem":@(outdoorTem)}];
        }
        
        else if (dataPoint.index == 33){
            int16_t outTem = [dataPoint.value intValue];
            [center postNotificationName:kOnGotOutTem object:@{@"outTem":@(outTem)}];
        }
        
        else if (dataPoint.index == 34){
            int16_t inTem = [dataPoint.value intValue];
            [center postNotificationName:kOnGotInTem object:@{@"inTem":@(inTem)}];
        }
        
    }

}
-(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message sureBtnTitle:(NSString *)sureBtnTitle {
    dispatch_async(dispatch_get_main_queue(), ^{
        AKAlertView *alert = [[AKAlertView alloc]initWithIconName:@"" withTitle:title withMessage:message];
        
        [alert addButton:ButtonTypeOK withTitle:sureBtnTitle handler:^(AKAlertViewItem *item) {
            
        }];
        [alert show];
    });
}

@end
