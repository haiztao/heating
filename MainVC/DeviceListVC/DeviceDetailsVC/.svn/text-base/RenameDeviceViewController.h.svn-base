//
//  RenameDeviceViewController.h
//  heating
//
//  Created by haitao on 2017/2/14.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "BaseViewController.h"
#import "DeviceModel.h"
@protocol RenameDelegate <NSObject>
@optional
//昵称
-(void)renameSucceedWithNickName:(NSString *)nickName;


@end

@interface RenameDeviceViewController : BaseViewController

@property (nonatomic,weak) id<RenameDelegate>renameDelegate;

@property (nonatomic,strong) NSString *deviceName;

@property (nonatomic,assign) BOOL isAccountTurn;//yes 修改账号昵称 no 修改设备昵称

@property (nonatomic,strong) NSString *titleString;

@property (nonatomic,strong) DeviceModel *device;

@end
