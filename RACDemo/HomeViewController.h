//
//  HomeViewController.h
//  RACDemo
//
//  Created by wenlin on 14-1-16.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCell.h"

@interface HomeViewController : PFQueryTableViewController<HomeCellDelegate,UIActionSheetDelegate>


@property (strong,nonatomic) PFObject *myEvent;
@property (strong,nonatomic) NSString *eventType;

@end
