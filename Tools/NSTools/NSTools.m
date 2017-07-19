//
//  NSTools.m
//  lightify
//
//  Created by xtmac on 23/2/16.
//  Copyright © 2016年 xtmac. All rights reserved.
//

#import "NSTools.h"
#import "UserModel.h"
#import "BaseViewController.h"

@interface NSTools ()

@end

@implementation NSTools

+(void)showShareInvited:(NSNotification *)notice hadInvitedBlock:(void (^)(NSDictionary *dictionary))hadInvited notInvited:(void (^)(NSString *notInvi))notInvited{

    
    [HttpRequest getShareListWithAccessToken:DATASOURCE.userModel.accessToken didLoadData:^(id result, NSError *err) {
        
        //[hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
        
        NSMutableArray *tempListArr = [NSMutableArray array];
        if (!err) {
            tempListArr = result;
            
            for (NSDictionary *dic in tempListArr) {
                //NSLog(@"设备分享消息：%@，%@",dic[@"state"],dic[@"to_user"]);
                if ( [[dic objectForKey:@"state"] isEqual:@"pending"] &&  [[dic objectForKey:@"to_user"] isEqual:[NSString stringWithFormat:@"%@",DATASOURCE.userModel.account]]) {
                    
                    if (hadInvited) {
                        hadInvited(dic);
                        //NSLog(@"hadInvited------有数据");
                    }
                    
                }else{
                    
                    if (notInvited) {
                        //notInvited(@"没有数据");
                    }
                }
            }
            
        }else{
            
        }
    }];
    
}

+(int)getBinaryNum:(short)num byte:(int)bytes{
    
    return num>>bytes & 0x01;
}

// 检查网络连接状态
+ (BOOL)isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    return isExistenceNetwork;
}

+(NSString *)dataToHex:(NSData *)data{
    NSMutableString *hex = [NSMutableString string];
    const unsigned char *hexChar = data.bytes;
    for (NSUInteger i = 0; i < data.length; i++) {
        [hex appendFormat:@"%02x", hexChar[i]];
    }
    return [NSString stringWithString:hex];
}

+(NSData *)hexToData:(NSString *)hexString{
    NSUInteger len = hexString.length / 2;
    const char *hexCode = [hexString UTF8String];
    char * bytes = (char *)malloc(len);
    
    char *pos = (char *)hexCode;
    for (NSUInteger i = 0; i < hexString.length / 2; i++) {
        sscanf(pos, "%2hhx", &bytes[i]);
        pos += 2 * sizeof(char);
    }
    
    NSData * data = [[NSData alloc] initWithBytes:bytes length:len];
    
    free(bytes);
    return data;
}

+(CalendarDate)dateToCalendar:(NSDate *)date{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dd = [cal components:unitFlags fromDate:date];
    CalendarDate calendarDate;
    calendarDate.year = [dd year];
    calendarDate.month = [dd month];
    calendarDate.day = [dd day];
    calendarDate.hour = [dd hour];
    calendarDate.minute = [dd minute];
    calendarDate.second = [dd second];
    return calendarDate;
}

+(NSDate *)calendarToDate:(CalendarDate)calendarDate{
    NSString *dateString = [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d", calendarDate.year, calendarDate.month, calendarDate.day, calendarDate.hour, calendarDate.minute, calendarDate.second];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:dateString];
}

//判断文件是否存在

+(BOOL) fileIsExists:(NSString*) checkFile{
    return  [[NSFileManager defaultManager]fileExistsAtPath:checkFile];
}

#pragma mark 邮箱正则表达式
+(BOOL)validateEmail:(NSString *)email{
    
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:email];
    
}


#pragma mark 手机号码正则表达式
+(BOOL)validatePhone:(NSString *)phone{
    
    NSString *regex = @"^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:phone];
}


/**
 *  密码不能含有英文和数字以外的字符
 *  密码必须为6-20位
 */
#pragma mark 密码正则表达式
+ (BOOL)validatePassword:(NSString *)password {
    NSString *regex = @"^[!-~]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:password];
}

+(BOOL)isChineseCharacterAndLettersAndNumbersAndUnderScore:(NSString *)string
{
    NSString *other = @"";
    NSInteger len = string.length;
    for(int i=0;i<len;i++)
    {
        unichar a=[string characterAtIndex:i];
        if(!((isalpha(a))
             ||(isalnum(a))
             ||((a=='_'))
             ||((a >= 0x4e00 && a <= 0x9fa6))
             ||([other rangeOfString:string].location != NSNotFound)
             ))
            return NO;
    }
    return YES;
}

+(BOOL)judgePassWordLegal:(NSString *)pass{
    
    BOOL result ;
    
    // 判断长度大于6位后再接着判断是否同时包含数字和大小写字母
    
    NSString * regex =@"(?![0-9A-Z]+$)(?![0-9a-z]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$ ";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    result = [pred evaluateWithObject:pass];
    
    return result;
    
}
    
@end
