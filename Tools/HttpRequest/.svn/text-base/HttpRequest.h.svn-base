//
//  HttpRequest.h
//  HttpRequest
//
//  Created by xtmac on 29/10/15.
//  Copyright (c) 2015年 xtmac. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CorpId @"100fa2ad2eae7000" // 企业id
#define APN_APP_ID @"2e0fa2b16ef3c800" //apns 应用id

//错误信息
#define CustomErrorDomain @"cn.xlink.httpRequest"  //正式服务器

#define ErrInfo(ErrCode) [HttpRequest getErrorInfoWithErrorCode:(ErrCode)]

typedef void (^MyBlock) (id result, NSError *err);


@interface DeviceObject : NSObject

@property (strong, nonatomic) NSString *product_id;
@property (strong, nonatomic) NSString *mac;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *access_key;
@property (strong, nonatomic) NSString *mcu_mod;
@property (strong, nonatomic) NSString *mcu_version;
@property (strong, nonatomic) NSString *firmware_mod;
@property (strong, nonatomic) NSString *firmware_version;

-(instancetype)initWithProductID:(NSString *)product_id withMac:(NSString *)mac withAccessKey:(NSNumber *)accessKey;

@end

@interface HttpRequest : NSObject

/**
 *  根据错误码获取错误信息
 *
 *  @param errCode 错误码
 *
 *  @return 错误信息
 */
+(NSString *)getErrorInfoWithErrorCode:(NSInteger)errCode;

#pragma mark
#pragma mark 用户开发接口

/**
 *  1、用户请求发送验证码（邮箱方式不需要获取验证码）
 *
 *  @param phone 手机号码
 *  @param block 完成后的回调
 */
+(void)getVerifyCodeWithPhone:(NSString *)phone captcha:(NSString *)captcha didLoadData:(MyBlock)block;
//获取图形验证码
+(void)getImageVerifyCodeWithPhone:(NSString *)phone didLoadData:(MyBlock)block;

/**
 *  2、注册账号
 *
 *  @param account    账号：手机号码/邮箱地址
 *  @param nickname   昵称
 *  @param verifyCode 验证码（邮箱注册不需要验证码）
 *  @param pwd        密码
 *  @param block      完成后的回调
 */
+(void)registerWithAccount:(NSString *)account withNickname:(NSString *)nickname withVerifyCode:(NSString *)verifyCode withPassword:(NSString *)pwd didLoadData:(MyBlock)block;

/**
 *  5、用户认证(登录)
 *
 *  @param account 账号 : 手机号码/邮箱地址
 *  @param pwd     密码
 *  @param block   完成后的回调
 */
+(void)authWithAccount:(NSString *)account withPassword:(NSString *)pwd didLoadData:(MyBlock)block;

/**
 *  刷新调用凭证
 *
 *  @param accessToken  调用凭证
 *  @param refreshToken 刷新凭证
 *  @param block        完成后的回调
 */
+(void)refreshAccessToken:(NSString *)accessToken withRefreshToken:(NSString *)refreshToken didLoadData:(MyBlock)block;

/**
 *  7、修改账号昵称
 *
 *  @param nickname    要修改的昵称
 *  @param userID      用户ID
 *  @param accessToken 调用凭证
 */
+(void)modifyAccountNickname:(NSString *)nickname withUserID:(NSNumber *)userID withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  8、重置密码
 *
 *  @param oldPwd      旧密码
 *  @param newPwd      新密码
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)resetPasswordWithOldPassword:(NSString *)oldPwd withNewPassword:(NSString *)newPwd withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  9.1、忘记密码(获取重置密码的验证码)
 *
 *  @param account     忘记密码的账号
 *  @param block       完成后的回调
 * captcha 图形码
 */
+(void)forgotPasswordWithAccount:(NSString *)account captcha:(NSString *)captcha didLoadData:(MyBlock)block;

/**
 *  9.2、找回密码(根据获取到的验证码设置新密码)
 *
 *  @param account     要找回密码的账号
 *  @param verifyCode  验证码
 *  @param pwd         要设置的新密码
 *  @param block       完成后的回调
 */
