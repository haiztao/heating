//
//  AppDelegate.m
//  heating
//
//  Created by haitao on 2017/2/7.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "AppDelegate.h"
//sdk 包
#import "XLinkExportObject.h"
#import "DeviceEntity.h"
#import "EventNotifyRetPacket.h"
#import "DataPointEntity.h"

#import "LoginViewController.h"
#import "DeviceListViewController.h"
#import "HTLeftMenuViewController.h"
#import <UserNotifications/UserNotifications.h>

#import "BaseViewController.h"
#import "DataManage.h"
#import "MessageViewController.h"

#import "UMMobClick/MobClick.h"

@interface AppDelegate ()<XlinkExportObjectDelegate,UNUserNotificationCenterDelegate>
{
    AKAlertView *alertView;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // 必须写代理，不然无法监听通知的接收与点击
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // 点击允许
                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@", settings);
                }];
            } else {
                // 点击不允许
                NSLog(@"注册失败");
            }
            
        }];
        [[UIApplication sharedApplication]registerForRemoteNotifications];
    }
    //    注册通知中心
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ||
        [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        // 定义用户通知设置
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        // 注册用户通知 - 根据用户通知设置
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication]registerForRemoteNotifications];
    }
    
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    [[XLinkExportObject sharedObject] setSDKProperty:@"cm2.xlink.cn" withKey:PROPERTY_CM_SERVER_ADDR];
    [XLinkExportObject sharedObject].delegate = self;
    [[XLinkExportObject sharedObject] start];
    
   //创建界面
    [self setUpMyMenuView];
    //友盟统计
    [self umengTrack];
    
    return YES;
}



#pragma mark -  收到通知时调用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSLog(@"收到通知时 : %@",response);
    if([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){
  
        NSLog(@"点击消息栏进入app");
    }
    completionHandler(UIBackgroundFetchResultNewData);
}
    

#pragma mark - iOS 10中收到推送消息
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
//    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
//    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
//  
//    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"接收到 iOS10 通知");
    if (application.applicationState == UIApplicationStateActive) {
        // 转换成一个本地通知，显示到通知栏
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.userInfo = userInfo;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        localNotification.fireDate = [NSDate date];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - 接收本地推送（AppDelegate.m中添加） ios10之前
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSDictionary *dict = notification.userInfo;
    NSLog(@"收到 推送 %@",dict);
}


#pragma mark - 主界面
-(void)setUpMyMenuView{
     self.menuNavi = [YSHYSlideViewController shareInstance];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    
    DeviceListViewController  *mainController = [storyboard instantiateViewControllerWithIdentifier:@"DeviceListViewController"];
    //设置mainController
    
    [[YSHYSlideViewController shareInstance] setMainViewController:mainController];
    HTLeftMenuViewController  *leftMenu = [storyboard instantiateViewControllerWithIdentifier:@"HTLeftMenuViewController"];
    //设置菜单Controller
    [YSHYSlideViewController shareInstance].leftMenu = leftMenu;
    LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];

    self.window.rootViewController = self.menuNavi;
    
    BOOL isAutoLogi = [[NSUserDefaults standardUserDefaults] boolForKey:isAutoLogin];
    
    if (isAutoLogi) {
        [loginVC AutoLogin];
        [self.menuNavi setViewControllers:@[mainController] animated:YES];

    }else{
        [self.menuNavi setViewControllers:@[mainController,loginVC] animated:YES];
    }

}
#pragma mark -友盟统计
- (void)umengTrack {
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = @"58f0411804e205234b001267";
    
    [MobClick startWithConfigure:UMConfigInstance];
    
}

#pragma mark - 通知登录状态返回
-(void)onLogin:(int)result{
    
    if (result == CODE_SERVER_KICK_DISCONNECT) {
        //账号被下线
        [self kickOut];
    }else{
         [[DataManage share] tryConnect];
    }
}


#pragma mark - 账号异地登录，被踢下线
-(void)kickOut{
    
    [[XLinkExportObject sharedObject] logout];
    [[DataManage share] stop];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isAutoLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    BaseViewController *baseVC = [[BaseViewController alloc]init];
    dispatch_async(dispatch_get_main_queue(), ^{
        [baseVC gotoLoginViewController];
        [baseVC showAlertViewWithTitle:LocalizedString(@"下线通知") message:LocalizedString(@"该帐号已在另一台设备上登录") sureBtnTitle:LocalizedString(@"确定") cancelBtnTitle:nil];
    });
    DATASOURCE.userModel = nil;
    return;
}

