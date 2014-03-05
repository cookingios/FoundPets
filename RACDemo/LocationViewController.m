//
//  LocationViewController.m
//  RACDemo
//
//  Created by wenlin on 14-1-26.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
@property (weak, nonatomic) IBOutlet UIButton *currentLocationButton;
@property (weak, nonatomic) IBOutlet UIImageView *shadowImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pointerImageView;


@property (nonatomic) BOOL userLocationUpdated;
@property (strong,nonatomic)NSTimer *timer;


- (IBAction)setCurrentLocation:(id)sender;

@end

@implementation LocationViewController

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
    self.mapView.delegate = self;
    self.userLocationUpdated = NO;
    /*
    [[RACObserve([MOManager sharedManager], locationName) ignore:nil] subscribeNext:^(NSString* locationName) {
        self.centerLabel.text = locationName;
        NSLog(@"map view RAC answer is %@",locationName);
    }];
    */
    
    self.currentLocationButton.layer.cornerRadius = 3.0f;
    self.currentLocationButton.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.currentLocationButton.layer.borderWidth = 1.0;
    self.currentLocationButton.layer.masksToBounds = YES;
    self.centerLabel.layer.cornerRadius = 3.0f;
    self.centerLabel.layer.masksToBounds = YES;

    
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake([MOManager sharedManager].selectedGeoPoint.latitude,[MOManager sharedManager].selectedGeoPoint.longitude);
    double regionWidth = 2000;
    double regionHeight = 2000;
    MKCoordinateRegion startRegion = MKCoordinateRegionMakeWithDistance(centerCoordinate, regionWidth, regionHeight);
    
    [self.mapView setRegion:startRegion
                   animated:NO];
    
 
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    //[MRProgressOverlayView showOverlayAddedTo:[[self view] window] title:@"加载地图中 ..." mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    //self.timer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(handleHudTimeout) userInfo:nil repeats:NO];
    
    
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake([MOManager sharedManager].selectedGeoPoint.latitude,[MOManager sharedManager].selectedGeoPoint.longitude);
    
    [self.mapView setCenterCoordinate:centerCoordinate animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.mapView = nil;
    self.centerLabel = nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setCurrentLocation:(id)sender {
    
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
    
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    if (!self.userLocationUpdated) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
        self.userLocationUpdated = YES;
    }
}


-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{

    [MOManager sharedManager].selectedGeoPoint = [PFGeoPoint geoPointWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
    
    [[MUtility getPlaceNameByGeoPoint:[PFGeoPoint geoPointWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude]] subscribeNext:^(NSString *placeName) {
        self.centerLabel.text = placeName;
        NSLog(@"map view RAC answer is %@",placeName);
    }];
    
    [self pointerAnimationUp];

}

- (void)pointerAnimationUp{
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.pointerImageView.center = CGPointMake(self.pointerImageView.center.x, self.pointerImageView.center.y-15);
        
        self.shadowImageView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self pointerAnimationDown];
        
    }];
}


- (void)pointerAnimationDown{
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.pointerImageView.center = CGPointMake(self.pointerImageView.center.x, self.pointerImageView.center.y+15);
        self.shadowImageView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        
    }];
}

- (void)handleHudTimeout{
    [MRProgressOverlayView dismissAllOverlaysForView:[[self view] window] animated:YES completion:^{
        [TSMessage showNotificationWithTitle:@"网络连接超时,请重试" type:TSMessageNotificationTypeError];
    }];
    
}

@end
