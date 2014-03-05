//
//  MUtility.m
//  Anypic
//
//  Created by Wenlin on 8/18/13.
//
#import "MUtility.h"


@implementation MUtility


#pragma mark - Validate 

+ (void)showAlert: (NSString *)title
         message: (NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
                                                    message: msg
                                                   delegate: nil
                                          cancelButtonTitle: @"确定"
                                          otherButtonTitles: nil];
    [alert show];
}


+ (BOOL)stringIsEmpty: (NSString *)string {
    if (string == nil || [string length] == 0) {
        return TRUE;
    }
    return FALSE;
}


+ (NSString *)trimString:(NSString *)imputText{

	NSString *trimmedComment = [imputText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	return trimmedComment;
	
}

+ (BOOL)checkEmailFormat:(NSString *)emailAddress{
	NSString *Regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";  

    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];  

    return [emailTest evaluateWithObject:emailAddress]; 


}

+ (BOOL)checkPasswordFormat:(NSString *)password{

	NSString *Regex = @"\\w{6,16}";  

    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];  

    return [emailTest evaluateWithObject:password];  


}


+ (int)getAgeByBirthday: (NSDate *)birthday {
    int age = 0;
    
    NSTimeInterval dateDiff = [birthday timeIntervalSinceNow];
    age = -1 * trunc(dateDiff / (60 * 60 * 24)) / 365;
    return age;
}


/****************************************
 摩羯座 12月22日------1月19日
 水瓶座 1月20日-------2月18日
 双鱼座 2月19日-------3月20日
 白羊座 3月21日-------4月19日
 金牛座 4月20日-------5月20日
 双子座 5月21日-------6月21日
 巨蟹座 6月22日-------7月22日
 狮子座 7月23日-------8月22日
 处女座 8月23日-------9月22日
 天秤座 9月23日------10月23日
 天蝎座 10月24日-----11月21日
 射手座 11月22日-----12月21日
 ****************************************/
+ (NSString *)getAstroByBirthday: (NSDate *) birthday {
    NSString *astrologic = @"";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat: @"MM"];              //firstly, get the month
    int i_month = 0;
    NSString *theMonth = [dateFormat stringFromDate: birthday];
    // Jan ~ Sep
    if ([[theMonth substringToIndex: 0] isEqualToString: @"0"]) {
        i_month = [[theMonth substringFromIndex: 1] intValue];
    }
    // Oct ~ Dec
    else {
        i_month = [theMonth intValue];
    }
    
    [dateFormat setDateFormat: @"dd"];              // then get the day
    int i_day = 0;
    NSString *theDay = [dateFormat stringFromDate: birthday];
    // 01 ~ 09
    if ([[theDay substringToIndex: 0] isEqualToString: @"0"]) {
        i_day = [[theDay substringFromIndex: 1] intValue];
    }
    // 10 ~ 31
    else {
        i_day = [theDay intValue];
    }
    
    switch (i_month) {
        case 1:                                     // Jan
            astrologic = (i_day <= 19) ? @"摩羯座" : @"水瓶座";
            break;
        case 2:                                     // Feb
            astrologic = (i_day <= 18) ? @"水瓶座" : @"双鱼座";
            break;
        case 3:                                     // Mar
            astrologic = (i_day <= 20) ? @"双鱼座" : @"白羊座";
            break;
        case 4:                                     // Apr
            astrologic = (i_day <= 19) ? @"白羊座" : @"金牛座";
            break;
        case 5:                                     // May
            astrologic = (i_day <= 20) ? @"金牛座" : @"双子座";
            break;
        case 6:                                     // June
            astrologic = (i_day <= 21) ? @"双子座" : @"巨蟹座";
            break;
        case 7:                                     // July
            astrologic = (i_day <= 22) ? @"巨蟹座" : @"狮子座";
            break;
        case 8:                                     // Aug
            astrologic = (i_day <= 22) ? @"狮子座" : @"处女座";
            break;
        case 9:                                     // Sep
            astrologic = (i_day <= 22) ? @"处女座" : @"天秤座";
            break;
        case 10:                                    // Oct
            astrologic = (i_day <= 23) ? @"天秤座" : @"天蝎座";
            break;
        case 11:                                    // Nov
            astrologic = (i_day <= 21) ? @"天蝎座" : @"射手座";
            break;
        case 12:                                    // Dec
            astrologic = (i_day <= 21) ? @"射手座" : @"摩羯座";
            break;
    }
    return astrologic;
}

#pragma mark - 按比例缩放图片
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{

    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
    

}

