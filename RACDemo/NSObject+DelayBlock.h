//
//  NSObject+DelayBlock.h
//  RACDemo
//
//  Created by wenlin on 14-1-25.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DelayBlock)

- (void)performBlock:(void(^)(void))block afterDelay:(NSTimeInterval)delay;

@end
