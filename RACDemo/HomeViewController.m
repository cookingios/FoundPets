//
//  HomeViewController.m
//  RACDemo
//
//  Created by wenlin on 14-1-16.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import "HomeViewController.h"
#import <UIImageView+WebCache.h>
#import <RESideMenu.h>
#import <REMenu.h>
#import "LoadMoreCell.h"
#import "NSObject+DelayBlock.h"
#import <ShareSDK/ShareSDK.h>


@interface HomeViewController ()

@property (strong,nonatomic) NSMutableArray *dataSource;
@property (strong,nonatomic) NSMutableArray *heightDataSource;
@property (strong,nonatomic) PFObject *currentEvent;
@property (nonatomic) REMenu *menu;
@property (strong,nonatomic) NSNumber *type; //1 时间 0 地理
@property (strong,nonatomic) id<ISSPlatformCredential> sinaWBCredential;
@property (strong,nonatomic) id<ISSPlatformCredential> tencentWBCredential;

- (IBAction)showSearch:(id)sender;
- (IBAction)showMenu:(id)sender;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataSource = [NSMutableArray arrayWithCapacity:3];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom initialization
        self.dataSource = [NSMutableArray arrayWithCapacity:3];
        self.parseClassName = @"Event";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 10;
        self.loadingViewEnabled = NO;
        self.type =@1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[MOManager sharedManager] updateCurrentGeoPoint];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLikeOrUnlikeEvent:) name:@"userLikedUnlikedEventCallbackFinished" object:nil];
    
    self.sinaWBCredential = [ShareSDK getCredentialWithType:ShareTypeSinaWeibo];
    self.tencentWBCredential = [ShareSDK getCredentialWithType:ShareTypeTencentWeibo];
    if ([self.eventType isEqualToString:@"clue"]) {
        self.title = @"流浪线索";
    }else if ([self.eventType isEqualToString:@"lost"]){
        self.title = @"丢失求助";
    }else if ([self.eventType isEqualToString:@"adopt"]){
        self.title = @"领养";
    }
}

-(void)viewWillAppear:(BOOL)animated{
    if (![PFUser currentUser]) {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
        return;
    }
    if (self.myEvent) {
        UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backToMyProfile)];
        self.navigationItem.leftBarButtonItem = backButtonItem;
        self.navigationItem.rightBarButtonItem = nil;
        self.title = @"";
    }
    
    [TSMessage setDefaultViewController:self.navigationController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)backToMyProfile{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)showSearch:(id)sender {
    
    if (self.menu.isOpen)
        return [self.menu close];
    
    REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"按时间顺序"
                                                    subtitle:nil
                                                       image:[UIImage imageNamed:@"Icon_Home"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          NSLog(@"Item: %@", _type);
                                                          if([_type isEqualToNumber:@0]){
                                                              _type = @1;
                                                              [self loadObjects];
                                                          }
                                                      }];
    
    REMenuItem *exploreItem = [[REMenuItem alloc] initWithTitle:@"按地理位置"
                                                       subtitle:nil
                                                          image:[UIImage imageNamed:@"Icon_Explore"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", _type);
                                                             if([_type isEqualToNumber:@1]){
                                                                 _type = @0;
                                                                 [self loadObjects];
                                                             }
                                                         }];
    
    self.menu = [[REMenu alloc] initWithItems:@[homeItem, exploreItem]];
    self.menu.liveBlur = YES;
    self.menu.font = [UIFont systemFontOfSize:19];
    self.menu.highlightedTextColor = [UIColor whiteColor];
    self.menu.shadowColor = [UIColor clearColor];
    self.menu.textShadowColor = [UIColor clearColor];
    self.menu.separatorColor = [UIColor clearColor];
    self.menu.highlightedTextShadowColor = [UIColor clearColor];
    self.menu.highlightedSeparatorColor = [UIColor clearColor];
    self.menu.borderColor = [UIColor clearColor];
    [self.menu showFromNavigationController:self.navigationController];
}

- (IBAction)showMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewController];
}


