//
//  UserModel.m
//
//
//  Created by 黄 庆超 on 16/5/4.
//  Copyright © 2016年 xlink. All rights reserved.
//

#import "UserModel.h"
#import "DataSource.h"


@implementation UserModel

-(instancetype)initWithAccount:(NSString *)account andPassword:(NSString *)password{
    if (self = [super init]) {
        _account = account;
        _password = password;
        
        _uploadTime = @"0";
        _isExperience = [NSNumber numberWithInt:1];
        _address = [NSDictionary dictionary];
        _pushEnable = [NSNumber numberWithBool:1];
        
        _deviceModel = [[NSMutableArray alloc]init];
        _willDelDeviceModel = [[NSMutableArray alloc]init];
    }
    return self;
}

-(NSMutableArray *)deviceModel{
    if (_deviceModel == nil) {
        _deviceModel = [[NSMutableArray alloc]init];
    }
    return _deviceModel;
}

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self = [super initWithDictionary:dic]) {
        _userName = [dic objectForKey:@"userName"];
        
        _account        =   [dic objectForKey:@"account"];
        _password       =   [dic objectForKey:@"password"];
        _nickName       =   [dic objectForKey:@"nickname"];
        _userId         =   [dic objectForKey:@"userID"];
        _authorize      =   [dic objectForKey:@"authorize"];
        _accessToken    =   [dic objectForKey:@"access-token"];
        _avatarUrl      =   [dic objectForKey:@"avatarUrl"];
        
        NSDictionary *propertyDic = [dic objectForKey:@"weichengProperty"];
        if ([propertyDic.allKeys containsObject:@"uploadTime"]) {
            _uploadTime = [propertyDic objectForKey:@"uploadTime"];
        }else{
            _uploadTime = @"0";
        }
        
        if ([propertyDic.allKeys containsObject:@"isExperience"]) {
            _isExperience = [propertyDic objectForKey:@"isExperience"];
        }else{
            _isExperience = [NSNumber numberWithInt:1];
        }
        
        if ([propertyDic.allKeys containsObject:@"pushEnable"]) {
            _pushEnable = [propertyDic objectForKey:@"pushEnable"];
        }else{
            _pushEnable = [NSNumber numberWithInt:1];
        }
        
        if ([propertyDic.allKeys containsObject:@"address"]) {
            _address = [propertyDic objectForKey:@"address"];
        }else{
            _address = [NSDictionary dictionary];
        }
        
        
        
    }
    return self;
}

-(NSDictionary *)getDictionary{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[super getDictionary]];
    
    if (_userName) [dic setObject:_userName forKey:@"userName"];
    if (_account)     [dic setObject:_account forKey:@"account"];
    if (_password)  [dic setObject:_password forKey:@"password"];
    if (_nickName)  [dic setObject:_nickName forKey:@"nickname"];
    if (_avatarUrl)  [dic setObject:_avatarUrl forKey:@"avatarUrl"];
    if (_userId)  [dic setObject:_userId forKey:@"userID"];
    if (_authorize)  [dic setObject:_authorize forKey:@"authorize"];
    if (_accessToken)  [dic setObject:_accessToken forKey:@"access-token"];
    
    
    //用户拓展属性
    NSMutableDictionary *propertyDic = [NSMutableDictionary dictionary];
    if (_uploadTime) [propertyDic setObject:_uploadTime forKey:@"uploadTime"];
    
    if (_isExperience)  [propertyDic setObject:_isExperience forKey:@"isExperience"];
    
    if (_address) [propertyDic setObject:_address forKey:@"address"];
    
    if (_pushEnable)  [propertyDic setObject:_pushEnable forKey:@"pushEnable"];
    
    [dic setObject:propertyDic forKey:@"weichengProperty"];
    
    return [NSDictionary dictionaryWithDictionary:dic];
}

-(void)setWeichengProperty:(NSDictionary *)propertyDic{
    NSString *uploadTime = [propertyDic objectForKey:@"uploadTime"];
    if (uploadTime.doubleValue > _uploadTime.doubleValue) {
        _uploadTime = [propertyDic objectForKey:@"uploadTime"];
        _isExperience =  [propertyDic objectForKey:@"isExperience"];
        _address = [propertyDic objectForKey:@"address"];
        _pushEnable = [propertyDic objectForKey:@"pushEnable"];
        
        [DATASOURCE saveUserWithIsUpload:NO];
    }else if (uploadTime.doubleValue < _uploadTime.doubleValue){
        [DATASOURCE saveUserWithIsUpload:YES];
    }
}

- (NSString *)base64Encode:(NSString *)str
{
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *encodeStr = [data base64EncodedStringWithOptions:0];
    
    return encodeStr;
}

- (NSString *)base64Decode:(NSString *)encodeStr
{
    if (encodeStr.length == 0) {
        return nil;
    }
    NSData *data = [[NSData alloc] initWithBase64EncodedString:encodeStr options:0];
    
    NSString *decodeStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return decodeStr;
}

@end
