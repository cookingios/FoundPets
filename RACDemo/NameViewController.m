//
//  NameViewController.m
//  moon
//
//  Created by wenlin on 13-9-16.
//  Copyright (c) 2013年 wenlin. All rights reserved.
//

#import "NameViewController.h"

@interface NameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation NameViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    _nameTextField.text = [[PFUser currentUser] objectForKey:@"displayName"];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [[PFUser currentUser] setObject:[MUtility trimString:_nameTextField.text] forKey:@"displayName"];
    [[PFUser currentUser] saveInBackground];
    
}


@end
