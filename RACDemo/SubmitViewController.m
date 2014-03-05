//
//  SubmitViewController.m
//  RACDemo
//
//  Created by wenlin on 14-1-25.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import "SubmitViewController.h"
#import <UIImageView+WebCache.h>
#import <RPFloatingPlaceholderTextView.h>
#import "NSObject+DelayBlock.h"
#import <ShareSDK/ShareSDK.h>


@interface SubmitViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak,nonatomic) IBOutlet  RPFloatingPlaceholderTextView* contentTextView;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UISwitch *sinaWBSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *qzoneSwitch;


@property (strong,nonatomic) id<ISSPlatformCredential> sinaCredential;
@property (strong,nonatomic) id<ISSPlatformCredential> qzoneCredential;
@property (strong,nonatomic) id<ISSPlatformCredential> tencentWeiboCredential;
@property (strong,nonatomic) PFGeoPoint *currentGeoPoint;
- (IBAction)syncSinaWB:(id)sender;
- (IBAction)syncQzone:(id)sender;
- (IBAction)validateLoginInfo:(id)sender;

@end

@implementation SubmitViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentTextView.delegate = self;
    PFFile *image = [PFFile fileWithData:self.imgData];
    self.images = [[NSArray arrayWithObjects:image, nil] mutableCopy];
    self.sinaCredential = [ShareSDK getCredentialWithType:ShareTypeSinaWeibo];
    self.qzoneCredential = [ShareSDK getCredentialWithType:ShareTypeQQSpace];
    self.tencentWeiboCredential = [ShareSDK getCredentialWithType:ShareTypeTencentWeibo];
    //地理位置IBOutlet
    [[RACObserve([MOManager sharedManager], locationName) ignore:nil] subscribeNext:^(NSString* locationName) {
        self.locationLabel.text = locationName;
        NSLog(@"submit RAC answer is %@",locationName);
    }];
    
    //地理位置
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            [MOManager sharedManager].selectedGeoPoint = geoPoint;
        }else{
            self.locationLabel.text = @"暂无结果";
            [self performBlock:^{
                [TSMessage showNotificationWithTitle:@"请检查设备定位功能是否开启" type:TSMessageNotificationTypeError];
            } afterDelay:2];
        }
    }];
    //log sina auth options
    NSLog(@"accessToken = %@", [self.sinaCredential token]);
    NSLog(@"expiresIn = %@", [self.sinaCredential expired]);
    NSLog(@"available = %@", [NSNumber numberWithBool:[self.sinaCredential available]]);
    
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"will appear Sina available = %@", [NSNumber numberWithBool:[self.sinaCredential available]]);
    NSLog(@"will appear Qzone available = %@", [NSNumber numberWithBool:[self.qzoneCredential available]]);
    
    [TSMessage setDefaultViewController:self.navigationController];
    self.contentTextView.animationDirection = RPFloatingPlaceholderAnimateDownward;
    self.contentTextView.floatingLabelActiveTextColor = [UIColor lightGrayColor];
    self.eventImageView.layer.cornerRadius = 3.0f;
    self.eventImageView.layer.masksToBounds = YES ;
    [self.eventImageView setImage:[UIImage imageWithData:self.imgData]];

}
-(void)viewWillDisappear:(BOOL)animated{
    
    [TSMessage dismissActiveNotification];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }else if (textView.text.length>=120 && range.length == 0){
        [TSMessage showNotificationWithTitle:@"字符个数不能大于120" type:TSMessageNotificationTypeError];
        return NO;
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        [self performSegueWithIdentifier:@"ChangeLocationSegue" sender:self];
    }
    
}

- (IBAction)syncSinaWB:(id)sender {
    UISwitch *sina = sender;
    
    if (sina.on && (![self.sinaCredential available])) {
        [self performBlock:^{
            [ShareSDK authWithType:ShareTypeSinaWeibo    //需要授权的平台类型
                     options:nil            //授权选项，包括视图定制，自动授权
                      result:^(SSAuthState state, id<ICMErrorInfo> error) {  //授权返回后的回调方法
                                if (state == SSAuthStateSuccess)
                                {
                                    NSLog(@"成功");
                                    self.sinaCredential = [ShareSDK getCredentialWithType:ShareTypeSinaWeibo];
                                    NSLog(@"accessToken = %@", [self.sinaCredential token]);
                                    NSLog(@"expiresIn = %@", [self.sinaCredential expired]);
                                    NSLog(@"available = %@", [NSNumber numberWithBool:[self.sinaCredential available]]);
                                }
                                else if (state == SSAuthStateFail)
                                {
                                    NSLog(@"失败");
                                    [self.sinaWBSwitch setOn:NO animated:YES];
                                    
                                }else if (state ==SSAuthStateCancel){
                                    NSLog(@"取消");
                                    [self performBlock:^{
                                        [self.sinaWBSwitch setOn:NO animated:YES];
                                    } afterDelay:1];
                                }
                            }];
        } afterDelay:0.5];
    }
    
}

