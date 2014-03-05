//
//  CreateGuideStep1ViewController.m
//  RACDemo
//
//  Created by wenlin on 14-1-24.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import "CreateGuideStep1ViewController.h"
#import <RESideMenu.h>

@interface CreateGuideStep1ViewController ()

@property (strong,nonatomic) NSString * type;


- (IBAction)showMenu:(id)sender;

@end

@implementation CreateGuideStep1ViewController

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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            self.type = @"clue";
            [self performSegueWithIdentifier:@"CreateStep2Segue" sender:self];
            break;
        case 1:
            self.type = @"lost";
            [self performSegueWithIdentifier:@"CreateStep2Segue" sender:self];
            break;
        case 2:
            self.type = @"adopt";
            [self performSegueWithIdentifier:@"CreateStep2Segue" sender:self];
            break;
            
        default:
            break;
    }
    
    
   
    
}

- (IBAction)showMenu:(id)sender {
    
    [self.sideMenuViewController presentMenuViewController];
    
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     id dvc = segue.destinationViewController;
     
     if ([segue.identifier isEqualToString:@"CreateStep2Segue"]) {
         [dvc setValue:self.type forKey:@"type"];
     }
 
}

- (IBAction)exitToCreateGuide:(UIStoryboardSegue*)segue{
    NSLog(@"Exit to CreateGuide");
}

@end