#pragma mark XlinkExportObject delegate
-(void)onStart{
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnStart object:nil];
}

-(void)onGotDeviceByScan:(DeviceEntity *)device{
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnGotDeviceByScan object:device];
}
// 获取subKey回调
- (void)onGotSubKeyWithDevice:(DeviceEntity *)device withSubKey:(NSNumber *)subkey {
    NSLog(@"deviceID %d subkey:%ld",device.deviceID,[subkey integerValue]);
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnGetSubkey object:nil userInfo:@{@"subkey" : subkey, @"device" : device}];
}

//订阅状态返回
-(void)onSubscription:(DeviceEntity *)device withResult:(int)result withMessageID:(int)messageID{
    if (result == 0) {
        NSLog(@"订阅成功,MessageID = %d", messageID);
    }else{
        NSLog(@"订阅失败,MessageID = %d; Result = %d", messageID, result);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnSubscription object:@{@"result" : @(result), @"device" : device}];
}

// 初始化设备回调
- (void)onSetDeviceAccessKey:(DeviceEntity *)device withResult:(unsigned char)result withMessageID:(unsigned short)messageID {
    NSLog(@"初始化设备回调 %@ 结果 %d messageID :%d", [device getMacAddressString], result,messageID);
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnSetDeviceAccessKey object:@{@"result" : @(result), @"device" : device}];
}

-(void)onConnectDevice:(DeviceEntity *)device andResult:(int)result andTaskID:(int)taskID{
    NSLog(@"设备 %@ 连接结果 %d", [device getMacAddressString], result);
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnConnectDevice object:device];
}

-(void)onDeviceStatusChanged:(DeviceEntity *)device{
//    NSLog(@"设备状态 %@ 状态改变, 设备类型 : %d", [device getMacAddressString], device.deviceType);
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnDeviceStatusChange object:device];
}

- (void)timeOut:(NSTimer *)nstimer {
    DeviceEntity *device = nstimer.userInfo;
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnDeviceStatusChange object:device];
}
#pragma mark -- sdk推送包 设备分享或状态改变

-(void)onGetEventNotify:(EventNotifyRetPacket *)packet{

    NSData *notifyData = packet.notifyData;
    NSInteger fromID = packet.fromID;
    NSArray *array = DATASOURCE.userModel.deviceModel;
    DeviceModel *notiDevice;
    if (array.count == 0) {
        return;
    }
    for (DeviceModel *device in array) {
        if ([device.deviceID integerValue] == fromID) {
            notiDevice = device;
        }
    }
    if (notiDevice == nil) {
        return;
    }
    //处理数据
    NSDictionary *shareDic = [NSJSONSerialization JSONObjectWithData:[notifyData subdataWithRange:NSMakeRange(2, notifyData.length - 2)] options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"设备分享属性变化 %@",shareDic);
    if ([shareDic.allKeys containsObject:@"sub"]) {
        NSString *sub = shareDic[@"sub"]; //订阅状态
        NSLog(@"订阅状态 %@",sub);
        if ([sub integerValue] == 0 && sub != nil) {
            NSInteger removeDeviceID = [shareDic[@"device_id"] integerValue];

            for (DeviceModel *device in array) {
                if ([device.deviceID integerValue] == removeDeviceID) {
                    [self showAlertViewWithTitle:NSLocalizedString(@"提示", nil) message:[NSString stringWithFormat:@"%@<%@> %@",NSLocalizedString(@"设备",nil),device.name,NSLocalizedString(@"已被取消分享", nil)] sureBtnTitle:NSLocalizedString(@"确定", nil)];
                    [DATASOURCE removeDeviceModel:device];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDeviceList object:nil];
                }
            }
        }
    }
    
    if ([shareDic.allKeys containsObject:@"type"]) {
        if ([shareDic[@"type"] isEqualToString:@"offline"]) {
            
            NSString *device_id = shareDic[@"device_id"];
            NSLog(@"设备离线 %@",device_id);
            [[NSNotificationCenter defaultCenter] postNotificationName:DeviceIsOffline object:@{@"device_id" : device_id, @"deviceState" : @"0"}];
   
        }else if ([shareDic[@"type"] isEqualToString:@"online"]){
           
            NSString *device_id = shareDic[@"device_id"];
            NSLog(@"设备上线 %@",device_id);
            [[NSNotificationCenter defaultCenter] postNotificationName:DeviceIsOnline object:@{@"device_id" : device_id, @"deviceState" : @"1"}];
        }
    }
    
    if ([shareDic.allKeys containsObject:@"msg"]) { //设备故障
        NSString *msg = [shareDic objectForKey:@"msg"];
        
        int  index = [[shareDic objectForKey:@"index"] intValue];
        int value = [[shareDic objectForKey:@"value"] intValue];
        NSLog(@"设备状态信息 : %@, index: %d,value: %d",msg,index,value);
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertView dismiss];
            alertView = [[AKAlertView alloc]initWithIconName:@"" withTitle:NSLocalizedString(@"提示", nil) withMessage:[NSString stringWithFormat:@"%@ %@",notiDevice.name,msg]];
            [alertView addButton:ButtonTypeCancel withTitle:NSLocalizedString(@"暂不", nil) handler:^(AKAlertViewItem *item) {
                
            }];
            [alertView addButton:ButtonTypeOK withTitle:NSLocalizedString(@"查看消息", nil) handler:^(AKAlertViewItem *item) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                MessageViewController  *messageVC = [storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
                [[YSHYSlideViewController shareInstance] GotoViewController:messageVC];
            }];
            [alertView show];
        });
        
    }
    
    
}

