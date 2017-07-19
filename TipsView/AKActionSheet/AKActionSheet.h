//
//  AKActionSheet.h
//  Fotile
//
//  Created by AllenKwok on 16/6/2.
//  Copyright © 2016年 xlink.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AKActionSheet;

@protocol AKActionSheetDelegate <NSObject>

@optional

/**
 *  点击按钮
 */
- (void)actionSheet:(AKActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface AKActionSheet : UIView

@property (copy, nonatomic)  void(^touchBlock)(NSUInteger);

/**
 *  代理
 */
@property (nonatomic, weak) id <AKActionSheetDelegate> delegate;

/**
 *  创建对象方法
 */
- (instancetype)initWithDelegate:(id<AKActionSheetDelegate>)delegate CancelTitle:(NSString *)cancelTitle OtherTitles:(NSString*)otherTitles,... NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithTitle:(NSString *)title delegate:( id<AKActionSheetDelegate>)delegate cancelButtonTitle:( NSString *)cancelButtonTitle destructiveButtonTitle:( NSString *)destructiveButtonTitle otherButtonTitles:( NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION ;

- (instancetype)initWithTitle:(NSString *)title delegate:( id<AKActionSheetDelegate>)delegate cancelButtonTitle:( NSString *)cancelButtonTitle destructiveButtonTitle:( NSString *)destructiveButtonTitle otherButtonTitleArray:(NSArray *)titleArray;

- (void)show;

@end
