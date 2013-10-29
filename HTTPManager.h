//
//  HTTPManager.h
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 29.10.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface HTTPManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

- (void)getImageAtPath:(NSString *)path
            parameters:(NSDictionary *)parameters
               process:(UIImage *(^)(UIImage *))process
               success:(void (^)(NSHTTPURLResponse *, id))success
               failure:(void (^)(NSError *))failure;

@end