+(void)foundBackPasswordWithAccount:(NSString *)account withVerifyCode:(NSString *)verifyCode withNewPassword:(NSString *)pwd didLoadData:(MyBlock)block;
#pragma mark 9.3、注册用户请求图形验证码
+(void)getPasswordImageVerifyCodeWithPhone:(NSString *)phone didLoadData:(MyBlock)block;
/**
 *  11、取消订阅
 *
 *  @param userID      用户ID
 *  @param accessToken 调用凭证
 *  @param deviceID    设备ID
 *  @param block       完成后的回调
 */
+(void)unsubscribeDeviceWithUserID:(NSNumber *)userID withAccessToken:(NSString *)accessToken withDeviceID:(NSNumber *)deviceID didLoadData:(MyBlock)block;

/**
 *  12、获取该企业下注册的用户列表
 *
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)getUserListWithAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  13、获取用户详细信息
 *
 *  @param userID      用户id
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)getUserInfoWithUserID:(NSNumber *)userID withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  14、获取设备列表
 *
 *  @param userID      用户ID
 *  @param accessToken 调用凭证
 *  @param version     当前列表的版本号，根据当前版本号判定列表有无更改。
 *  @param block       完成后的回调
 */
+(void)getDeviceListWithUserID:(NSNumber *)userID withAccessToken:(NSString *)accessToken withVersion:(NSNumber *)version didLoadData:(MyBlock)block;

/**
 *  15、获取设备的订阅用户列表
 *
 *  @param userID      用户ID
 *  @param deviceID    设备ID
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)getDeviceUserListWithUserID:(NSNumber *)userID withDeviceID:(NSNumber *)deviceID withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  16、设置用户扩展属性
 *
 *  @param dic         扩展属性字典
 *  @param userID      用户ID
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)setUserPropertyDictionary:(NSDictionary *)dic withUserID:(NSNumber *)userID withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  17、获取用户扩展属性
 *
 *  @param userID      用户ID
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)getUserPropertyWithUserID:(NSNumber *)userID withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  18、修改用户扩展属性
 *
 *  @param dic         扩展属性字典
 *  @param userID      用户ID
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)modifyUserPropertyDictionary:(NSDictionary *)dic withUserID:(NSString *)userID withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  19、获取用户单个扩展属性
 *
 *  @param userID      用户ID
 *  @param key         属性Key值
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)getUserSinglePropertyWithUserID:(NSNumber *)userID withPropertyKey:(NSString *)key withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  20、删除用户扩展属性
 *
 *  @param userID      用户ID
 *  @param key         属性Key值
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)delUserPropertyWithUserID:(NSNumber *)userID withPropertyKey:(NSString *)key withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  21、停用用户
 *
 *  @param userID      用户ID
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)disableUserWithUserID:(NSNumber *)userID withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  22、更新用户所在区域
 *
 *  @param userID      用户ID
 *  @param areaID      区域ID
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)UpdateUserAreaWithUserID:(NSNumber *)userID withAreaID:(NSString *)areaID withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  23、用户注册APN服务
 *
 *  @param userID      用户ID
 *  @param appID       用户在XLINK平台创建APP开发时，获取到的ID
 *  @param deviceToken iOS APP 运行时获取到的device_token
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)registerAPNServiceWithUserID:(NSNumber *)userID withDeviceToken:(NSString *)deviceToken withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  24、用户停用APN服务
 *
 *  @param userID      用户ID
 *  @param appID       用户在XLINK平台创建APP开发时，获取到的ID
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)disableAPNServiceWithUserID:(NSNumber *)userID withAppID:(NSString *)appID withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  25、获取用户注册的APN服务信息列表
 *
 *  @param userID      用户ID
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)getUserAPNServiceInfoWithUserID:(NSNumber *)userID withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;


#pragma mark
#pragma mark 数据存储服务开发接口


/**
 *  6、新增数据
 *
 *  @param dic          数据字典{字段A：字段A的值}
 *  @param tableName   表名
 *  @param accessToken 调用凭证
 *  @param block        完成后的回调
 */