+ (NSString *)stringFromDate:(NSDate *)date{
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"MM-dd"];

    NSString *destDateString = [dateFormatter stringFromDate:localeDate];

    
    return destDateString;
    
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

+ (RACSignal *)getPlaceNameByGeoPoint:(PFGeoPoint*)geoPoint{
    
    __block NSString * placeName = [[NSString alloc]init];
    
    CLLocation *location = [[CLLocation alloc]
                            initWithLatitude:[geoPoint latitude]
                            longitude:[geoPoint longitude]];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init ];
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            
            if (error == nil &&
                [placemarks count] > 0) {
                
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                
                NSLog(@"placemarks is %@",[placemark.addressDictionary description]);
                
                if ([placemark.addressDictionary objectForKey:@"City"]) {
                    
                    if ([placemark.addressDictionary objectForKey:@"SubLocality"]) {
                        
                   placeName = [NSString stringWithFormat:@"%@,%@",[placemark.addressDictionary objectForKey:@"City"],[placemark.addressDictionary objectForKey:@"SubLocality"]];
                        
                        [subscriber sendNext:placeName];
                    }else{
                    placeName = [NSString stringWithFormat:@"%@,%@",[placemark.addressDictionary objectForKey:@"State"],[placemark.addressDictionary objectForKey:@"City"]];
                        [subscriber sendNext:placeName];
                    }
                    
                    
                }else{
                    
                   placeName = [NSString stringWithFormat:@"%@,%@",[placemark.addressDictionary objectForKey:@"State"],[placemark.addressDictionary objectForKey:@"SubLocality"]];
                    [subscriber sendNext:placeName];
                }
                
                
            }
            else if (error == nil &&
                     [placemarks count] == 0){
                NSLog(@"No results were returned.");
                placeName = @"暂无结果";
                [subscriber sendNext:placeName];
                
            }
            else if (error != nil){
                NSLog(@"An error occurred = %@", error);
                placeName = @"暂无结果";
                [subscriber sendNext:placeName];
            }
           
        }];
        return nil;
    }];
}

+ (PFQuery *)queryForActivitiesOnEvent:(PFObject *)event cachePolicy:(PFCachePolicy)cachePolicy {
    PFQuery *queryLikes = [PFQuery queryWithClassName:@"Activity"];
    [queryLikes whereKey:@"Event" equalTo:event];
    [queryLikes whereKey:@"type" equalTo:@"like"];
    
    //PFQuery *queryComments = [PFQuery queryWithClassName:kPAPActivityClassKey];
    //[queryComments whereKey:kPAPActivityPhotoKey equalTo:photo];
    //[queryComments whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeComment];
    
    //PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryLikes,queryComments,nil]];
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryLikes,nil]];
    [query setCachePolicy:cachePolicy];
    //[query includeKey:kPAPActivityFromUserKey];
    //[query includeKey:kPAPActivityPhotoKey];
    
    return query;
}

+ (NSString*)getStringBetweenCurrentDateToDate:(NSDate *)date{
    
    NSString *timeDescription = @"无法获取时间";
    NSTimeInterval tempTime=[[NSDate date] timeIntervalSinceDate:date];
    NSInteger time = (NSInteger)tempTime;
    //小于1分钟:秒
    if (time<60) {
        return [NSString stringWithFormat:@"%ld秒",(long)time];
    }
    //小于1小时:分钟
    if (time<(60*60)) {
        return [NSString stringWithFormat:@"%ld分钟",(long)(time/60)];
    }
    //小于24小时:小时
    if (time<(60*60*24)) {
        return [NSString stringWithFormat:@"%ld小时",(long)(time/(60*60))];
    }
    //小于1个月:天
    if (time<(60*60*24*30)) {
        return [NSString stringWithFormat:@"%ld天前",(long)(time/(60*60*24))];
    }
    //小于1年:月
    if (time<(60*60*24*30*12)) {
        return [NSString stringWithFormat:@"%ld月前",(long)(time/(60*60*24*30))];
    }
    //大于一年,年
    if (time>=(60*60*24*30*12)) {
        return [NSString stringWithFormat:@"%ld年前",(long)(time/(60*60*24*30*12))];
    }
    
    return timeDescription;
}
#pragma mark - share 
+ (void)publishToSina:(id<ISSContent>) publishContent {
    [ShareSDK shareContent:publishContent
                      type:ShareTypeSinaWeibo
               authOptions:nil
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSPublishContentStateSuccess)
                        {
                            NSLog(@"分享成功");
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                        }
                    }];
}
+ (void)publishToQzone:(id<ISSContent>) publishContent {
    [ShareSDK shareContent:publishContent
                      type:ShareTypeQQSpace
               authOptions:nil
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSPublishContentStateSuccess)
                        {
                            NSLog(@"分享成功");
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                        }
                    }];
}
+ (void)publishToTencentWB:(id<ISSContent>) publishContent {
    [ShareSDK shareContent:publishContent
                      type:ShareTypeTencentWeibo
               authOptions:nil
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSPublishContentStateSuccess)
                        {
                            NSLog(@"分享成功");
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                        }
                    }];
}


