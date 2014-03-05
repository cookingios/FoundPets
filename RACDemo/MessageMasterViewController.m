//
//  MessageMasterViewController.m
//  moon
//
//  Created by wenlin on 13-9-17.
//  Copyright (c) 2013年 wenlin. All rights reserved.
//

#import "MessageMasterViewController.h"
#import "MessageCell.h"
#import <RESideMenu.h>

@interface MessageMasterViewController (){
    //0:未读 1:已读 2:删除
    NSNumber * queryStatus;
    PFObject * selectedEvent;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *sengmentedControl;

- (IBAction)didSelectHistorySegmentedControl:(id)sender;
- (IBAction)showMenu:(id)sender;

@end

@implementation MessageMasterViewController

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom initialization
        self.parseClassName = @"Activity";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 15;
        self.loadingViewEnabled = NO;
        
        queryStatus = @0;
    }
    return self;
}

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
    //默认查询状态:未读



}

- (void)viewWillAppear:(BOOL)animated{

    [self loadObjects];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"toUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"fromUser" notEqualTo:[PFUser currentUser]];
    [query whereKeyExists:@"fromUser"];
    [query includeKey:@"fromUser"];
    [query whereKey:@"type" equalTo:@"comment"];
    //[query includeKey:@"Event"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"status" equalTo:queryStatus];
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
  
    return query;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    static NSString *cellIdentifier = @"MessageCell";
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    PFFile *thumbFile = [[object objectForKey:@"fromUser"]objectForKey:@"avatar"];
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:[thumbFile url]] placeholderImage:nil];
    NSString *fromUserName = [[object objectForKey:@"fromUser"]objectForKey:@"displayName"];
    cell.nameLabel.text = fromUserName;
    cell.createAtLabel.text = [MUtility stringFromDate:[object createdAt]];
    NSString *content = [object objectForKey:@"content"];
    cell.contentLabel.text = [NSString stringWithFormat:@"回复了你:%@",content];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if ( [self.objects count]>indexPath.row || (![self.objects count]==indexPath.row )) {
        
        PFObject *activity = self.objects[indexPath.row];
        if ([[activity objectForKey:@"status"] isEqualToNumber:@0]) {
            [activity setObject:@1 forKey:@"status"];
            [activity saveEventually];
        }

        selectedEvent = [self.objects[indexPath.row] objectForKey:@"Event"];
        
        [selectedEvent fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error) {
                 [self performSegueWithIdentifier:@"MessageEventDetailView" sender:self];
            }
        }];
        
       
        
    }
    
    
    
}


- (IBAction)didSelectHistorySegmentedControl:(id)sender{
    
    UISegmentedControl *messageSegment = sender;
    
    queryStatus = [NSNumber numberWithInteger:messageSegment.selectedSegmentIndex];
    
    [self loadObjects];
    
    
    
}

- (IBAction)showMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewController];
    
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    id dvc = [segue destinationViewController];
    
    if ([[segue identifier]isEqualToString:@"MessageEventDetailView"]){
        
        [dvc setValue:selectedEvent forKey:@"myEvent"];
        
    }
    
    
}



@end
