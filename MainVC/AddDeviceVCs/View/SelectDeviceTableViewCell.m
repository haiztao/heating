//
//  SelectDeviceTableViewCell.m
//  heating
//
//  Created by haitao on 2017/2/13.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "SelectDeviceTableViewCell.h"

@implementation SelectDeviceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 5;
}
-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    if (_isSelect == YES) {
        self.backView.backgroundColor = [UIColor colorWithHex:0x2c363a];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.checkImageView.image = [UIImage imageNamed:@"add_check_ic"];
    }else{
        self.backView.backgroundColor = [UIColor colorWithHex:0xe4e4e4];
        self.nameLabel.textColor = [UIColor colorWithHex:0x2c363a];
        self.checkImageView.image = [UIImage imageNamed:@""];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
