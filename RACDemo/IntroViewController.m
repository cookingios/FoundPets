//
//  IntroViewController.m
//  RACDemo
//
//  Created by wenlin on 14-2-16.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import "IntroViewController.h"
#import <RESideMenu.h>

static NSString * const sampleDesc1 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
static NSString * const sampleDesc2 = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
static NSString * const sampleDesc3 = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
static NSString * const sampleDesc4 = @"Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit.";

@interface IntroViewController (){
    
    UIView *rootView;
}

@property (weak, nonatomic) IBOutlet UIView *baseView;
- (IBAction)showMenu:(id)sender;

@end

@implementation IntroViewController

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
    rootView = self.baseView;
}
- (void)viewWillAppear:(BOOL)animated{
   // if ([NSStringFromClass([self class]) isEqualToString:@"IntroViewController"]) {
   //     self.navigationController.navigationBarHidden = YES;
   // }
    
    [self showIntroWithCrossDissolve];
}
- (void)viewWillDisappear:(BOOL)animated{
   // self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage1"];
    page1.bgImage = [UIImage imageNamed:@"intro1"];
    EAIntroPage *page2 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage2"];
    page2.bgImage = [UIImage imageNamed:@"intro2"];
    EAIntroPage *page3 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage3"];
    page3.bgImage = [UIImage imageNamed:@"intro3"];
    EAIntroPage *page4 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage4"];
    page4.bgImage = [UIImage imageNamed:@"intro4"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4]];
    [intro setDelegate:self];
    intro.swipeToExit = NO;
    intro.skipButton = nil;
    [intro showInView:rootView animateDuration:0.3];
}
- (IBAction)showMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewController];
}
@end
