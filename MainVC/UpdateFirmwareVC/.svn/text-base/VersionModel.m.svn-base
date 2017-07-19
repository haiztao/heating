//
//  VersionModel.m
//  heating
//
//  Created by haitao on 2017/3/10.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "VersionModel.h"

@implementation VersionModel
-(id)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        if ([dict.allKeys containsObject:@"current"]) {
            _current = [dict objectForKey:@"current"];
        }
        if ([dict.allKeys containsObject:@"description"]) {
            _msgDescription = [dict objectForKey:@"description"];
        }
        if ([dict.allKeys containsObject:@"newest"]) {
            _newest = [dict objectForKey:@"newest"];
        }
       
       
    }
    return self;
}
@end
