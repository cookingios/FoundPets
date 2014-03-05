//
//  CommentViewController.m
//  RACDemo
//
//  Created by wenlin on 14-2-2.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentCell.h"
#import "LoadMoreCell.h"


#define kStatusBarHeight 20
#define kDefaultToolbarHeight 40
#define kKeyboardHeightPortrait 216
#define kKeyboardHeightLandscape 140

@interface CommentViewController ()

@property (strong,nonatomic) NSMutableArray *dataSource;

@end

@implementation CommentViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        self.dataSource = [NSMutableArray arrayWithCapacity:3];
        self.parseClassName = @"Activity";
        self.pullToRefreshEnabled = NO;
        self.paginationEnabled = YES;
        self.objectsPerPage = 15;
        self.loadingViewEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (PFQuery *)queryForTable{
    NSLog(@"Fetching Comments...");
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"Event" equalTo:self.event];
    [query whereKey:@"type" equalTo:@"comment"];
    [query includeKey:@"fromUser"];
    [query includeKey:@"toUser"];
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    query.maxCacheAge = 24*60*60 ;
    [query orderByDescending:@"createdAt"];
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object{
    static NSString *CellIdentifier = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (object) {
        [cell setActivity:object];
    }
    /*
    if ([[[object objectForKey:@"toUser"]objectId]isEqualToString:[[self.event objectForKey:@"organizer"] objectId]]) {
        cell.toUserLabel.hidden = YES;
    }
    */
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PFObject *object = [self objectAtIndexPath:indexPath];
    
    if (object == nil) {
        // Return a fixed height for the extra ("Load more") row
        return 44;
    } else {
        // Get the string of text from each comment
        NSString *content =  [object objectForKey:@"content"];
        NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
        pStyle.lineSpacing = 3;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13.0f],NSParagraphStyleAttributeName:pStyle};
        CGRect rect = [content boundingRectWithSize:CGSizeMake(230, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
        if (rect.size.height<19) {
            return 33 + 19;
        }else{
            return 33 + rect.size.height;
        }
    }
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.objects.count) {
        return nil;
    } else {
        return [super objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    }
}
- (PFTableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"LoadMoreCell";
    
    LoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[LoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
