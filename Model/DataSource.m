//
//  DataSource.m
//
//
//  Created by 黄 庆超 on 16/5/4.
//  Copyright © 2016年 xlink. All rights reserved.
//

#import "DataSource.h"



@implementation DataSource

+(DataSource *)shareDataSource{
    static DataSource *dataSource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataSource = [[DataSource alloc] init];
    });
    return dataSource;
}

-(void)saveUserWithIsUpload:(BOOL)isUpload{
    
    NSMutableArray *userList = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"userList"]];
    
    for (NSInteger i = userList.count - 1; i >= 0; i--) {
        NSDictionary *userModelDic = userList[i];
        if ([self.userModel.account isEqualToString:[userModelDic objectForKey:@"account"]]) {
            [userList removeObjectAtIndex:i];
            break;
        }
    }
    
    if (isUpload) {
        _userModel.uploadTime = @([[NSDate date] timeIntervalSince1970]).stringValue;
    }
    
    NSDictionary *userDictionary = [self.userModel getDictionary];
    [userList addObject:userDictionary];
    [[NSUserDefaults standardUserDefaults] setObject:userList forKey:@"userList"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    if (isUpload) {
        NSDictionary *weichengPropertyDic = @{@"weichengProperty" : [userDictionary objectForKey:@"weichengProperty"]};
        //上传
        [HttpRequest setUserPropertyDictionary:weichengPropertyDic withUserID:DATASOURCE.userModel.userId withAccessToken:DATASOURCE.userModel.accessToken didLoadData:^(id result, NSError *err) {
            if (err) {
                if (err.code == 4031003) {  //无效/过期的Access-Token，重新获取
                    [HttpRequest authWithAccount:_userModel.account withPassword:_userModel.password didLoadData:^(id result, NSError *err) {
                        if (!err) {
                            _userModel.accessToken = result[@"access_token"];
                            [DATASOURCE saveUserWithIsUpload:NO];
                            [HttpRequest setUserPropertyDictionary:weichengPropertyDic withUserID:DATASOURCE.userModel.userId withAccessToken:DATASOURCE.userModel.accessToken didLoadData:nil];
                        }
                    }];
                }
            }
        }];
    }

    
}


-(DeviceModel *)getDeviceModelWithMac:(NSString *)mac{
    NSArray *deviceModels = _userModel.deviceModel;

    for (DeviceModel *deviceModel in deviceModels) {
        NSLog(@"deviceModels本地列表 ：%@",[deviceModel.device getMacAddressSimple]);
        if ([mac isEqualToString:[deviceModel.device getMacAddressSimple]]) {
            return deviceModel;
        }
    }
    return nil;
}

-(DeviceModel *)getWillDelDeviceModelWithMac:(NSString *)mac{
    NSArray *deviceModels = _userModel.willDelDeviceModel;
    for (DeviceModel *deviceModel in deviceModels) {
        if ([mac isEqualToString:[deviceModel.device getMacAddressSimple]]) {
            return deviceModel;
        }
    }
    return nil;
}

-(void)addDeviceModel:(DeviceModel *)deviceModel{
 
    [_userModel.deviceModel addObject:deviceModel];
    
}

-(void)removeDeviceModel:(DeviceModel *)deviceModel{
 
    [_userModel.deviceModel removeObject:deviceModel];
    
}

-(void)addWillDelDeviceModel:(DeviceModel *)deviceModel{
 
    [_userModel.willDelDeviceModel addObject:deviceModel];
    
}

-(void)removeWillDelDeviceModel:(DeviceModel *)deviceModel{
  
    [_userModel.willDelDeviceModel removeObject:deviceModel];
    
}


@end
