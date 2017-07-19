//
//  UserModel.h
//
//
//  Created by 黄 庆超 on 16/5/4.
//  Copyright © 2016年 xlink. All rights reserved.
//

#import "BaseModel.h"
#import "DeviceModel.h"


@interface UserModel : BaseModel

@property (strong, nonatomic) NSString *userName;

/**
 *  account为手机或邮箱
 */
@property (strong, nonatomic) NSString  *account;

@property (strong, nonatomic) NSString  *password;
@property (strong, nonatomic) NSString  *nickName;
@property (strong, nonatomic) NSString  *avatarUrl;
@property (strong, nonatomic) NSString  *accessToken;
@property (strong, nonatomic) NSNumber  *userId;
@property (strong, nonatomic) NSString  *authorize;

@property (nonatomic, strong) NSNumber  *isExperience;
@property (strong, nonatomic) NSString  *uploadTime;
@property (nonatomic,strong)  NSDictionary *address;

@property (nonatomic,strong)  NSNumber   *pushEnable; //是否需要推送


@property (copy, nonatomic) NSMutableArray  *deviceModel;
@property (copy, nonatomic) NSMutableArray  *willDelDeviceModel;

-(instancetype)initWithDictionary:(NSDictionary *)dic;
-(NSDictionary *)getDictionary;
-(instancetype)initWithAccount:(NSString *)account andPassword:(NSString *)password;

-(void)setWeichengProperty:(NSDictionary *)propertyDic;

@end
