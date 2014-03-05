//
//  MOManager.m
//  RACDemo
//
//  Created by wenlin on 14-1-12.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import "MOManager.h"
#import <TSMessages/TSMessage.h>
#import <MapKit/MapKit.h>
#import "NSObject+DelayBlock.h"

@interface MOManager ()
//public
@property (nonatomic,strong,readwrite) NSArray *events;
@property (nonatomic,strong,readwrite) NSString *locationName;

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,assign) BOOL isFirstUpdate;


@end

@implementation MOManager

+ (instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (id)init {
    if (self = [super init]) {
        [[RACObserve(self,selectedGeoPoint) ignore:nil] subscribeNext:^(PFGeoPoint* geoPoint) {
            [self getPlaceNameByGeoPoint:geoPoint];
        }];
    }
    return self;
}

- (void)fetchEvents {
    NSLog(@"Fetching Opener...");
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query includeKey:@"organizer"];
    query.limit = 15;
    [query orderByDescending:@"createdAt"];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"success get ds");
            self.events = objects;
        }else{
            
        }
        
    }];

}


- (void)updateCurrentGeoPoint{
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {

        if (!error) {
            // do something with the new geoPoint
            [self setCurrentGeoPoint:geoPoint];
        }else{
            
            [TSMessage showNotificationWithTitle:@"无法获取地理位置,请打开应用设置" type:TSMessageNotificationTypeError];
        
        }
    }];

}


- (void)getPlaceNameByGeoPoint:(PFGeoPoint*)geoPoint{
    
    __block NSString * placeName = [[NSString alloc]init];
    
    CLLocation *location = [[CLLocation alloc]
                            initWithLatitude:[geoPoint latitude]
                            longitude:[geoPoint longitude]];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init ];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil &&
            [placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSLog(@"placemarks is %@",[placemark.addressDictionary description]);
            if ([placemark.addressDictionary objectForKey:@"City"]) {
                if ([placemark.addressDictionary objectForKey:@"SubLocality"]) {
                    placeName = [NSString stringWithFormat:@"%@,%@",[placemark.addressDictionary objectForKey:@"City"],[placemark.addressDictionary objectForKey:@"SubLocality"]];
                }else{
                    placeName = [NSString stringWithFormat:@"%@,%@",[placemark.addressDictionary objectForKey:@"State"],[placemark.addressDictionary objectForKey:@"City"]];
                }
            }else{
                placeName = [NSString stringWithFormat:@"%@,%@",[placemark.addressDictionary objectForKey:@"State"],[placemark.addressDictionary objectForKey:@"SubLocality"]];
            }
        }
        else if (error == nil &&
                 [placemarks count] == 0){
            NSLog(@"No results were returned.");
            placeName = @"暂无结果";
        }
        else if (error != nil){
            NSLog(@"An error occurred = %@", error);
            placeName = @"暂无结果";
        }else{
             placeName = @"暂无结果";
        }
        self.locationName = placeName ;
    }];
}
- (void)getUnreadMessageCount{
    if ([PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
        [query whereKey:@"toUser" equalTo:[PFUser currentUser]];
        [query whereKey:@"fromUser" notEqualTo:[PFUser currentUser]];
        [query whereKey:@"status" equalTo:@0];
        [query setCachePolicy:kPFCachePolicyNetworkOnly];
        [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
            if (!error) {
                // The count request succeeded. Log the count
                self.unreadMessageCount = [NSNumber numberWithInt:count];
                NSLog(@"get count %@",_unreadMessageCount);
                
            } else {
                // The request failed
                self.unreadMessageCount = @0;
                NSLog(@"get error by unread count %@",error);
            }
        }];
    }
    
    
}
- (RACSignal*)findCurrentGeoPoint{
    //地理位置
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
            NSLog(@"manager find");
            if (!error) {
                // do something with the new geoPoint
                [self setSelectedGeoPoint:geoPoint];
            }else{
                [self performBlock:^{
                    [subscriber sendError:error];
                } afterDelay:2];
            }
        }];
        return nil;
    }];
    
}
- (RACSignal*)testRAC{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        PFQuery *query = [PFQuery queryWithClassName:@"Event"];
        [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if (!error) {
                NSNumber *count = [NSNumber numberWithInt:number];
                NSLog(@"数量有:%@",count);
                [subscriber sendNext:count];
            }
        }];
        return nil;
    }];

}

//Cache
- (NSDictionary *)attributesForObject:(PFObject *)object {
    NSString *key = object.objectId;
    return [[TMCache sharedCache] objectForKey:key];

}

- (void)setAttributes:(NSDictionary *)attributes forObject:(PFObject *)object {
    NSString *key = object.objectId;
    [[TMCache sharedCache] setObject:attributes forKey:key];
}

- (BOOL)isObjectLikedByCurrentUser:(PFObject *)object{
    NSDictionary *attributes = [self attributesForObject:object];
    if (attributes) {
        return [[attributes objectForKey:@"isLikedByCurrentUser"] boolValue];
    }
    return NO;
}

- (void)setObjectIsLikedByCurrentUser:(PFObject *)object liked:(BOOL)liked{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForObject:object]];
    [attributes setObject:[NSNumber numberWithBool:liked] forKey:@"isLikedByCurrentUser"];
    [self setAttributes:attributes forObject:object];
    
}

@end
