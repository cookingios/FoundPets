//
//  NSObject+DelayBlock.m
//  RACDemo
//
//  Created by wenlin on 14-1-25.
//  Copyright (c) 2014年 bryq. All rights reserved.
//

#import "NSObject+DelayBlock.h"

@implementation NSObject (DelayBlock)

- (void)performBlock:(void(^)(void))block afterDelay:(NSTimeInterval)delay{
    
    [self performSelector:@selector(fireBlockAfterDelay:) withObject:block afterDelay:delay];
    
}

- (void)fireBlockAfterDelay:(void(^)(void))block{
    
    block();
    
}

@end
