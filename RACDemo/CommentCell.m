//
//  CommentCell.m
//  RACDemo
//
//  Created by wenlin on 14-2-2.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import "CommentCell.h"
#import <UIImageView+WebCache.h>



@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)drawRect:(CGRect)rect{
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.bounds.size.width/2.0;
    self.avatarImageView.layer.masksToBounds = YES;
    
    
}

-(void)setActivity:(PFObject *)activity{
    
    _activity = activity;
    
    PFUser *fromUser = [activity objectForKey:@"fromUser"];
    //PFUser *toUser = [activity objectForKey:@"toUser"];
    PFFile *avatar = [fromUser objectForKey:@"avatar"];
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:[avatar url]] placeholderImage:nil];
    self.nameLabel.text = [fromUser objectForKey:@"displayName"];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:[activity objectForKey:@"content"]];
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.lineSpacing = 2;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13.0f],NSParagraphStyleAttributeName:pStyle};
    [content addAttributes:attributes range:NSMakeRange(0, content.length)];
    self.contentLabel.attributedText = content;
    //self.toUserLabel.text =[NSString stringWithFormat:@"对 %@",[toUser objectForKey:@"displayName"]];
    self.toUserLabel.text = [MUtility getStringBetweenCurrentDateToDate:activity.createdAt];
    
}

@end
