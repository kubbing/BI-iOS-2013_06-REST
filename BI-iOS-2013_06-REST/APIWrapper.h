//
//  APIWrapper.h
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 29.10.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Feed;

@interface APIWrapper : NSObject

+ (void)feedsSuccess:(void (^)(NSArray *feeds))success failure:(void (^)())failure;

+ (void)profilesSuccess:(void (^)(NSArray *feeds))success failure:(void (^)())failure;

+ (void)postFeed:(Feed *)feed Success:(void (^)())success failure:(void (^)())failure;

+ (void)feedThumbnailAtPath:(NSString *)path Success:(void (^)(UIImage *image))success failure:(void (^)())failure;

+ (void)imageAtPath:(NSString *)path Success:(void (^)(UIImage *image))success failure:(void (^)())failure;

+ (void)createAccountWithNickname:(NSString *)nickname login:(NSString *)login success:(void (^)())success failure:(void (^)())failure;;

+ (void)saveToken:(NSString *)token success:(void (^)())success failure:(void (^)())failure;;

@end
