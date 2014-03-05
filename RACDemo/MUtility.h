//
//  MUtility.h
//  Anypic
//
//  Created by Wenlin on 8/18/13.
//
#import <ShareSDK/ShareSDK.h>

@interface MUtility : NSObject

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
// show an alert message
+ (void)showAlert: (NSString *)title
         message: (NSString *)msg;

//字符串是否为空
+ (BOOL)stringIsEmpty: (NSString *)string;

//去除字符串空格
+ (NSString *)trimString:(NSString *)imputText;

+ (BOOL)checkEmailFormat:(NSString *)emailAddress;

//允许6-16位密码
+ (BOOL)checkPasswordFormat:(NSString *)password;

//根据生日拿岁数
+ (int)getAgeByBirthday: (NSDate *)birthday;

//根据生日拿星座
+ (NSString *)getAstroByBirthday: (NSDate *) birthday;

//按比例缩放图片
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

//日期转换为字符串
+ (NSString *)stringFromDate:(NSDate *)date;

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

//获取地点名称
+ (RACSignal *)getPlaceNameByGeoPoint:(PFGeoPoint*)geoPoint;

//返回根据event查询的结果
+ (PFQuery *)queryForActivitiesOnEvent:(PFObject *)event cachePolicy:(PFCachePolicy)cachePolicy;

//返回距离当前时间字段
+ (NSString*)getStringBetweenCurrentDateToDate:(NSDate *)date;

//share
+ (void)publishToSina:(id<ISSContent>) publishContent;
+ (void)publishToQzone:(id<ISSContent>) publishContent;
+ (void)publishToTencentWB:(id<ISSContent>) publishContent;
//设置
+ (void)likeEventInBackground:(id)event block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)unlikeEventInBackground:(id)event block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
@end
