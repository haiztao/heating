//
//  DeviceModel.m
//  heating
//
//  Created by haitao on 2017/2/17.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "DeviceModel.h"



@implementation DeviceModel


-(instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self = [super initWithDictionary:dic]) {
        if ([dic.allKeys containsObject:@"deviceEntity"] ) {
            _device = [[DeviceEntity alloc] initWithDictionary:[dic objectForKey:@"deviceEntity"]];
        }
        _access_key = [dic objectForKey:@"access_key"];
        _active_code = [dic objectForKey:@"active_code"];
        _active_date = [dic objectForKey:@"active_date"];
        _authority = [dic objectForKey:@"authority"];
        _authorize_code = [dic objectForKey:@"authorize_code"];
        
        _firmware_mod = [dic objectForKey:@"firmware_mod"];
        _firmware_version = [dic objectForKey:@"firmware_version"];
        _groups = [dic objectForKey:@"groups"];
        _deviceID = [dic objectForKey:@"id"];
        _is_active = [dic objectForKey:@"is_active"];
        _last_login = [dic objectForKey:@"last_login"];
        
        _mac = [dic objectForKey:@"mac"];
        _is_online = [[dic objectForKey:@"is_online"] boolValue];
        _mcu_mod = [dic objectForKey:@"mcu_mod"];
        _mcu_version = [dic objectForKey:@"mcu_version"];
        _name = [dic objectForKey:@"name"];
        
        _product_id = [dic objectForKey:@"product_id"];
        _role = [dic objectForKey:@"role"];
        _source = [dic objectForKey:@"source"];
        _shareCount = 0;
    }
    return self;
    
}


@end
