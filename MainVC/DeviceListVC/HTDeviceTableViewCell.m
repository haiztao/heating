//
//  HTDeviceTableViewCell.m
//  heating
//
//  Created by haitao on 2017/2/9.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "HTDeviceTableViewCell.h"

@interface HTDeviceTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceStateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *deviceStateImageView;
@end

@implementation HTDeviceTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setDeviceModel:(DeviceModel *)deviceModel{

    if (deviceModel.is_online == YES) {
        self.deviceImageView.image = [UIImage imageNamed:@"index_device_ic"];
        self.deviceNameLabel.textColor = [UIColor colorWithHex:0x2c363a];
        self.deviceStateLabel.text = LocalizedString(@"设备在线");
        self.deviceStateImageView.image = [UIImage imageNamed:@"wifi_online_ic"];
    }else{
        self.deviceImageView.image = [UIImage imageNamed:@"index_device_offline_ic"];
        self.deviceNameLabel.textColor = [UIColor colorWithHex:0xd1d1d1];
        self.deviceStateLabel.text = LocalizedString(@"设备离线");
        self.deviceStateImageView.image = [UIImage imageNamed:@"wifi_offline_ic"];
    }
    if (deviceModel.name == nil || [deviceModel.name isEqualToString:@""]) {
        self.deviceNameLabel.text = [NSString stringWithFormat:@"%@",deviceModel.device.deviceName];
    }else{
        self.deviceNameLabel.text = [NSString stringWithFormat:@"%@",deviceModel.name];
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
