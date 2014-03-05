//
//  CommentPageViewController.h
//  RACDemo
//
//  Created by wenlin on 14-2-3.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HPGrowingTextView.h>

@interface CommentPageViewController : UIViewController<HPGrowingTextViewDelegate>{
	UIView *containerView;
    HPGrowingTextView *textView;
}

@property (strong,nonatomic) PFObject *event;

@end
