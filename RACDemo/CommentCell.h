//
//  CommentCell.h
//  RACDemo
//
//  Created by wenlin on 14-2-2.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

@property (strong,nonatomic) PFObject *activity;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *toUserLabel;

@end
