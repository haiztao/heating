//
//  MessageViewController.m
//  heating
//
//  Created by haitao on 2017/2/9.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"

#import <MJRefresh/MJRefresh.h>
#import "MessageModel.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *hud;
    NSInteger count;
}
@property (weak, nonatomic) IBOutlet UIView *noneMessageView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *messageArray;


@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    count = 0;
    [self initUIWithTag:102 headerColorIsWhite:NO andTitle:LocalizedString(@"消息中心") rightBtnText:nil];
    [self.rightbutton setImage:[UIImage imageNamed:@"notice_delete_ic"] forState:UIControlStateNormal];
    self.rightbutton.hidden = YES;
    //创建tableView
    [self createTableView];
    [self judgeTheArrayCountAndChangeUI];

    
    
}

//右边按钮 删除消息
-(void)rightButtonToTurnBack{
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SS'Z'"];
    NSString *strDate = [dataFormatter stringFromDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults] setObject:strDate forKey:@"DeleteMsgDate"];
//    NSLog(@"strDate %@",strDate);

    
    [self.messageArray removeAllObjects];
    [self judgeTheArrayCountAndChangeUI];
    
}

#pragma mark - 左边按钮返回上一页面
-(void)leftButtonToTurnBack{
    [self setMessageIsRead];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setMessageIsRead{
    if (self.messageArray.count > 0) {
        NSMutableArray *array = [NSMutableArray new];
        for (MessageModel *model in self.messageArray) {
            if (![model.is_read boolValue]) {
                [array addObject:model.msdID];
            }
        }
        if (array.count > 0) {
            [HttpRequest readMessageListWithUserid:DATASOURCE.userModel.userId withMessageIdList:array withAccessToken:DATASOURCE.userModel.accessToken didLoadData:^(id result, NSError *err) {
                if (err) {
                    NSLog(@"err %@",err);
                }else{
                    NSLog(@"设置成功");
                }
            }];
        }
    }
}

#pragma mark - 判断账号下的数据
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获取数据
    [self dataSurce];
 
}
#pragma mark - 获取消息
-(void)getMessage{
    NSMutableArray *marr = [NSMutableArray array];
    NSArray *array = DATASOURCE.userModel.deviceModel;
    if (array.count > 0) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        for (DeviceModel *model in array) {
            [marr addObject:model.deviceID];
        }
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        NSString *lastestDateString = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeleteMsgDate"];
        
        mDict[@"offset"]  = @(count*10).stringValue;
        mDict[@"limit"] = @"10";
        if (lastestDateString) {
            mDict[@"query"] = @{@"create_date":@{@"$gt":lastestDateString},@"from":@{@"$in":marr}};
        }else{
            mDict[@"query"] = @{@"from":@{@"$in":marr}};
        }
        
        [HttpRequest getMessageWithUserid:DATASOURCE.userModel.userId withAccessToken:DATASOURCE.userModel.accessToken WithwithQueryDict:mDict didLoadData:^(id result, NSError *err) {
            [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
            if (!err) {
                NSArray *array = [result objectForKey:@"list"];
                for (NSDictionary *dict in array) {
                    MessageModel *msgModel = [[MessageModel alloc]initWithDictonary:dict];
                    [self.messageArray addObject:msgModel];
                }
                [self judgeTheArrayCountAndChangeUI];
            }else{
                NSLog(@"获取消息 err %@",err);
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
        }];

    }
    

}


-(void)judgeTheArrayCountAndChangeUI{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_messageArray.count > 0) {
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            self.noneMessageView.hidden = YES;
            self.tableView.hidden = NO;
            self.rightbutton.hidden = NO;
            [self.tableView reloadData];
        }else{
            self.noneMessageView.hidden = NO;
            self.tableView.hidden = YES;
            self.rightbutton.hidden = YES;
        }
    });
}
-(void)dataSurce{
    [self getMessage];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        count = 0;
        [self.messageArray removeAllObjects];
        [self getMessage];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        count++;
        [self getMessage];

    }];
}


-(void)getAlarmMessage{
    NSArray *array = DATASOURCE.userModel.deviceModel;
    if (array.count > 0) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    for (DeviceModel *deviceM in array) {

        NSDictionary *queryDic = @{@"offset" : @(0),@"limit" : @(1)};
        [HttpRequest getDeviceAlertLogsWithProductID:HeatingPID withDeviceID:deviceM.deviceID withQueryDict:queryDic withAccessToken:DATASOURCE.userModel.accessToken didLoadData:^(id result, NSError *err) {
            //移除HUD
            [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
            if (!err) {
                NSLog(@"告警消息： %@",result);
                NSInteger sumCount = [[result objectForKey:@"count"] integerValue];
                NSInteger offset = sumCount - 10*count;
                NSInteger limit = 10;
                if (offset < 0) {
                    limit = sumCount - 10*(count-1);
                    offset = 0;
                }
                NSDictionary *queryDic = @{@"offset" : @(offset),@"limit" : @(limit)};
                [HttpRequest getDeviceAlertLogsWithProductID:HeatingPID withDeviceID:deviceM.deviceID withQueryDict:queryDic withAccessToken:DATASOURCE.userModel.accessToken didLoadData:^(id result, NSError *err) {
                    //移除HUD
                    [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
                    if (!err) {
                        NSArray *array = [result objectForKey:@"list"];
                        NSMutableArray *muArray = [[NSMutableArray alloc]init];
                        for (NSDictionary *dict in array) {
                            MessageModel *msgModel = [[MessageModel alloc]initWithDictonary:dict];
                            msgModel.deviceName = deviceM.name;
                            [muArray addObject:msgModel];
                        }
                        for (NSInteger i = muArray.count - 1; i >= 0; i--) {
                            MessageModel *msgModel = muArray[i];
                            [self.messageArray addObject:msgModel];
                        }
                        [self judgeTheArrayCountAndChangeUI];
                    }else{
                        NSLog(@"获取消息 err %@",err);
                        [self.tableView.mj_header endRefreshing];
                        [self.tableView.mj_footer endRefreshing];
                    }
                }];
            }else{
                NSLog(@"获取数量 err %@",err);
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
        }];
    }
}



#pragma mark - tableView dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"MessageTableViewCell";
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (self.messageArray.count > 0) {
        MessageModel *messageM = self.messageArray[indexPath.row];
        cell.msgModel = messageM;
    }

  
    return cell;
}
#pragma mark - 选中未读消息
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
    if (_messageArray == nil) {
        _messageArray = [[NSMutableArray alloc]init];
    }
    return _messageArray;
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


-(void)createTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, MainWidth, MainHeight - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageTableViewCell"];
    
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
