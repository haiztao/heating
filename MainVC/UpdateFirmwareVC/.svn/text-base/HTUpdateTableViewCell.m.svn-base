//
//  HTUpdateTableViewCell.m
//  heating
//
//  Created by haitao on 2017/2/15.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "HTUpdateTableViewCell.h"

@implementation HTUpdateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.updateBtn.layer.cornerRadius = 5;
    self.updateBtn.layer.masksToBounds = YES;
}
- (IBAction)upgradeTheDevice:(UIButton *)sender {
    sender.enabled = NO;
    if ([self.delegate respondsToSelector:@selector(clickUpdateWithIndexPath:)]) {
        [self.delegate clickUpdateWithIndexPath:sender.tag];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