-(void)addData:(NSDictionary *)dic withTableName:(NSString *)tableName withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;



/**
 *  8、查询数据
 *
 *  @param tableName   表名
 *  @param accessToken 调用凭证
 *  @param block        完成后的回调
 */
-(void)queryDataWithTableName:(NSString *)tableName withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  9、修改数据
 *
 *  @param dic          数据字典
 *  @param tableName   表名
 *  @param objectID    字段ID
 *  @param accessToken 调用凭证
 *  @param block        完成后的回调
 */
-(void)modifyData:(NSDictionary *)dic withTableName:(NSString *)tableName withObjectID:(NSString *)objectID withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  10、删除数据
 *
 *  @param tableName   表名
 *  @param objectID    字段ID
 *  @param accessToken 调用凭证
 *  @param block        完成后的回调
 */
-(void)delDataWithTableName:(NSString *)tableName withObjectID:(NSString *)objectID withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;


#pragma mark
#pragma mark 设备开发接口

/**
 *  15、获取产品数据端点列表
 *
 *  @param productID   产品ID
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)getDataPointListWithProductID:(NSString *)productID withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  20、添加设备
 *
 *  @param mac          设备的mac地址
 *  @param productID    设备的产品ID
 *  @param accessToken 调用凭证
 *  @param block        完成后的回调
 */
+(void)addDeviceWithMacAddress:(NSString *)mac withProductID:(NSString *)productID withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  21、导入设备
 *
 *  @param macArr      设备的mac地址的数组
 *  @param productID   设备的产品ID
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)importDeviceWithMacAddressArr:(NSArray *)macArr withProductID:(NSString *)productID withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  22、获取设备信息
 *
 *  @param deviceID    设备ID
 *  @param productID   设备的产品ID
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)getDeviceInfoWithDeviceID:(NSNumber *)deviceID withProductID:(NSString *)productID withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  23、修改设备信息
 *
 *  @param deviceID    设备ID
 *  @param dic         要修改的设备信息字典
 *  @param productID   设备的产品ID
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)modifyDeviceInfoWithDeviceID:(NSNumber *)deviceID withInfoDic:(NSDictionary *)dic withProductID:(NSString *)productID withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  24、查询设备列表
 *
 *  @param productID   要查询的设备的产品ID
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)queryDeviceListWithProductID:(NSString *)productID withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  25、删除设备
 *
 *  @param deviceID    设备ID
 *  @param productID   设备的产品ID
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)delDeviceWithDeviceID:(NSNumber *)deviceID withProductID:(NSString *)productID withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  26、设置设备扩展属性
 *
 *  @param dic         属性字典
 *  @param deviceID    设备ID
 *  @param productID   设备的产品ID
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)setDevicePropertyDictionary:(NSDictionary *)dic withDeviceID:(NSNumber *)deviceID withProductID:(NSString *)productID withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  27、修改设备扩展属性
 *
 *  @param dic         属性字典
 *  @param deviceID    设备ID
 *  @param productID   设备的产品ID
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)modifyDevicePropertyDictionary:(NSDictionary *)dic withDeviceID:(NSNumber *)deviceID withProductID:(NSString *)productID withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  28、获取设备扩展属性
 *
 *  @param deviceID    设备ID
 *  @param productID   设备的产品ID
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)getDevicePropertyWithDeviceID:(NSNumber *)deviceID withProductID:(NSString *)productID withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;


#pragma mark
#pragma mark 分享接口


/**
 *  分享设备
 *
 *  @param deviceID    被分享的设备的ID
 *  @param accessToken 调用凭证
 *  @param account       被分享的用户的email地址
 *  @param expire      分享消息的有效时间
 *  @param mode        分享方式
 *  @param block       完成后的回调
 */
