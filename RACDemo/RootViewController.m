//
//  RootViewController.m
//  RACDemo
//
//  Created by wenlin on 14-1-16.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import "RootViewController.h"
#import <RESideMenu.h>

@interface RootViewController ()

@end

@implementation RootViewController

- (void)awakeFromNib
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuViewController"];
}

@end
