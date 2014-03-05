//
//  HomeCell.h
//  RACDemo
//
//  Created by wenlin on 14-1-29.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeCellDelegate;

@interface HomeCell : PFTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdLocationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
- (IBAction)didTapLikeButtonAction:(UIButton *)button;
- (IBAction)didTapCommentButton:(UIButton *)button;
- (IBAction)didTapMoreButton:(UIButton *)button;

@property (strong,nonatomic) PFObject *event;
/*! @name Delegate */
@property (nonatomic,weak) id <HomeCellDelegate> delegate;

/*!
 Configures the Like Button to match the given like status.
 @param liked a BOOL indicating if the associated photo is liked by the user
 */
- (void)setLikeStatus:(BOOL)liked;

/*!
 Enable the like button to start receiving actions.
 @param enable a BOOL indicating if the like button should be enabled.
 */
- (void)shouldEnableLikeButton:(BOOL)enable;


@end


@protocol HomeCellDelegate <NSObject>
@optional

- (void)homeCell:(HomeCell *)homeCell didTapLikeButton:(UIButton *)button event:(PFObject *)event;

- (void)homeCell:(HomeCell *)homeCell didTapCommentButton:(UIButton *)button event:(PFObject *)event;

- (void)homeCell:(HomeCell *)homeCell didTapMoreButton:(UIButton *)button event:(PFObject *)event;

@end