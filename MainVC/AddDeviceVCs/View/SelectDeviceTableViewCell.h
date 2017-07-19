//
//  SelectDeviceTableViewCell.h
//  heating
//
//  Created by haitao on 2017/2/13.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SelectDeviceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (nonatomic,assign) BOOL isSelect;

@end
