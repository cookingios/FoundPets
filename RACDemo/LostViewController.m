//
//  LostViewController.m
//  RACDemo
//
//  Created by wenlin on 14-2-6.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import "LostViewController.h"
#import <UIImageView+WebCache.h>
#import <RESideMenu.h>

@interface LostViewController (){
    PopoverView *pv;
}

@property (weak, nonatomic) IBOutlet UILabel *timeDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *contentButton;
@property (weak, nonatomic) IBOutlet UIButton *blessingButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) PFObject *currentEvent;
- (IBAction)showMenu:(id)sender;

@end

@implementation LostViewController

- (void)awakeFromNib
{
    //set up data
    //your carousel should always be driven by an array of
    //data of some kind - don't store data in your item views
    //or the recycling mechanism will destroy your data once
    //your item views move off-screen
    self.items = [NSMutableArray array];
    self.dataSource = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < 20; i++)
    {
        [_items addObject:@(i)];
    }
}

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
    self.carouselView.type = iCarouselTypeLinear;
    self.carouselView.bounceDistance = 0.2 ;
    [self getEvents];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [TSMessage setDefaultViewController:self.navigationController];
    pv.contentView.alpha = 0.3;
    self.contentButton.layer.cornerRadius = self.contentButton.bounds.size.width/2.0;
    self.contentButton.layer.masksToBounds = YES;
    self.contentButton.layer.borderWidth = 1 ;
    self.contentButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.commentButton.layer.cornerRadius = self.contentButton.bounds.size.width/2.0;
    self.commentButton.layer.masksToBounds = YES;
    self.commentButton.layer.borderWidth = 1 ;
    self.commentButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.blessingButton.layer.cornerRadius = self.contentButton.bounds.size.width/2.0;
    self.blessingButton.layer.masksToBounds = YES;
    self.blessingButton.layer.borderWidth = 1 ;
    self.blessingButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getEvents{
    //get videos
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"type" equalTo:@"lost"];
    [query includeKey:@"organizer"];
    [query whereKey:@"createdLocale" nearGeoPoint:[MOManager sharedManager].currentGeoPoint];
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    if (self.dataSource.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _items = [objects mutableCopy];
            NSLog(@"get Events:%@",[NSNumber numberWithInteger:[_items count]]);
            [self.carouselView reloadData];
            self.currentEvent = _items[0];
            NSString *fromUserName = [[self.currentEvent objectForKey:@"organizer"]objectForKey:@"displayName"];
            self.timeDescriptionLabel.text =[NSString stringWithFormat:@"%@ %@发布",[MUtility getStringBetweenCurrentDateToDate:self.currentEvent.createdAt],fromUserName];
            self.locationNameLabel.text = [self.currentEvent objectForKey:@"createdLocaleName"];
            double distance = [[MOManager sharedManager].currentGeoPoint distanceInKilometersTo:[self.currentEvent objectForKey:@"createdLocale"]];
            if (distance>999) {
                self.distanceLabel.text = [NSString stringWithFormat:@"大于999.99km"];
            }else self.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",distance];
        }
    }];
}

#pragma mark - coverflow delegate datasource
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [self.items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UIImageView *coverImageView = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 290.0f, 290.0f)];
        //((UIImageView *)view).image = [UIImage imageNamed:@"videoframe"];
        view.contentMode = UIViewContentModeCenter;
        CGRect videoFrame = CGRectMake(5, 5, 280.0f, 280.0f);
        coverImageView = [[UIImageView alloc]initWithFrame:videoFrame];
        coverImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        coverImageView.tag = 100;
        coverImageView.layer.cornerRadius = 3.0f;
        coverImageView.layer.masksToBounds = YES;
        [view addSubview:coverImageView];
    }
    else
    {
        //get a reference to the label in the recycled view
        coverImageView =(UIImageView *)[view viewWithTag:100];
    }
    if ([_items[index] isKindOfClass:[PFObject class]]) {
        PFFile *cover = [[_items[index] objectForKey:@"images"] objectAtIndex:0];
        [coverImageView setImageWithURL:[NSURL URLWithString:[cover url]]];
        
    }
    return view;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    if ([_items[carousel.currentItemIndex] isKindOfClass:[PFObject class]]) {
        
    NSLog(@"%ld",(long)carousel.currentItemIndex);
    self.currentEvent = self.items[carousel.currentItemIndex];
    NSString *fromUserName = [[self.currentEvent objectForKey:@"organizer"]objectForKey:@"displayName"];
    self.timeDescriptionLabel.text =[NSString stringWithFormat:@"%@ %@发布",[MUtility getStringBetweenCurrentDateToDate:self.currentEvent.createdAt],fromUserName];
    self.locationNameLabel.text = [self.currentEvent objectForKey:@"createdLocaleName"];
    double distance = [[MOManager sharedManager].currentGeoPoint distanceInKilometersTo:[self.currentEvent objectForKey:@"createdLocale"]];
    if (distance>999) {
        self.distanceLabel.text = [NSString stringWithFormat:@"大于999.99km"];
    }else self.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",distance];
    }
}

- (IBAction)showMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewController];
}

- (IBAction)showMoreInfo:(id)sender {
        pv = [PopoverView showPopoverAtPoint:((UIButton *)sender).center
                                      inView:self.navigationController.view
                                    withText:[self.currentEvent objectForKey:@"title"] delegate:self];
}

- (IBAction)showComment:(id)sender {
    
    [self performSegueWithIdentifier:@"CommentSegue" sender:self];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    id dvc = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"CommentSegue"]) {
        [dvc setValue:self.currentEvent forKey:@"event"];
    }
    
}
@end
