//
//  DataSource.h
//  
//
//  Created by 黄 庆超 on 16/5/4.
//  Copyright © 2016年 xlink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "DeviceModel.h"


#define DATASOURCE [DataSource shareDataSource]

@interface DataSource : NSObject

@property (strong, nonatomic) UserModel *userModel;

+(DataSource *)shareDataSource;

-(void)saveUserWithIsUpload:(BOOL)isUpload;
//-(void)saveDeviceModelWithMac:(NSString *)mac withIsUpload:(BOOL)isUpload;

-(DeviceModel *)getDeviceModelWithMac:(NSString *)mac;
-(DeviceModel *)getWillDelDeviceModelWithMac:(NSString *)mac;

-(void)addDeviceModel:(DeviceModel *)deviceModel;
-(void)removeDeviceModel:(DeviceModel *)deviceModel;

-(void)addWillDelDeviceModel:(DeviceModel *)deviceModel;
-(void)removeWillDelDeviceModel:(DeviceModel *)deviceModel;



@end
