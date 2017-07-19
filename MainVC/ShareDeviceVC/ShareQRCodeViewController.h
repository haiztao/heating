//
//  ShareQRCodeViewController.h
//  heating
//
//  Created by haitao on 2017/2/28.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "BaseViewController.h"

@interface ShareQRCodeViewController : BaseViewController


@property (nonatomic,strong) NSString *inviteCode;

@property (nonatomic,strong) NSNumber *deviceID; //设备ID
@property (nonatomic,assign) BOOL isNoneNetwork; //网络是否有问题
@end
