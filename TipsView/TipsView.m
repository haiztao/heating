//
//  TipsView.m
//  heating
//
//  Created by haitao on 2017/3/28.
//  Copyright © 2017年 haitao. All rights reserved.
//


#import "TipsView.h"
#import "AppDelegate.h"

#define AlertPadding 50
#define MenuHeight 45

#define AlertHeight 200
#define AlertWidth 240//([UIScreen mainScreen].bounds.size.width - 80)
#define iconWH 68

#define titleFont [UIFont systemFontOfSize:20]

#define messageFont [UIFont systemFontOfSize:17]

#define YColorRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@implementation TipsView

- (instancetype)initWithIconName:(NSString *)iconName withTitle:(NSString *)title withMessage:(NSString *)message{
    self = [super init];
    if (self) {
        _title  = title;
        _message = message;
        _iconImage = [UIImage imageNamed:iconName];
        [self buildViews];
    }
    return self;
}
-(void)buildViews{
    //遮盖层
    self.frame = [self screenBounds];
    
    _coverView = [[UIView alloc]initWithFrame:[self topView].bounds];
    _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    //    _coverView.alpha = 0;
    _coverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:_coverView];
    
    //对话框背景
    _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, AlertWidth, AlertHeight)];
    _alertView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _alertView.layer.cornerRadius = 10;
    _alertView.layer.masksToBounds = YES;
    _alertView.backgroundColor = YColorRGB(0x44, 0x4d, 0x51);
    [self addSubview:_alertView];

    CGFloat alertViewHeight = AlertPadding;
    //图标
    if (_iconImage) {
        _iconView = [[UIImageView alloc]initWithFrame:CGRectMake((AlertWidth-iconWH)/2, AlertPadding, iconWH, iconWH)];
        _iconView.image = _iconImage;
        [_alertView addSubview:_iconView];
        alertViewHeight += iconWH/2+_iconView.y;
    }
    //标题
    if (_title.length) {
        CGFloat labelHeight = [self heightWithString:_title font:titleFont width:AlertWidth-2*AlertPadding];
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake( AlertPadding,alertViewHeight, AlertWidth-2*AlertPadding, labelHeight)];
        _labelTitle.font = titleFont;
        _labelTitle.textColor = [UIColor whiteColor];
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        _labelTitle.numberOfLines = 0;
        _labelTitle.text = _title;
        _labelTitle.lineBreakMode = NSLineBreakByCharWrapping;
        [_alertView addSubview:_labelTitle];
        
        alertViewHeight+=labelHeight+AlertPadding;
    }
    
    //消息
    if (_message.length) {
        CGFloat messageHeight = [self heightWithString:_message font:messageFont width:AlertWidth-2*AlertPadding];
        _labelmessage =  [[UILabel alloc]initWithFrame:CGRectMake(AlertPadding, alertViewHeight, AlertWidth-2*AlertPadding, messageHeight)];
        _labelmessage.font = messageFont;
        _labelmessage.textColor = YColorRGB(0x91, 0xa0, 0xa7);
        _labelmessage.textAlignment = NSTextAlignmentCenter;
        _labelmessage.text = _message;
        _labelmessage.numberOfLines = 0;
        _labelmessage.lineBreakMode = NSLineBreakByCharWrapping;
        [_alertView addSubview:_labelmessage];
        alertViewHeight +=messageHeight+AlertPadding;
    }
    
    _alertView.bounds = CGRectMake(_alertView.bounds.origin.x, _alertView.bounds.origin.y, AlertWidth, alertViewHeight+MenuHeight);
    
    _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    
    [_alertView addSubview:_contentScrollView];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)dealloc
{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (CGFloat)heightWithString:(NSString*)string font:(UIFont *)font width:(CGFloat)width
{
    NSDictionary *attrs = @{NSFontAttributeName:font};
    return  [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.height;
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
  
    [self reLayout];
}

-(void)reLayout{
  
    _alertView.frame = CGRectMake(_alertView.frame.origin.x, _alertView.frame.origin.y, AlertWidth, AlertHeight);
    _alertView.center = self.center;
    [self setNeedsDisplay];
    [self setNeedsLayout];
}
#pragma mark - show and dismiss
- (UIView*)topView{
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return  app.window;
}
- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    } completion:^(BOOL finished) {
        
    }];
    [[self topView] addSubview:self];
    [self showAnimation];

}
- (void)dismiss {
    [self hideAnimation];
}


- (void)showAnimation {
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.2;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2f, 1.2f, 1.0f)],
                            
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f,@1.0f];
    
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [_alertView.layer addAnimation:popAnimation forKey:nil];
}

- (void)hideAnimation{
    [UIView animateWithDuration:0.4 animations:^{
        _coverView.alpha = 0.0;
        _alertView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Handle device orientation changes
// Handle device orientation changes
- (void)deviceOrientationDidChange: (NSNotification *)notification
{
    self.frame = [self screenBounds];
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         [self reLayout];
                     }
                     completion:nil
     ];
}
- (CGRect)screenBounds
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // On iOS7, screen width and height doesn't automatically follow orientation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            CGFloat tmp = screenWidth;
            screenWidth = screenHeight;
            screenHeight = tmp;
        }
    }
    
    return CGRectMake(0, 0, screenWidth, screenHeight);
}

@end
