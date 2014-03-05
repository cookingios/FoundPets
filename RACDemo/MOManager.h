//
//  MOManager.h
//  RACDemo
//
//  Created by wenlin on 14-1-12.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TMCache.h>

@interface MOManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic,strong,readonly) NSArray *events;
@property (nonatomic,strong) PFGeoPoint *selectedGeoPoint;
@property (nonatomic,strong) PFGeoPoint *currentGeoPoint;
@property (nonatomic,strong,readonly) NSString *locationName;
@property (nonatomic,strong) NSNumber *unreadMessageCount;

- (void)fetchEvents;
- (void)updateCurrentGeoPoint;
- (void)getPlaceNameByGeoPoint:(PFGeoPoint*)geoPoint;
- (void)getUnreadMessageCount;
- (RACSignal*)findCurrentGeoPoint;
- (RACSignal*)testRAC;

//Cache
- (NSDictionary *)attributesForObject:(PFObject *)object;
- (void)setObjectIsLikedByCurrentUser:(PFObject *)object liked:(BOOL)liked;
- (BOOL)isObjectLikedByCurrentUser:(PFObject *)object;


@end
