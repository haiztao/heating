//
//  DeviceDataModel.h
//  heating
//
//  Created by haitao on 2017/3/6.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceEntity.h"

@interface DeviceDataModel : NSObject

@property (nonatomic,assign) BOOL isPowerOn; // power
@property (nonatomic,assign) BOOL isHeat;
@property (nonatomic,assign) int freezeTem; //冷冻温度
@property (nonatomic,assign) int warmTem;//加热温度

@property (nonatomic,assign) int indoorTem;

@property (nonatomic,assign) int outdoorTem;

@property (nonatomic,assign) int outWaterTem;//出水

@property (nonatomic,assign) int inWaterTem;//回水

@property (nonatomic,strong) DeviceEntity *device;

@end
