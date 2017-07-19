//
//  DeviceShareModel.h
//  heating
//
//  Created by haitao on 2017/3/8.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceShareModel : NSObject

@property (nonatomic,strong) NSString *device_id;//设备id

@property (nonatomic,strong) NSString *expire_date;//邀请日期
@property (nonatomic,strong) NSString *from_id;//邀请者id
@property (nonatomic,strong) NSString *from_user;//邀请者account

@property (nonatomic,strong) NSString *invite_code;//邀请码

@property (nonatomic,strong) NSString *to_name;//邀请人的昵称
@property (nonatomic,strong) NSString *to_user;//受邀请的account
@property (nonatomic,strong) NSString *user_id;//受邀请人的id

@property (nonatomic,strong) NSString *state;//邀请状态
@property (nonatomic,strong) NSString *visible;
-(id)initWithDict:(NSDictionary *)dict;
@end