- (PFQuery *)queryForTable{
    NSLog(@"type is%@",_type);
    if (self.myEvent) {
        PFQuery *query = [PFQuery queryWithClassName:@"Event"];
        [query whereKey:@"objectId" equalTo:self.myEvent.objectId];
        [query includeKey:@"organizer"];
        if (self.pullToRefreshEnabled) {
            query.cachePolicy = kPFCachePolicyNetworkOnly;
        }
        if (self.objects.count == 0) {
            query.cachePolicy = kPFCachePolicyCacheThenNetwork;
            query.maxCacheAge = 24*60*60 ;
        }

        return query;
    }else{
        NSLog(@"Fetching Events...");
        PFQuery *query = [PFQuery queryWithClassName:@"Event"];
        if ([self.eventType isEqualToString:@"lost"]) {
            [query whereKey:@"type" equalTo:@"lost"];
        }else if([self.eventType isEqualToString:@"clue"]){
            [query whereKey:@"type" equalTo:@"clue"];
        }else if([self.eventType isEqualToString:@"adopt"]){
            [query whereKey:@"type" equalTo:@"adopt"];
        }else [query whereKey:@"type" equalTo:@"clue"];
        
        [query includeKey:@"organizer"];
        if (self.pullToRefreshEnabled) {
            query.cachePolicy = kPFCachePolicyNetworkOnly;
        }
        if (self.objects.count == 0) {
            query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        }
        if ([self.type isEqualToNumber:@1]) {
            NSLog(@"Fetching time Events...");
            [query orderByDescending:@"createdAt"];
        }else {
            NSLog(@"Fetching location Events...");
            if ([MOManager sharedManager].currentGeoPoint) {
                NSLog(@"inside");
                [query whereKey:@"createdLocale" nearGeoPoint:[MOManager sharedManager].currentGeoPoint];
            }
        }
        return query;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object{
    
    static NSString *cellIdentifier = @"HomeCell";
    
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.delegate = self;
    if (!cell) {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:cellIdentifier];
    }
    // Configure the cell to show todo item with a priority at the bottom
    
    if (object) {
        [cell setEvent:object];
    }
    if ([_type isEqualToNumber:@1]) {
        cell.distanceDescriptionLabel.hidden = YES;
        cell.timeDescriptionLabel.hidden = NO;
    }else{
        cell.distanceDescriptionLabel.hidden = NO;
        cell.timeDescriptionLabel.hidden = YES;
    }
    cell.tag = indexPath.row;
    [cell.likeButton setTag:indexPath.row];
    NSDictionary *attributesForPhoto = [[MOManager sharedManager] attributesForObject:object];
    
    if (attributesForPhoto) {
        [cell setLikeStatus:[[MOManager sharedManager] isObjectLikedByCurrentUser:object]];
    } else {
        NSLog(@"updating cache");
        @synchronized(self) {
        PFQuery *query = [MUtility queryForActivitiesOnEvent:object cachePolicy:kPFCachePolicyNetworkOnly];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                @synchronized(self){
                    if (error) {
                        return;
                    }
                    BOOL isLikedByCurrentUser = NO;
                    for (PFObject *activity in objects) {
                     
                        if ([[[activity objectForKey:@"fromUser"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                            if ([[activity objectForKey:@"type"] isEqualToString:@"like"]) {
                                isLikedByCurrentUser = YES;
                            }
                        }
                    }
                    [[MOManager sharedManager] setObjectIsLikedByCurrentUser:object liked:isLikedByCurrentUser];
                    if (cell.tag != indexPath.row) {
                        return;
                    }
                    [cell setLikeStatus:[[MOManager sharedManager] isObjectLikedByCurrentUser:object]];
                }
            }];
        }
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PFObject *object = [self objectAtIndexPath:indexPath];
    
    if (object == nil) {
        // Return a fixed height for the extra ("Load more") row
        return 45;
    } else {
        // Get the string of text from each comment
        NSString *title =  [object objectForKey:@"title"];
        NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
        pStyle.lineSpacing = 3;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13.0f],NSParagraphStyleAttributeName:pStyle};
        CGRect rect = [title boundingRectWithSize:CGSizeMake(295, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
        if (rect.size.height<46) {
            return 396 + 46;
        }else{
            return 396 + rect.size.height;
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

-(void)homeCell:(HomeCell *)homeCell didTapLikeButton:(UIButton *)button event:(PFObject *)event{
    BOOL liked = !button.selected;
    [homeCell setLikeStatus:liked];
    
    //update cache
     [[MOManager sharedManager] setObjectIsLikedByCurrentUser:event liked:liked];
    
    if (liked) {
        [MUtility likeEventInBackground:event block:^(BOOL succeeded, NSError *error) {
            HomeCell *cell = (HomeCell *)[self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0]];
            [cell setLikeStatus:YES];
            if (!succeeded) {
                [cell setLikeStatus:NO];
            }
        }];
    } else {
        
        [MUtility unlikeEventInBackground:event block:^(BOOL succeeded, NSError *error) {
            HomeCell *cell = (HomeCell *)[self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0]];
            [cell setLikeStatus:NO];
            if (!succeeded) {
                [cell setLikeStatus:YES];
            }
        }];
    }
}


-(void)homeCell:(HomeCell *)homeCell didTapCommentButton:(UIButton *)button event:(PFObject *)event{

    self.currentEvent = event;
    [self performSegueWithIdentifier:@"CommentSegue" sender:self];
    
}

-(void)homeCell:(HomeCell *)homeCell didTapMoreButton:(UIButton *)button event:(PFObject *)event{
    
    self.currentEvent = event;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"分享转发" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博", @"腾讯微博", @"举报", nil];
    [actionSheet showInView:self.navigationController.view];
    
    UIColor *tintColor = [UIColor darkGrayColor];
    NSArray *actionSheetButtons = actionSheet.subviews;
    for (int i = 0; [actionSheetButtons count] > i; i++) {
        UIView *view = (UIView*)[actionSheetButtons objectAtIndex:i];
        if([view isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton*)view;
            [btn setTitleColor:tintColor forState:UIControlStateNormal];
            
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *contentString = [self.currentEvent objectForKey:@"title"];
    NSString *titleString   = [NSString stringWithFormat:@"宠物回家:%@",[self.currentEvent objectForKey:@"createdLocaleName"]];
    NSString *urlString     = @"";
    NSString *description   = @"";
    PFFile *image = [[self.currentEvent objectForKey:@"images"] objectAtIndex:0];
    
    id<ISSContent> publishContent = [ShareSDK content:contentString
                                       defaultContent:@"宠物回家分享内容"
                                                image:[ShareSDK imageWithUrl:[image url]]
                                                title:titleString
                                                  url:urlString
                                          description:description
                                            mediaType:SSPublishContentMediaTypeImage];
    
    //report
    PFObject *report = [PFObject objectWithClassName:@"Activity"];
    [report setObject:[PFUser currentUser] forKey:@"fromUser"];
    [report setObject:self.currentEvent forKey:@"Event"];
    [report setObject:[self.currentEvent objectForKey:@"organizer"]   forKey:@"toUser"];
    [report setObject:@"report"  forKey:@"type"];
    [report setObject:@0  forKey:@"status"];
    
    switch (buttonIndex) {
        case 0:
            if (![self.sinaWBCredential available]) {
                [ShareSDK authWithType:ShareTypeSinaWeibo    //需要授权的平台类型
                               options:nil            //授权选项，包括视图定制，自动授权
                                result:^(SSAuthState state, id<ICMErrorInfo> error) {  //授权返回后的回调方法
                                    if (state == SSAuthStateSuccess)
                                    {
                                        NSLog(@"成功");
                                        self.sinaWBCredential = [ShareSDK getCredentialWithType:ShareTypeSinaWeibo];
                                        NSLog(@"accessToken = %@", [self.sinaWBCredential token]);
                                        NSLog(@"expiresIn = %@", [self.sinaWBCredential expired]);
                                        NSLog(@"available = %@", [NSNumber numberWithBool:[self.sinaWBCredential available]]);
                                        [MUtility publishToSina:publishContent];
                                    }
                                    else if (state == SSAuthStateFail)
                                    {
                                        NSLog(@"失败");
                                    }else if (state ==SSAuthStateCancel){
                                        NSLog(@"取消");
                                    }
                                }];
            }else [MUtility publishToSina:publishContent];
            break;
        case 1:
            if (![self.tencentWBCredential available]) {
                [ShareSDK authWithType:ShareTypeTencentWeibo   //需要授权的平台类型
                               options:nil            //授权选项，包括视图定制，自动授权
                                result:^(SSAuthState state, id<ICMErrorInfo> error) {  //授权返回后的回调方法
                                    if (state == SSAuthStateSuccess)
                                    {
                                        NSLog(@"成功");
                                        self.tencentWBCredential = [ShareSDK getCredentialWithType:ShareTypeSinaWeibo];
                                        NSLog(@"accessToken = %@", [self.tencentWBCredential token]);
                                        NSLog(@"expiresIn = %@", [self.tencentWBCredential expired]);
                                        NSLog(@"available = %@", [NSNumber numberWithBool:[self.tencentWBCredential available]]);
                                        [MUtility publishToTencentWB:publishContent];
                                    }
                                    else if (state == SSAuthStateFail)
                                    {
                                        NSLog(@"失败");
                                    }else if (state ==SSAuthStateCancel){
                                        NSLog(@"取消");
                                    }
                                }];
            }else [MUtility publishToTencentWB:publishContent];
            break;
        case 2:
            [report saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [TSMessage showNotificationWithTitle:@"已成功举报" type:TSMessageNotificationTypeSuccess];
                }else{
                    [TSMessage showNotificationWithTitle:@"网络连接问题,稍后再试" type:TSMessageNotificationTypeError];
                }
            }];
            break;
            
        default:
            break;
    }
    
}

- (void)userDidLikeOrUnlikeEvent:(NSNotification *)note {
    NSLog(@"update table view");
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    id dvc = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"CommentSegue"]) {
        [dvc setValue:self.currentEvent forKey:@"event"];
    }
}

- (IBAction)exitToHome:(UIStoryboardSegue*)segue{
    NSLog(@"Exit to HomePage");
}
@end
