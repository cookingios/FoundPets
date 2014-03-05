//
//  LoadMoreCell.h
//  RACDemo
//
//  Created by wenlin on 14-1-30.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadMoreCell : PFTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moreLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *moreIndicatorView;

@end
