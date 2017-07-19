//
//  HTUpdateTableViewCell.h
//  heating
//
//  Created by haitao on 2017/2/15.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTUpdateDelegate <NSObject>

-(void)clickUpdateWithIndexPath:(NSInteger)indexPath;

@end

@interface HTUpdateTableViewCell : UITableViewCell

@property (weak,nonatomic)id<HTUpdateDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;

@end
