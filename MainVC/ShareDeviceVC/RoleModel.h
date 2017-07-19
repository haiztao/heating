//
//  RoleModel.h
//  heating
//
//  Created by haitao on 2017/3/10.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoleModel : NSObject

@property (nonatomic,strong) NSString *from_id;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *role;
@property (nonatomic,strong) NSString *user_id;
-(id)initWithDict:(NSDictionary *)dict;
@end
