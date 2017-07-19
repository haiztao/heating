//
//  AccountManageViewController.m
//  heating
//
//  Created by haitao on 2017/2/8.
//  Copyright © 2017年 haitao. All rights reserved.
//

#import "AccountManageViewController.h"
#import "LoginViewController.h"

#import "ForgotPswViewController.h"
#import "ChangPasswordViewController.h"
#import "RenameDeviceViewController.h"
#import "YSHYSlideViewController.h"

#import "UIButton+WebCache.h"
#import "UIImage+Extension.h"


@interface AccountManageViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RenameDelegate>
{
    UIImagePickerController *imagePicker;
    UIImage *image;
}
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIButton *userImageBtn;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@end

@implementation AccountManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userImageBtn.layer.cornerRadius = self.userImageBtn.width/2;
    self.userImageBtn.layer.masksToBounds = YES;
    self.userImageBtn.userInteractionEnabled = NO;
    
    [BaseViewController viewGetCornerRadius:self.logoutBtn];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    
    [self initUIWithTag:101 headerColorIsWhite:NO andTitle:LocalizedString(@"账号管理") rightBtnText:nil];
    [self dataSource];
}
#pragma mark - 数据赋值
-(void)dataSource{
    NSLog(@"avatarUrl %@",DATASOURCE.userModel.avatarUrl);
    self.nicknameLabel.text = DATASOURCE.userModel.nickName;
    self.accountLabel.text = DATASOURCE.userModel.account;
    NSURL * avatarURL = [NSURL URLWithString:DATASOURCE.userModel.avatarUrl];
    [self.userImageBtn sd_setImageWithURL:avatarURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"account_user_ic"]];

    
}
- (IBAction)changeUserAvatar:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        AKAlertView *alert = [[AKAlertView alloc]initWithIconName:@"" withTitle:LocalizedString(@"请选择") withMessage:LocalizedString(@"")];
        [alert addButton:ButtonTypeOK withTitle:LocalizedString(@"相册") handler:^(AKAlertViewItem *item) {
            [self pickImageFromAlbum];
        }];
        [alert addButton:ButtonTypeOK withTitle:LocalizedString(@"拍照") handler:^(AKAlertViewItem *item) {
            [self pickImageFromCamera];
        }];
        [alert show];
    });

}
#pragma mark - UIImagePickerController delegate
- (void)pickImageFromAlbum{
    imagePicker =[[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (void)pickImageFromCamera
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    @autoreleasepool {
        image= [info objectForKey:@"UIImagePickerControllerEditedImage"];
    }
    UIImage *imageCompression=[image scaleToSize:CGSizeMake(100.0, 100.0)];
    NSData *imageData = UIImageJPEGRepresentation(imageCompression, 1);
    
    [HttpRequest uploadAvatarWithAccessToken:DATASOURCE.userModel.accessToken andIconData:imageData didUpload:^(id result, NSError *err) {
        
        if (!err) {
            
            NSDictionary * resultDic = result;

            DATASOURCE.userModel.avatarUrl = resultDic[@"url"];
            [DATASOURCE saveUserWithIsUpload:NO];
            
            [self performSelectorOnMainThread:@selector(saveSuccess) withObject:nil waitUntilDone:NO];
            
        }else{
            
            [self performSelectorOnMainThread:@selector(saveFail) withObject:nil waitUntilDone:NO];
        }
    }];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveSuccess{

    
    [self dataSource];

    [self operateSucceedWithMessage:LocalizedString(@"上传头像成功！")];

}

-(void)saveFail{

    [self showErrorWithMessage:LocalizedString(@"上传头像失败，请重试") hideAfterDelay:1];
}
#pragma mark - 退出登录
- (IBAction)logoutTheAccount:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        AKAlertView *alert = [[AKAlertView alloc]initWithIconName:@"" withTitle:LocalizedString(@"提示") withMessage:LocalizedString(@"是否退出登录")];
        [alert addButton:ButtonTypeCancel withTitle:LocalizedString(@"取消") handler:^(AKAlertViewItem *item) {
        }];
        [alert addButton:ButtonTypeOK withTitle:LocalizedString(@"确定") handler:^(AKAlertViewItem *item) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kLogout object:nil];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isAutoLogin];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
            [self gotoLoginViewController];
        }];
        [alert show];
    });

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"accountCell"];
    if (indexPath.row == 0) {
        cell.textLabel.text = LocalizedString(@"修改昵称");
    }else{
        cell.textLabel.text = LocalizedString(@"修改密码");
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    if (indexPath.row == 0) {
        RenameDeviceViewController  *vc = [RenameDeviceViewController new];
        vc.isAccountTurn = YES;
        vc.titleString = NSLocalizedString(@"修改昵称", nil);
        vc.deviceName = DATASOURCE.userModel.nickName;
        vc.renameDelegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        ChangPasswordViewController  *vc = [storyboard instantiateViewControllerWithIdentifier:@"ChangPasswordViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }


}

-(void)renameSucceedWithNickName:(NSString *)nickName{
    self.nicknameLabel.text = nickName;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

//把tableView的线对齐
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


@end
