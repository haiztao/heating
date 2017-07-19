//
//  MessageTableViewCell.m
//  heating
//
//  Created by haitao on 2017/2/10.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIsRead:(BOOL)isRead{
    if (isRead) {
        self.redPointImageView.hidden = YES;
    }else{
        self.redPointImageView.hidden = NO;
    }
}

-(void)setMsgModel:(MessageModel *)msgModel{
    self.detailLabel.text = [NSString stringWithFormat:@"%@ %@",msgModel.deviceName,msgModel.content];
    self.timeLabel.text = msgModel.create_date;
    if ([msgModel.is_read intValue] == 0) {
//        self.redPointImageView.hidden = NO;
        self.detailLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        self.timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    }else{
        self.detailLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        self.timeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
//        self.redPointImageView.hidden = YES;
    }
}


@end