#pragma mark - 显示alert
-(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message sureBtnTitle:(NSString *)sureBtnTitle {
    dispatch_async(dispatch_get_main_queue(), ^{
        AKAlertView *alert = [[AKAlertView alloc]initWithIconName:@"" withTitle:title withMessage:message];
        
        [alert addButton:ButtonTypeOK withTitle:sureBtnTitle handler:^(AKAlertViewItem *item) {
            
        }];
        [alert show];
    });
}


#pragma mark - 数据端点
//云端返回dataPoint sync包（非数据模板）
-(void)onCloudDataPoint2Update:(DeviceEntity *)device withDataPoints:(NSArray<DataPointEntity *> *)dataPoints{
    
//    NSLog(@"deviceMac :%d ,dataPoints.count=%zd",device.deviceID,dataPoints.count);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnCloudDataPointUpdate object:@{@"device" : device, @"datapoints" : dataPoints}];
    
}
//设置本地数据端点返回
-(void)onSetLocalDataPoint:(DeviceEntity *)device withResult:(int)result withMsgID:(unsigned short)msgID{
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnSetLocalDataPoint object:@{@"result" : [NSString stringWithFormat:@"%d",result], @"msgID" : [NSString stringWithFormat:@"%d",msgID]}];
}
//设置云端数据端点成功
-(void)onSetCloudDataPoint:(DeviceEntity *)device withResult:(int)result withMsgID:(unsigned short)msgID{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnSetCloudDataPoint object:@{@"result" : [NSString stringWithFormat:@"%d",result], @"msgID" : [NSString stringWithFormat:@"%d",msgID]}];
    
}

-(void)onDataPointUpdata:(DeviceEntity *)device withIndex:(int)index withDataBuff:(NSData*)dataBuff withChannel:(int)channel {
    NSLog(@"onDataPointUpdata %zd",index);
}


#pragma mark 注册推送通知之后
//在此接收设备令牌
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    [self addDeviceToken:deviceToken];
    
}

#pragma mark 获取device token失败后
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@",error.localizedDescription);
}

#pragma mark 接收到推送通知之后 //ios 10 之前
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"receiveRemoteNotification,userInfo is %@",userInfo);
    
    
}

- (NSString *)hexadecimalString:(NSData *)data
{
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer)
    {
        return [NSString string];
    }
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
    {
        [hexString appendFormat:@"%02x", (unsigned int)dataBuffer[i]];
    }
    
    return [NSString stringWithString:hexString];
}

#pragma mark - 私有方法
/**
 *  添加设备令牌到服务器端
 *
 *  @param deviceToken 设备令牌
 */
-(void)addDeviceToken:(NSData *)deviceToken{
    
    self.deviceTokenString = [self hexadecimalString:deviceToken];
    NSLog(@"Device token: %@", self.deviceTokenString);
    
    NSString *key = @"DeviceToken";
    [[NSUserDefaults standardUserDefaults] setObject:self.deviceTokenString forKey:key];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    application.applicationIconBadgeNumber = 0;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
     application.applicationIconBadgeNumber = 0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:ApplicationDidBecomeActive object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
