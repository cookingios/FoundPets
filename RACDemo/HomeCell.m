//
//  HomeCell.m
//  RACDemo
//
//  Created by wenlin on 14-1-29.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import "HomeCell.h"
#import <UIImageView+WebCache.h>

@implementation HomeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //[self.likeButton addTarget:self action:@selector(didTapLikeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        // Initialization code
        /*
        [[RACObserve(self, event) ignore:nil] subscribeNext:^(PFObject* object) {
        
            PFUser *user = [object objectForKey:@"organizer"];
            PFFile *avatar = [user objectForKey:@"avatar"];
            [self.avatarImageView setImageWithURL:[NSURL URLWithString:[avatar url]] placeholderImage:nil];
            self.nameLabel.text = [user objectForKey:@"displayName"];
            
            //cell.titleLabel.text = [object objectForKey:@"title"];
            NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[object objectForKey:@"title"]];
            NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
            pStyle.lineSpacing = 2;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13.0f],NSParagraphStyleAttributeName:pStyle};
            [title addAttributes:attributes range:NSMakeRange(0, title.length)];
            self.titleLabel.attributedText = title;
            
            PFFile *eventImage = [[object objectForKey:@"images"]objectAtIndex:0];
            [self.eventImageView setImageWithURL:[NSURL URLWithString:[eventImage url]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            self.createdLocationNameLabel.text = [object objectForKey:@"createdLocaleName"];
            
        }];
         */
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
    self.likeButton.layer.cornerRadius = 2.0f;
    self.likeButton.layer.masksToBounds = YES;
    self.commentButton.layer.cornerRadius = 2.0f;
    self.commentButton.layer.masksToBounds = YES;
    self.moreButton.layer.cornerRadius = 2.0f;
    self.moreButton.layer.masksToBounds = YES;
    
}
-(void)setEvent:(PFObject *)object{

    _event = object;

    PFUser *user = [object objectForKey:@"organizer"];
    PFFile *avatar = [user objectForKey:@"avatar"];
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:[avatar url]] placeholderImage:nil];
    self.nameLabel.text = [user objectForKey:@"displayName"];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[object objectForKey:@"title"]];
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.lineSpacing = 2;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13.0f],NSParagraphStyleAttributeName:pStyle};
    [title addAttributes:attributes range:NSMakeRange(0, title.length)];
    self.titleLabel.attributedText = title;

    PFFile *eventImage = [[object objectForKey:@"images"] objectAtIndex:0];
    [self.eventImageView setImageWithURL:[NSURL URLWithString:[eventImage url]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.createdLocationNameLabel.text = [object objectForKey:@"createdLocaleName"];
    self.timeDescriptionLabel.text = [MUtility getStringBetweenCurrentDateToDate:object.createdAt];
    double distance = [[MOManager sharedManager].currentGeoPoint distanceInKilometersTo:[object objectForKey:@"createdLocale"]];
    if (distance>999) {
        self.distanceDescriptionLabel.text = [NSString stringWithFormat:@"大于1000km"];
    }else self.distanceDescriptionLabel.text = [NSString stringWithFormat:@"%.2fkm",distance];
    
    self.typeLabel.layer.cornerRadius = 2.0f;
    self.typeLabel.layer.masksToBounds = YES;
    NSString * type = [object objectForKey:@"type"];
    if (type && [type isEqualToString:@"clue"]) {
        [self.typeLabel setBackgroundColor:[UIColor colorWithRed:52.0/255 green:186.0/255 blue:95.0/255 alpha:1.0]];
        self.typeLabel.text = @"线索";
        
    }else if(type && [type isEqualToString:@"lost"]){
        [self.typeLabel setBackgroundColor:[UIColor colorWithRed:255.0/255 green:97.0/255 blue:55.0/255 alpha:1.0]];
        self.typeLabel.text = @"丢失";
        [self.likeButton setTitle:@"祝福" forState:UIControlStateNormal];
        [self.likeButton setTitle:@"祝福" forState:UIControlStateSelected];
        [self.likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }else if(type && [type isEqualToString:@"adopt"]){
        self.typeLabel.text = @"领养";
        [self.typeLabel setBackgroundColor:[UIColor colorWithRed:225.0/255 green:178.0/255 blue:22.0/255 alpha:1.0]];
    }

}

- (void)setLikeStatus:(BOOL)liked {
    [self.likeButton setSelected:liked];
    
    if (liked) {
        [self.likeButton setBackgroundColor:[UIColor lightGrayColor]];
    } else {
        [self.likeButton setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }
}

- (void)shouldEnableLikeButton:(BOOL)enable {
    if (!enable) {
        [self.likeButton removeTarget:self action:@selector(didTapLikeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.likeButton addTarget:self action:@selector(didTapLikeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - delegate
- (IBAction)didTapLikeButtonAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeCell:didTapLikeButton:event:)]) {
        [self.delegate homeCell:self didTapLikeButton:button event:self.event];
    }
}

- (IBAction)didTapCommentButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeCell:didTapCommentButton:event:)]) {
        [self.delegate homeCell:self didTapCommentButton:button event:self.event];
    }
    
}

- (IBAction)didTapMoreButton:(UIButton *)button {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeCell:didTapMoreButton:event:)]) {
        [self.delegate homeCell:self didTapMoreButton:button event:self.event];
    }
}

@end
