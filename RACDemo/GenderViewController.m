//
//  GenderViewController.m
//  moon
//
//  Created by wenlin on 13-9-16.
//  Copyright (c) 2013年 wenlin. All rights reserved.
//

#import "GenderViewController.h"

@interface GenderViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *femaleCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *maleCell;

@end

@implementation GenderViewController

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

- (void)viewWillAppear:(BOOL)animated{
    
    if ([[[PFUser currentUser] objectForKey:@"gender"]isEqualToString:@"male"]) {
        [_maleCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else if([[[PFUser currentUser] objectForKey:@"gender"]isEqualToString:@"female"]){
        [_femaleCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row ==0 ) {
        
        [[PFUser currentUser] setObject:@"female" forKey:@"gender"];
        [_femaleCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [_maleCell setAccessoryType:UITableViewCellAccessoryNone];
        
    }else{
        
        [[PFUser currentUser] setObject:@"male" forKey:@"gender"];
        [_maleCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [_femaleCell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    [[PFUser currentUser] saveInBackground];
    
}




@end
