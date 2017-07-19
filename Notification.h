//
//  Notification.h
//  
//
//  Created by 黄 庆超 on 16/5/4.
//  Copyright © 2016年 xlink. All rights reserved.
//

#ifndef Notification_h
#define Notification_h

#pragma mark XLink SDK Notification
#define kOnStart                @"kOnStart"
#define kOnLogin                @"kOnLogin"
#define kKickout                @"kKickout"
#define kOnGotDeviceByScan      @"kOnGotDeviceByScan"
#define kOnSubscription         @"kOnSubscripion"
#define kOnConnectDevice        @"kOnConnectDevice"
#define kOnDeviceStatusChange   @"kOnDeviceStatusChange"
//设备离线 数据端点
#define DeviceIsOffline         @"DeviceIsOffline"
#define DeviceIsOnline          @"DeviceIsOnline"

#define kGetShareDevice         @"kGetShareDevice"

#define kAccpetORCancelShareDevice         @"kAccpetORCancelShareDevice"

#define kOnSetDeviceAccessKey   @"kOnSetDeviceAccessKey"

#define kOnGetSubkey            @"kOnGetSubkey"


#define kUpdateWifiSSID @"kUpdateWifiSSID"
#define kLogout @"kLogout"

#pragma mark DeviceNotification
#define kDeviceChange @"kDeviceChange"
#define kDeleteDevice @"kDeleteDevice"
#define kAddDevice @"kAddDevice"
#define kUpdateDeviceList @"kUpdateDeviceList"

#define ApplicationDidBecomeActive @"ApplicationDidBecomeActive"

#define kUpdateLanguage @"kUpdateLanguage"

#define AddDeviceSuccess @"addDeviceSuccess"

//温度
//add by zss

#define kOnGotDevicePowerState          @"OnGotDevicePowerState"
#define kOnGotDeviceWorkingState        @"OnGotDeviceWorkingState"
#define kOnGotFreezeTem                 @"OnGotFreezeTem"
#define kOnGotWarmTem                   @"OnGotWarmTem"
#define kOnGotIndoorTem                 @"OnGotIndoorTem"
#define kOnGotOutdoorTem                @"OnGotOutdoorTem"
#define kOnGotInTem                     @"OnGotInTem"
#define kOnGotOutTem                    @"OnGotOutTem"

#define kOnCloudDataPointUpdate         @"kOnCloudDataPointUpdate"
#define kOnSetLocalDataPoint            @"OnSetLocalDataPoint"

#define kOnSetCloudDataPoint    @"kOnSetClourDataPoint"
#define kOnCloudDataPointUpdate @"kOnCloudDataPointUpdate"
//设备数据
#define DeviceDataChange @"DeviceDataChange"



#endif /* Notification_h */
