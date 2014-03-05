//
//  LostViewController.h
//  RACDemo
//
//  Created by wenlin on 14-2-6.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iCarousel.h>
#import <PopoverView.h>
@interface LostViewController : UIViewController <PopoverViewDelegate,iCarouselDataSource,iCarouselDelegate>


@property (weak, nonatomic) IBOutlet iCarousel *carouselView;

@end
