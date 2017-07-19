//
//  DeviceModel.h
//  heating
//
//  Created by haitao on 2017/2/17.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "BaseModel.h"
#import "DeviceEntity.h"

@interface DeviceModel : BaseModel

@property (strong, nonatomic) DeviceEntity  *device;
@property (nonatomic,strong) NSNumber *isSubscription; //是否订阅

@property (nonatomic,strong) NSString *access_key;
@property (nonatomic,strong) NSString *active_code;
@property (nonatomic,strong) NSString *active_date;
@property (nonatomic,strong) NSString *authority;//权限 R W
@property (nonatomic,strong) NSString *authorize_code;

@property (nonatomic,strong) NSString *firmware_mod;
@property (nonatomic,strong) NSString *firmware_version;

@property (nonatomic,strong) NSString *groups;
@property (nonatomic,strong) NSNumber *deviceID;

@property (nonatomic,strong) NSString *is_active;
@property (nonatomic,assign) bool is_online;
@property (nonatomic,strong) NSString *last_login;

@property (nonatomic,strong) NSString *mac;
@property (nonatomic,strong) NSString *mcu_mod;
@property (nonatomic,strong) NSString *mcu_version;
@property (strong,nonatomic) NSString *name;

@property (nonatomic,strong) NSString *product_id;
@property (nonatomic,strong) NSString *role;

@property (nonatomic, strong) NSNumber *source;

//上传时间
@property (nonatomic,strong) NSString *uploadTime;

//是否为体验设备
@property (nonatomic,assign) BOOL isExperienceDevice;
@property (nonatomic,assign) int shareCount;//分享人数


-(instancetype)initWithDictionary:(NSDictionary *)dic;


@end
