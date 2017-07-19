//
//  MessageModel.h
//  heating
//
//  Created by haitao on 2017/3/1.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

//@property (nonatomic,strong) NSString *deviceName;
//@property (nonatomic,strong) NSString *content;
//@property (nonatomic,strong) NSString *uploadTime;
//@property (nonatomic,strong) NSString *device_id;
//@property (nonatomic,strong) NSString *is_push;
//
//@property (nonatomic,strong) NSString *notify_type;
//
//@property (nonatomic,assign) BOOL haveRead;

@property (nonatomic,strong) NSString *deviceName;

@property (nonatomic,strong) NSString *alert_name;
@property (nonatomic,strong) NSString *alert_value;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *create_date;
@property (nonatomic,strong) NSString *from;
@property (nonatomic,strong) NSString *msdID;
@property (nonatomic,strong) NSString *is_push;
@property (nonatomic,strong) NSString *is_read;
@property (nonatomic,strong) NSString *notify_type;
@property (nonatomic,strong) NSString *type;

-(id)initWithDictonary:(NSDictionary *)dict;

- (NSString *)getNeedTime:(NSString *)string;



@end
