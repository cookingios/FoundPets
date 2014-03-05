//
//  LoginViewController.m
//  RACDemo
//
//  Created by wenlin on 14-1-22.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import "LoginViewController.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet BZGFormField *emailTextField;
@property (weak, nonatomic) IBOutlet BZGFormField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *backgroundScrollView;

- (IBAction)validateLoginInfo:(id)sender;
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self configLoginTextField];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [TSMessage setDefaultViewController:self.navigationController];
    self.backgroundScrollView.contentSize = CGSizeMake(320, 520);
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [TSMessage dismissActiveNotification];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self.emailTextField.textField becomeFirstResponder];
}
#pragma mark - config textfield
- (void)configLoginTextField{
    
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
	// Do any additional setup after loading the view.
    self.emailTextField.textField.placeholder = @"邮箱账号";
    self.emailTextField.textField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTextField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    __weak LoginViewController *weakSelf = self;
    [self.emailTextField setTextValidationBlock:^BOOL(NSString *text) {
        NSString *trimText = [MUtility trimString:text];
        // from https://github.com/benmcredmond/DHValidation/blob/master/DHValidation.m
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailTest evaluateWithObject:trimText]) {
            weakSelf.emailTextField.alertView.title = @"邮箱地址格式不正常";
            return NO;
        } else {
            return YES;
        }
    }];
    
    //emailTextField Add online validation
    [self.emailTextField setAsyncTextValidationBlock:^BOOL(NSString *text) {
        NSString *trimText = [MUtility trimString:text];
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:trimText];
        query.cachePolicy = kPFCachePolicyNetworkOnly;
        NSInteger k = [query countObjects];
        //NSLog(@"%d",k);
        if (k<1) {
            weakSelf.emailTextField.alertView.title = @"找不到该账号,请尝试注册";
            return NO;
        }
        return YES;
    }];
    
    self.passwordTextField.textField.placeholder = @"密码";
    self.passwordTextField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.textField.secureTextEntry = YES;
    [self.passwordTextField setTextValidationBlock:^BOOL(NSString *text) {
        NSString *trimText = [MUtility trimString:text];
        if (trimText.length < 6) {
            weakSelf.passwordTextField.alertView.title = @"密码有点短";
            return NO;
        } else {
            return YES;
        }
    }];
    
}

#pragma mark - textfielddelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@" "]){
    	return NO;
    }
    else {
    	return YES;
    }
}

#pragma mark - validate login info
- (IBAction)validateLoginInfo:(id)sender {
    
    [self.view endEditing:YES];
    NSString *error = @"";
    
    if (self.emailTextField.currentFormFieldState != BZGFormFieldStateValid) {
        error = @"请检查登录邮箱账号";
        [self.emailTextField.textField becomeFirstResponder];
        return [self showErrorMessage:error];
    }
    if (self.passwordTextField.currentFormFieldState != BZGFormFieldStateValid) {
        error = @"请检查密码";
        [self.passwordTextField.textField becomeFirstResponder];
        return [self showErrorMessage:error];
    }
    
    [MRProgressOverlayView showOverlayAddedTo:[[self view] window] title:@"主人你回来啦 ..." mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(handleHudTimeout) userInfo:nil repeats:NO];
    
    [PFUser logInWithUsernameInBackground:self.emailTextField.textField.text password:self.passwordTextField.textField.text block:^(PFUser *user, NSError *error) {
        [timer invalidate];
        if (!error) {
            //Setup the installation.
            PFInstallation *installation = [PFInstallation currentInstallation];
            [installation setObject:user forKey:@"owner"];
            [installation saveInBackground];
            [MRProgressOverlayView dismissAllOverlaysForView:[[self view] window] animated:YES completion:^{
                //[self performSegueWithIdentifier:@"ExitToHomeSegue" sender:self];
                //[[self.navigationController topViewController] dismissViewControllerAnimated:YES completion:nil];
                [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"] animated:NO completion:nil];
            }];
        } else {
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
@end
