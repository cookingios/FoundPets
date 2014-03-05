//
//  LoadMoreCell.m
//  RACDemo
//
//  Created by wenlin on 14-1-30.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import "LoadMoreCell.h"

@implementation LoadMoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapMoreLabel:)];
        //[self.moreLabel addGestureRecognizer:tap];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)didTapMoreLabel:(id)sender{
    

}

@end
