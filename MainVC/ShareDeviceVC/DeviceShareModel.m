//
//  DeviceShareModel.m
//  heating
//
//  Created by haitao on 2017/3/8.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "DeviceShareModel.h"

@implementation DeviceShareModel

-(id)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        
        if ([dict.allKeys containsObject:@"device_id"]) {
            _device_id = [dict objectForKey:@"device_id"];
        }
        if ([dict.allKeys containsObject:@"expire_date"]) {
            _expire_date = [dict objectForKey:@"expire_date"];
        }
        if ([dict.allKeys containsObject:@"from_id"]) {
            _from_id = [dict objectForKey:@"from_id"];
        }
        if ([dict.allKeys containsObject:@"from_user"]) {
            _from_user = [dict objectForKey:@"from_user"];
        }
        if ([dict.allKeys containsObject:@"invite_code"]) {
            _invite_code = [dict objectForKey:@"invite_code"];
        }
        
        if ([dict.allKeys containsObject:@"to_user"]) {
            _to_user = [dict objectForKey:@"to_user"];
        }
        if ([dict.allKeys containsObject:@"to_name"]) {
            _to_name = [dict objectForKey:@"to_name"];
        }
        if ([dict.allKeys containsObject:@"user_id"]) {
            _user_id = [dict objectForKey:@"user_id"];
        }
        if ([dict.allKeys containsObject:@"state"]) {
            _state = [dict objectForKey:@"state"];
        }
        if ([dict.allKeys containsObject:@"visible"]) {
            _visible =[dict objectForKey:@"visible"];
        }
        
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"_state:%@,_from_id:%@,_from_user:%@,_to_name:%@,_to_user：%@，deviceid:%@,expireDate:%@,invite_code:%@,_user_id:%@",_state,_from_id,_from_user,_to_name,_to_user,_device_id,_expire_date,_invite_code,_user_id];
}

@end
