//
//  ShareDetailViewController.m
//  heating
//
//  Created by haitao on 2017/2/28.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "ShareDetailViewController.h"

#import "ShareQRCodeViewController.h"
#import "DeviceShareModel.h"

@interface ShareDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    MBProgressHUD *hud;
    NSInteger selectIndex;
}
@property (nonatomic,strong) UIButton *addDeviceBtn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *deviceArray;



@end

@implementation ShareDetailViewController

-(NSMutableArray *)deviceArray{
    if (_deviceArray == nil) {
        _deviceArray = [[NSMutableArray alloc]init];
    }
    return _deviceArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self initUIWithTag:101 headerColorIsWhite:NO andTitle:LocalizedString(@"用户列表") rightBtnText:nil];
    [self createTableView];
    [self createAddDeviceBtn];
    
    
}
-(void)createTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, MainWidth, MainHeight - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getShareList];
}

#pragma mark - 获取数据列表
-(void)getShareList{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpRequest getShareListWithAccessToken:DATASOURCE.userModel.accessToken didLoadData:^(id result, NSError *err) {
        //移除HUD
        [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
        if (!err) {
            
            NSArray *array = result;
            NSLog(@"result %@",result);
            [self.deviceArray removeAllObjects];
            for (NSDictionary *dict in array) {
                DeviceShareModel *shareM = [[DeviceShareModel alloc]initWithDict:dict];
                if ([shareM.device_id integerValue] == [self.deviceM.deviceID integerValue]) {
                    if ([shareM.user_id integerValue] != 0 && [shareM.from_id integerValue] == [DATASOURCE.userModel.userId integerValue]) {
                        [self.deviceArray addObject:shareM];
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }else{
            NSLog(@"err:%@",err);
            [self.deviceArray removeAllObjects];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupNetworkUnavailableWithTipMsg:NSLocalizedString(@"用户列表更新失败，请检查网络连接！", nil) title:nil retryBtnTitle:NSLocalizedString(@"刷新", nil)];
            });
        }
    }];

}
#pragma mark - 点击重试
-(void)retryToRefreshDataSuorce{
    [self.noneNetworkView removeFromSuperview];
    [self getShareList];
}



-(void)createAddDeviceBtn{
    UIButton *addDeviceBtn = [[UIButton alloc]initWithFrame:CGRectMake((MainWidth - 85)/2, MainHeight - 85, 85, 85)];
    
    [addDeviceBtn setImage:[UIImage imageNamed:@"index_add_btn"] forState:UIControlStateNormal];
    [addDeviceBtn addTarget:self action:@selector(addNewShareDevice:) forControlEvents:UIControlEventTouchUpInside];
    self.addDeviceBtn = addDeviceBtn;
    [self.view addSubview:self.addDeviceBtn];
}

-(void)addNewShareDevice:(UIButton *)btn{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [HttpRequest shareDeviceWithDeviceID:self.deviceM.deviceID withAccessToken:DATASOURCE.userModel.accessToken withShareAccount:nil withExpire:@(7200) withMode:@"qrcode" didLoadData:^(id result, NSError *err) {
        //移除HUD
        [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];

        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *inviteCode = [result objectForKey:@"invite_code"];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            ShareQRCodeViewController *qrCodeVc = [storyboard instantiateViewControllerWithIdentifier:@"ShareQRCodeViewController"];
            if (err) {
                qrCodeVc.isNoneNetwork = YES;
            }else{
                NSLog(@"分享 ：%@",result);
                qrCodeVc.isNoneNetwork = NO;
                qrCodeVc.inviteCode = inviteCode;
            }

            qrCodeVc.deviceID = self.deviceM.deviceID;
            [self.navigationController pushViewController:qrCodeVc animated:YES];
        });
    }];
}
#pragma mark - tableView dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.deviceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ShareCell"];
    cell.textLabel.textColor = [UIColor colorWithHex:0x2c363a];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:@"share_user_ic"];
    DeviceShareModel *shareM = self.deviceArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",shareM.to_user];
    if ([shareM.state isEqualToString:@"accept"]) {
        cell.detailTextLabel.text = LocalizedString(@"使用中");
        cell.detailTextLabel.textColor = MainYellowColor;
    }else{
        cell.detailTextLabel.text = LocalizedString(@"已取消");
        cell.detailTextLabel.textColor = [UIColor colorWithHex:0xbfbfbf];
    }

    return cell;
}

#pragma mark - 选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectIndex = indexPath.row;
    DeviceShareModel *shareM = self.deviceArray[indexPath.row];
    if ([shareM.state isEqualToString:@"accept"]) {
        UIActionSheet *sheetView = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:NSLocalizedString(@"删除用户权限", nil) otherButtonTitles:nil, nil];
         sheetView.tag = 100;
        [sheetView showInView:self.view];
    }else{
        
        UIActionSheet *sheetView = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:NSLocalizedString(@"删除分享记录", nil) otherButtonTitles:nil, nil];
        sheetView.tag = 101;
        [sheetView showInView:self.view];
    }


}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    DeviceShareModel *shareM = self.deviceArray[selectIndex];
    if (actionSheet.tag == 101) {
        if (buttonIndex == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                AKAlertView *alert = [[AKAlertView alloc]initWithIconName:@"" withTitle:LocalizedString(@"提示") withMessage:LocalizedString(@"您是否确定删除分享记录")];
                [alert addButton:ButtonTypeCancel withTitle:@"取消" handler:^(AKAlertViewItem *item) {
                }];
                [alert addButton:ButtonTypeOK withTitle:@"确定" handler:^(AKAlertViewItem *item) {
                    [HttpRequest delShareRecordWithInviteCode:shareM.invite_code withAccessToken:DATASOURCE.userModel.accessToken didLoadData:^(id result, NSError *err) {
                        if (err) {
                            NSLog(@"err: %@",err);
                        }else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.deviceArray removeObject:shareM];
                                [self.tableView reloadData];
                            });
                            
                        }
                    }];
                }];
                [alert show];
            });
        }

    }else{
        if (buttonIndex == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                AKAlertView *alert = [[AKAlertView alloc]initWithIconName:@"" withTitle:LocalizedString(@"提示") withMessage:LocalizedString(@"您是否确定删除用户权限")];
                [alert addButton:ButtonTypeCancel withTitle:@"取消" handler:^(AKAlertViewItem *item) {
                }];
                [alert addButton:ButtonTypeOK withTitle:@"确定" handler:^(AKAlertViewItem *item) {
                    [HttpRequest cancelShareDeviceWithAccessToken:DATASOURCE.userModel.accessToken withInviteCode:shareM.invite_code didLoadData:^(id result, NSError *err) {
                        if (err) {
                            NSLog(@"err: %@",err);
                        }else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.deviceArray removeObject:shareM];
                                [self.tableView reloadData];
                            });
                            
                        }

                    }];
                }];
                [alert show];
            });
        }

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(NSMutableArray *)messageArray
{
    if (_deviceArray == nil) {
        _deviceArray = [[NSMutableArray alloc]init];
    }
    return _deviceArray;
}
//把tableView的线对齐
-(void)viewDidLayoutSubviews{
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
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
