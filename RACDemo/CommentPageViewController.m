//
//  CommentPageViewController.m
//  RACDemo
//
//  Created by wenlin on 14-2-3.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import "CommentPageViewController.h"
#import "CommentViewController.h"

@interface CommentPageViewController ()

@property (nonatomic,weak) CommentViewController * commentViewController;

@end

@implementation CommentPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification 
                                               object:nil];
    
}

- (void)loadView{
    [super loadView];
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] applicationFrame].size.height - 20, 320, 40)];
    
	textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 240, 40)];
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	textView.minNumberOfLines = 1;
	textView.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
	textView.returnKeyType = UIReturnKeyGo; //just as an example
	textView.font = [UIFont systemFontOfSize:15.0f];
	textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholder = @"添加评论...";
    
    // textView.text = @"test\n\ntest";
	// textView.animateHeightChange = NO; //turns off animation
    
    [self.view addSubview:containerView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(5, 0, 248, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView addSubview:imageView];
    [containerView addSubview:textView];
    [containerView addSubview:entryImageView];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(containerView.frame.size.width - 61, 7, 50, 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBtn setTitle:@"发送" forState:UIControlStateNormal];
    
    //[doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    
    [doneBtn setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(commentOnEvent) forControlEvents:UIControlEventTouchUpInside];
    doneBtn.layer.cornerRadius = 3.0f;
    doneBtn.layer.masksToBounds = YES;
    doneBtn.backgroundColor = [UIColor colorWithRed:52/255.0 green:186/255.0 blue:95/255.0 alpha:1.0];
    UIImage *image = [MUtility imageWithColor:[UIColor colorWithRed:52/255.0 green:186/255.0 blue:95/255.0 alpha:1.0] andSize:doneBtn.frame.size];
    [doneBtn setBackgroundImage:image forState:UIControlStateNormal];
	[containerView addSubview:doneBtn];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [TSMessage setDefaultViewController:self.navigationController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)commentOnEvent{
    
    if (![textView hasText]) {
        return;
    }
    //
    NSString *content = [MUtility trimString:textView.text];
    textView.text = @"";
    [textView resignFirstResponder];
    //TSMessage:评论已提交
    //[TSMessage showNotificationWithTitle:@"您的评论已提交"
    //                                type:TSMessageNotificationTypeMessage];
    PFObject *comment = [PFObject objectWithClassName:@"Activity"];
    PFUser *toUser = [self.event objectForKey:@"organizer"];
    [comment setObject:content forKey:@"content"];
    [comment setObject:[PFUser currentUser] forKey:@"fromUser"];
    [comment setObject:self.event forKey:@"Event"];
    [comment setObject:toUser  forKey:@"toUser"];
    [comment setObject:@"comment"  forKey:@"type"];
    //0代表该消息未读
    [comment setObject:@0 forKey:@"status"];
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //Succed,Reload comment,animation input
            //[TSMessage showNotificationWithTitle:@"您的评论已成功发布"
            //                                type:TSMessageNotificationTypeSuccess];
            [self.commentViewController loadObjects];
            if (![[toUser objectId]isEqualToString:[[PFUser currentUser] objectId]]) {
                PFQuery *pushQuery = [PFInstallation query];
                [pushQuery whereKey:@"owner" equalTo:toUser]; // Set notification toUser
                //Create Options
                NSDictionary *data = @{
                                       @"alert": [NSString stringWithFormat:@"%@ 评论了你",[[PFUser currentUser] objectForKey:@"displayName"]],
                                       @"eventId": [self.event objectId],
                                       @"badge":@"Increment",
                                       @"sound":@"Voidcemail.caf"
                                       };
                // Send push notification to query
                PFPush *push = [[PFPush alloc] init];
                [push setQuery:pushQuery];
                [push setData:data];
                [push sendPushInBackground];
            }
            
        }else{
            //failed
            [TSMessage showNotificationWithTitle:@"因网络连接问题,您的评论尚未发布"
                                            type:TSMessageNotificationTypeError];
            
        }
    }];
    //[self performSegueWithIdentifier:@"ExitToHome" sender:self];
    
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	containerView.frame = containerFrame;
    
	
	// commit animations
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id dvc = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"PFQueryTableVCSegue"]) {
        
        [dvc setValue:self.event forKey:@"event"];
        self.commentViewController = segue.destinationViewController;

    }
    
    
}
@end