- (IBAction)syncQzone:(id)sender {
    
    UISwitch *qzone = sender;
    
    if (qzone.on && (![self.qzoneCredential available])) {
        [self performBlock:^{
            [ShareSDK authWithType:ShareTypeQQSpace    //需要授权的平台类型
                           options:nil            //授权选项，包括视图定制，自动授权
                            result:^(SSAuthState state, id<ICMErrorInfo> error) {  //授权返回后的回调方法
                                if (state == SSAuthStateSuccess)
                                {
                                    NSLog(@"成功");
                                    self.qzoneCredential = [ShareSDK getCredentialWithType:ShareTypeQQSpace];
                                    NSLog(@"accessToken = %@", [self.qzoneCredential token]);
                                    NSLog(@"expiresIn = %@", [self.qzoneCredential expired]);
                                    NSLog(@"available = %@", [NSNumber numberWithBool:[self.qzoneCredential available]]);
                                }
                                else if (state == SSAuthStateFail)
                                {
                                    NSLog(@"失败");
                                    [self.qzoneSwitch setOn:NO animated:YES];

                                }else if (state == SSAuthStateCancel){
                                    NSLog(@"取消");
                                    [self performBlock:^{
                                        [self.qzoneSwitch setOn:NO animated:YES];
                                    } afterDelay:1];
                                    
                                }
                            }];
        } afterDelay:0.3];
    }
}
- (IBAction)syncTencentWB:(id)sender {
    
    UISwitch *tencentWB = sender;
    
    if (tencentWB.on && (![self.tencentWeiboCredential available])) {
        [self performBlock:^{
            [ShareSDK authWithType:ShareTypeTencentWeibo    //需要授权的平台类型
                           options:nil            //授权选项，包括视图定制，自动授权
                            result:^(SSAuthState state, id<ICMErrorInfo> error) {  //授权返回后的回调方法
                                if (state == SSAuthStateSuccess)
                                {
                                    NSLog(@"成功");
                                    self.tencentWeiboCredential = [ShareSDK getCredentialWithType:ShareTypeTencentWeibo];
                                    NSLog(@"accessToken = %@", [self.tencentWeiboCredential token]);
                                    NSLog(@"expiresIn = %@", [self.tencentWeiboCredential expired]);
                                    NSLog(@"available = %@", [NSNumber numberWithBool:[self.tencentWeiboCredential available]]);
                                }
                                else if (state == SSAuthStateFail)
                                {
                                    NSLog(@"失败");
                                    [self.qzoneSwitch setOn:NO animated:YES];
                                    
                                }else if (state == SSAuthStateCancel){
                                    NSLog(@"取消");
                                    [self performBlock:^{
                                        [self.qzoneSwitch setOn:NO animated:YES];
                                    } afterDelay:1];
                                    
                                }
                            }];
        } afterDelay:0.3];
    }
}
#pragma mark - validate login info
- (IBAction)validateLoginInfo:(id)sender {
    
    [self.view endEditing:YES];
    NSString *error = @"";
    PFFile *image = [PFFile fileWithData:self.imgData];
    //NSLog(@"%@",[self.images description]);
    NSArray *images = [NSArray arrayWithObjects:image, nil];
    
    if ([[MUtility trimString:self.contentTextView.text] length]==0) {
        error = @"发布内容不能为空";
        [self.contentTextView becomeFirstResponder];
        return [self showErrorMessage:error];
    }
    if (!self.eventImageView.image) {
        error = @"发布照片不能为空";
        return [self showErrorMessage:error];
    }
    if ([self.locationLabel.text isEqualToString:@"暂无结果"]) {
        error = @"地理位置数据无法获取,请检查网络连接及定位设置功能";
        return [self showErrorMessage:error];
    }
    //构造分享内容
    NSString *contentString = [NSString stringWithFormat:@"%@\n(转发自@宠物回家)",[MUtility trimString:self.contentTextView.text]];
    NSString *titleString   = [NSString stringWithFormat:@"孩子回家:%@",self.locationLabel.text];
    NSString *urlString     = @"http://www.sharesdk.cn";
    NSString *description   = @"";
    
    id<ISSContent> publishContent = [ShareSDK content:contentString
                                       defaultContent:@"宠物回家分享内容"
                                                image:[ShareSDK imageWithData:_imgData fileName:@"pet" mimeType:@"jpg"]
                                                title:titleString
                                                  url:urlString
                                          description:description
                                            mediaType:SSPublishContentMediaTypeImage];
    
    //校验通过,上传至Parse
    [MRProgressOverlayView showOverlayAddedTo:[[self view] window] title:@"全力上传中 ..." mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(handleHudTimeout) userInfo:nil repeats:NO];
    PFObject *event = [PFObject objectWithClassName:@"Event"];
    [event setObject:self.type forKey:@"type"];
    [event setObject:[MOManager sharedManager].selectedGeoPoint forKey:@"createdLocale"];
    [event setObject:[MUtility trimString:self.contentTextView.text] forKey:@"title"];
    [event setObject:[PFUser currentUser] forKey:@"organizer"];
    [event setObject:images forKey:@"images"];
    [event setObject:self.locationLabel.text forKey:@"createdLocaleName"];
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [timer invalidate];
        if (succeeded) {
            [MRProgressOverlayView dismissAllOverlaysForView:[[self view] window] animated:YES completion:^{
                NSLog(@"success");
                if ([_sinaWBSwitch isOn]) {
                    [MUtility publishToSina:publishContent];
                }
                if ([_qzoneSwitch isOn]) {
                    [MUtility publishToTencentWB:publishContent];
                }
                [self performSegueWithIdentifier:@"ExitToCreateGuide" sender:self];
            }];
            
        }else{
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            [MRProgressOverlayView dismissAllOverlaysForView:[[self view] window] animated:YES completion:^{
                [self showErrorMessage:errorString];
            }];
        }
    }];
}


- (void)handleHudTimeout{
    [MRProgressOverlayView dismissAllOverlaysForView:[[self view] window] animated:YES completion:^{
        [TSMessage showNotificationWithTitle:@"网络连接超时,请重试" type:TSMessageNotificationTypeError];
    }];
}

- (void)showErrorMessage:(NSString*)message{
    [TSMessage showNotificationWithTitle:message type:TSMessageNotificationTypeError];
}


#pragma mark - Navigation
// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id dvc = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"ChangeLocationSegue"]) {
        
        [dvc setValue:self.currentGeoPoint forKey:@"currentGeoPoint"];
    }
}
@end
