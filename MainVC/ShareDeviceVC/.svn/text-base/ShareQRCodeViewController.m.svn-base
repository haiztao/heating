//
//  ShareQRCodeViewController.m
//  heating
//
//  Created by haitao on 2017/2/28.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "ShareQRCodeViewController.h"

@interface ShareQRCodeViewController ()
{
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UIImageView *QRImageView;

@end

@implementation ShareQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUIWithTag:101 headerColorIsWhite:NO andTitle:LocalizedString(@"分享我的设备") rightBtnText:nil];
    self.whiteView.layer.masksToBounds = YES;
    self.whiteView.layer.cornerRadius = 10;
    
    
    if (self.isNoneNetwork) {
        [self buildNoneNetWorkView];
    }else{
        [self setQrcodeImageWithString:self.inviteCode];
    }
    
   
    
}

-(void)buildNoneNetWorkView{
    [self setupNetworkUnavailableWithTipMsg:NSLocalizedString(@"请检查网络连接并尝试重新生成", nil) title:NSLocalizedString(@"生成二维码失败", nil) retryBtnTitle:NSLocalizedString(@"重试", nil)];
}

#pragma mark - 点击重试
-(void)retryToRefreshDataSuorce{
    [self.noneNetworkView removeFromSuperview];
    [self addNewShareDevice];
}

//重试
-(void)addNewShareDevice{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpRequest shareDeviceWithDeviceID:self.deviceID withAccessToken:DATASOURCE.userModel.accessToken withShareAccount:nil withExpire:@(7200) withMode:@"qrcode" didLoadData:^(id result, NSError *err) {
        
        //移除HUD
        [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            if (err) {
                [self buildNoneNetWorkView];
            }else{
                [self.noneNetworkView removeFromSuperview];
                 NSLog(@"分享 ：%@",result);
                 NSString *inviteCode = [result objectForKey:@"invite_code"];
                [self setQrcodeImageWithString:inviteCode];
            }
        });
    }];
}


- (void)setQrcodeImageWithString:(NSString *)inviteCode{
    
    NSData *data =[inviteCode dataUsingEncoding:NSUTF8StringEncoding];
    //base64位加密
    NSString *base64Str = [data base64EncodedStringWithOptions:0];
    NSData *base64Data = [base64Str dataUsingEncoding:NSUTF8StringEncoding];
    
    //二维码滤镜
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //恢复滤镜的默认属性
    [filter setDefaults];
    
    //通过KVO设置滤镜inputmessage数据
    [filter setValue:base64Data forKey:@"inputMessage"];
    
    //获得滤镜输出的图像
    CIImage *outputImage=[filter outputImage];
    
    //将CIImage转换成UIImage,并放大显示
    self.QRImageView.image=[self createNonInterpolatedUIImageFormCIImage:outputImage withSize:self.QRImageView.width];
}

//改变二维码大小

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
