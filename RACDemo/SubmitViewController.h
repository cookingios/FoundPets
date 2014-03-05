//
//  SubmitViewController.h
//  RACDemo
//
//  Created by wenlin on 14-1-25.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitViewController : UITableViewController<UITextViewDelegate>


@property (strong,nonatomic) NSString* type;
@property (strong,nonatomic) NSData* imgData;
@property (copy,nonatomic) NSMutableArray* images;

@end
