//
//  NSString+Extension.h
//  
//
//  Created by apple on 14-10-18.
//  Copyright (c) 2014年 Allen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

/**
 *  计算字符串的尺寸
 *
 *  @param font 字体
 *
 *  @return 字符串所占的位置的尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font;

/**
 *  计算字符串的尺寸
 *
 *  @param font 字体
 *  @param maxW 最大宽度
 *
 *  @return 字符串所占的位置的尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;


/**
 *  字符串转md5加密字符串
 *
 *  @param input 字符串
 *
 *  @return md5加密字符串
 */
+ (NSString *) stringToMD5:(NSString *)input;


/**
 *  普通字符串转换为十六进制的字符串
 *
 *  @param string 普通字符串
 *
 *  @return 十六进制的字符串
 */
+ (NSString *)hexStringFromString:(NSString *)string;

/**
 *  十六进制的字符串转换为普通字符串
 *
 *  @param hexString 十六进制的字符串
 *
 *  @return 普通字符串
 */
+ (NSString *)stringFromHexString:(NSString *)hexString;

@end
