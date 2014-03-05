//
//  LocationViewController.h
//  RACDemo
//
//  Created by wenlin on 14-1-26.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LocationViewController : UIViewController<MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) PFGeoPoint *currentGeoPoint;

@end