#pragma mark - Like Photos
+ (void)likeEventInBackground:(id)event block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:@"Activity"];
    [queryExistingLikes whereKey:@"Event" equalTo:event];
    [queryExistingLikes whereKey:@"type" equalTo:@"like"];
    [queryExistingLikes whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity delete];
            }
        }
        
        // proceed to creating new like
        PFObject *likeActivity = [PFObject objectWithClassName:@"Activity"];
        [likeActivity setObject:@"like" forKey:@"type"];
        [likeActivity setObject:[PFUser currentUser] forKey:@"fromUser"];
        [likeActivity setObject:[event objectForKey:@"organizer"] forKey:@"toUser"];
        [likeActivity setObject:@0 forKey:@"status"];
        [likeActivity setObject:event forKey:@"Event"];
        
        PFACL *likeACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [likeACL setPublicReadAccess:YES];
        likeActivity.ACL = likeACL;
        
        [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (completionBlock) {
                completionBlock(succeeded,error);
            }
            //TODO:PFPush
            /*
            if (succeeded && ![[[photo objectForKey:kPAPPhotoUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                NSString *privateChannelName = [[photo objectForKey:kPAPPhotoUserKey] objectForKey:kPAPUserPrivateChannelKey];
                if (privateChannelName && privateChannelName.length != 0) {
                    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSString stringWithFormat:@"%@ likes your photo.", [PAPUtility firstNameForDisplayName:[[PFUser currentUser] objectForKey:kPAPUserDisplayNameKey]]], kAPNSAlertKey,
                                          kPAPPushPayloadPayloadTypeActivityKey, kPAPPushPayloadPayloadTypeKey,
                                          kPAPPushPayloadActivityLikeKey, kPAPPushPayloadActivityTypeKey,
                                          [[PFUser currentUser] objectId], kPAPPushPayloadFromUserObjectIdKey,
                                          [photo objectId], kPAPPushPayloadPhotoObjectIdKey,
                                          nil];
                    PFPush *push = [[PFPush alloc] init];
                    [push setChannel:privateChannelName];
                    [push setData:data];
                    [push sendPushInBackground];
                }
            }
            */
            
            // refresh cache
            PFQuery *query = [MUtility queryForActivitiesOnEvent:event cachePolicy:kPFCachePolicyNetworkOnly];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    
                    BOOL isLikedByCurrentUser = NO;
                    
                    for (PFObject *activity in objects) {
                        if ([[[activity objectForKey:@"fromUser"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                            if ([[activity objectForKey:@"type"] isEqualToString:@"like"]) {
                                isLikedByCurrentUser = YES;
                            }
                        }
                    }
                    
                    [[MOManager sharedManager] setObjectIsLikedByCurrentUser:event liked:isLikedByCurrentUser];
                    
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"userLikedUnlikedEventCallbackFinished" object:event userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:succeeded] forKey:@"liked"]];
            }];
            
        }];
    }];

}


+ (void)unlikeEventInBackground:(id)event block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:@"Activity"];
    [queryExistingLikes whereKey:@"Event" equalTo:event];
    [queryExistingLikes whereKey:@"type" equalTo:@"like"];
    [queryExistingLikes whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity delete];
            }
            
            if (completionBlock) {
                completionBlock(YES,nil);
            }
            
            // refresh cache
            PFQuery *query = [MUtility queryForActivitiesOnEvent:event cachePolicy:kPFCachePolicyNetworkOnly];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    
                    BOOL isLikedByCurrentUser = NO;
                    
                    for (PFObject *activity in objects) {
                        if ([[[activity objectForKey:@"fromUser"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                            if ([[activity objectForKey:@"type"] isEqualToString:@"like"]) {
                                isLikedByCurrentUser = YES;
                            }
                        }
                    }
                    [[MOManager sharedManager] setObjectIsLikedByCurrentUser:event liked:isLikedByCurrentUser];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"userLikedUnlikedEventCallbackFinished" object:event userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"liked"]];
            }];
            
        } else {
            
            if (completionBlock) {
                completionBlock(NO,error);
            }
        }
    }];  
}

@end