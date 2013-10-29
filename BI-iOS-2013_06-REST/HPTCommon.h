//
//  HPTCommon.h
//
//  Created by Jakub Hladík on 2/12/13.
//  Copyright (c) 2013 Hippotaps s.r.o. All rights reserved.
//

/*
 blockSelf
 */

#define DEFINE_BLOCK_SELF                   __weak __typeof__(self) blockSelf = self

/*
 GCD Singleton
 */

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block)           \
    static dispatch_once_t pred = 0;                        \
    __strong static id _sharedObject = nil;                 \
    dispatch_once(&pred, ^{                                 \
    _sharedObject = block();                                \
    });                                                     \
                                                            \
return _sharedObject;

/*
 Asserts
 */

#define ASSERT_MAIN_THREAD                  NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.")

/*
 Logging
 */

#define NSLog(FORMAT, ...)                  fprintf(stderr, "%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#ifdef DEBUG
#define TRC_ENTRY                           NSLog(@"ENTRY: %s:%d", __PRETTY_FUNCTION__, __LINE__)
#define TRC_EXIT                            NSLog(@"EXIT : %s:%d", __PRETTY_FUNCTION__, __LINE__)
#else
#define TRC_ENTRY
#define TRC_EXIT
#endif

#ifdef DEBUG
#define TRC_OBJ(A)                          NSLog(@"%@", A)
#define TRC_DATA(A)                         NSLog(@"DATA %10db: %@", [A length], [[NSString alloc] initWithData:A encoding:NSUTF8StringEncoding])
#define TRC_LOG(format, ...)                NSLog(format, ## __VA_ARGS__)
#define TRC_ERR(format, ...)                NSLog(@"error: %@, %s:%d " format, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __FUNCTION__, __LINE__, ## __VA_ARGS__)
#else
#define TRC_OBJ(A)
#define TRC_DATA(A)
#define TRC_LOG(format, ...)
#define TRC_ERR(format, ...)                NSLog(@"error: %@, %s:%d " format, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __FUNCTION__, __LINE__, ## __VA_ARGS__)
#endif

#ifdef DEBUG
#define TRC_POINT(A)                        TRC_OBJ(NSStringFromCGPoint(A))
#define TRC_SIZE(A)                         TRC_OBJ(NSStringFromCGSize(A))
#define TRC_RECT(A)                         TRC_OBJ(NSStringFromCGRect(A))
#define TRC_AFFINE_TRANSFORM(A)             TRC_OBJ(NSStringFromCGAffineTransform(A))
#define TRC_EDGE_INSETS(A)                  TRC_OBJ(NSStringFromUIEdgeInsets(A))
#define TRC_OFFSET(A)                       TRC_OBJ(NSStringFromUIOffset(A))
#else
#define TRC_POINT(A)
#define TRC_SIZE(A)
#define TRC_RECT(A)
#define TRC_AFFINE_TRANSFORM(A)
#define TRC_EDGE_INSETS(A)
#define TRC_OFFSET(A)
#endif
