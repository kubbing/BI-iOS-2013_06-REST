//
//  BookOperation.m
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 02.12.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

#import "BookOperation.h"

@implementation BookOperation
{
    BOOL _isExecuting;
    BOOL _isFinished;
}

- (void)start
{
    TRC_ENTRY;
    [self performSelector:@selector(main) withObject:nil];
}

- (void)main
{
    if (self.isCancelled) {
        [self endOperation];
        return;
    }
    
    [self beginOperation];
    
    
    
    [self endOperation];
}

- (void)beginOperation
{
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)endOperation
{
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = NO;
    [self didChangeValueForKey:@"isExecuting"];

    [self willChangeValueForKey:@"isFinished"];
    _isFinished = YES;
    [self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return _isExecuting;
}

- (BOOL)isFinished
{
    return _isFinished;
}

@end