+(void)shareDeviceWithDeviceID:(NSNumber *)deviceID withAccessToken:(NSString *)accessToken withShareAccount:(NSString *)account withExpire:(NSNumber *)expire withMode:(NSString *)mode didLoadData:(MyBlock)block;

/**
 *  取消分享
 *
 *  @param accessToken 调用凭证
 *  @param inviteCode  邀请码
 *  @param block       完成后的回调
 */
+(void)cancelShareDeviceWithAccessToken:(NSString *)accessToken withInviteCode:(NSString *)inviteCode didLoadData:(MyBlock)block;

/**
 *  接受分享
 *
 *  @param inviteCode  邀请码
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)acceptShareWithInviteCode:(NSString *)inviteCode withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  拒绝分享
 *
 *  @param inviteCode  邀请码
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)denyShareWithInviteCode:(NSString *)inviteCode withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  获取分享列表
 *
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)getShareListWithAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *  管理员或用户删除这条分享请求记录
 *
 *  @param inviteCode  邀请码
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+(void)delShareRecordWithInviteCode:(NSString *)inviteCode withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

#pragma mark 不公开接口
/**
 *  向云端注册设备
 *
 *  @param userID       用户ID
 *  @param accessToken  调用凭证
 *  @param deviceObject 要注册的设备
 *  @param block        完成后的回调
 */
+(void)registerDeviceWithUserID:(NSNumber *)userID withAccessToken:(NSString *)accessToken withDevice:(DeviceObject *)deviceObject didLoadData:(MyBlock)block;

//新增接口
//校验手机验证码
+(void)checkTheVerityCodeWithPhoneNumber:(NSString *)phoneNumber code:(NSString *)code didLoadData:(MyBlock)block;

/**
 *  上传头像
 *
 *  @param avatarData  头像图片data
 *  @param accessToken     accessToken
 *  @param block       完成后的回调
 */
+(void)uploadAvatarWithAccessToken:(NSString *)accessToken andIconData:(NSData *)avatarData didUpload:(MyBlock)block;

#pragma mark - 获取固件版本 wen
+(void)getVersionWithDeviceID:(NSString *)device_id withProduct_id:(NSString *)product_id withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

/**
 *   升级固件
 */
+(void)upgradeWithDeviceID:(NSString *)device_id withProduct_id:(NSString *)product_id withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

#pragma mark - 获取消息列表
+ (void)getMessageWithUserid:(NSNumber *)userid withAccessToken:(NSString *)accessToken WithwithQueryDict:(NSDictionary *)dict didLoadData:(MyBlock)block;
#pragma mark - 设置消息为已读
+(void)setMessageIsReadWithUserid:(NSNumber *)userid withAccessToken:(NSString *)accessToken WithDictory:(NSDictionary *)dict didLoadData:(MyBlock)block;
#pragma mark - 设置消息已读
+(void)readMessageListWithUserid:(NSNumber *)userid withMessageIdList:(NSArray<NSNumber *> *)msgIdList withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

#pragma mark -- 通过二维码添加设备
+(void)qrcodeSubscribeWithUserID:(NSNumber *)userID withAccessToken:(NSString *)accessToken withqrcodeContent:(NSString *)qrcodeContent didLoadData:(MyBlock)block;
#pragma mark 22、用户注册APN服务
+(void)registerAPNServiceWithUserID:(NSNumber *)userID withAppID:(NSString *)appID withDeviceToken:(NSString *)deviceToken withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;
#pragma mark - 设备id下的用户列表
+(void)getUserListWithDeviceID:(NSNumber *)deviceID withUserID:(NSNumber *)userID withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;
/**
 *  获取设备告警日志列表
 *
 *  @param product_id  产品id
 *  @param deviceID    设备id
 *  @param dic         查询条件
 *  @param accessToken 调用凭证
 *  @param block       完成后的回调
 */
+ (void)getDeviceAlertLogsWithProductID:(NSString *)product_id withDeviceID:(NSNumber *)deviceID withQueryDict:(NSDictionary *)dic withAccessToken:(NSString *)accessToken didLoadData:(MyBlock)block;

@end
