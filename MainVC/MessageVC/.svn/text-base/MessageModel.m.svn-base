//
//  MessageModel.m
//  heating
//
//  Created by haitao on 2017/3/1.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "MessageModel.h"
#import "DeviceModel.h"

@implementation MessageModel
-(id)initWithDictonary:(NSDictionary *)dict{
    if (self = [super init]) {
        _content = [dict objectForKey:@"content"];
        NSString *create_time = [dict objectForKey:@"create_date"];
        _create_date = [self getNeedTime:create_time];//日期
        _from = [dict objectForKey:@"from"];
        _deviceName = [self getDeviceNameWithFromID:_from];
        _notify_type = [dict objectForKey:@"notify_type"];
        _alert_name = [dict objectForKey:@"alert_name"];
        _alert_value = [dict objectForKey:@"alert_value"];
        _msdID = [dict objectForKey:@"id"];
        _is_push = [dict objectForKey:@"is_push"];
        _is_read = [dict objectForKey:@"is_read"];
        _notify_type = [dict objectForKey:@"notify_type"];
        _type = [dict objectForKey:@"type"];
    }
    return self;
}

-(NSString *)getDeviceNameWithFromID:(NSString *)from{
    NSString *deviceName;
    for (DeviceModel *device in DATASOURCE.userModel.deviceModel) {
        if ([device.deviceID integerValue] == [from integerValue]) {
            deviceName = device.name;
        }
    }
    return deviceName;
}

- (NSString *)getNeedTime:(NSString *)sender {
    NSString *returnStr = @"";
    if (sender.length == 0) return returnStr;
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSDate *date =  [dataFormatter dateFromString:sender];
//    if ([date isToday]) {
//        [dataFormatter setDateFormat:@"HH:mm"];
//    }else{
        [dataFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    }
    
    returnStr = [dataFormatter stringFromDate:date];
    
    return returnStr;
}

@end
