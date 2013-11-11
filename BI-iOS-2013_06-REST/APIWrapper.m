//
//  APIWrapper.m
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 29.10.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

#import "APIWrapper.h"
#import "Feed.h"
#import "HTTPManager.h"

@implementation APIWrapper

+ (void)feedsSuccess:(void (^)(NSArray *))success failure:(void (^)())failure
{
    NSParameterAssert(success);
    NSParameterAssert(failure);
    
    [[HTTPManager sharedManager] GET:@"feeds.json"
                          parameters:nil
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 NSArray *array = [responseObject isKindOfClass:[NSArray class]]? (NSArray *)responseObject : nil;
                                 if (!array) {
                                     failure();
                                 }
                                 
                                 NSMutableArray *feedArray = [NSMutableArray array];
                                 for (id object in array) {
                                     [feedArray addObject:[[Feed alloc] initWithJSONObject:object]];
                                 }
                                 
                                     // ulozit do databaze...
                                 
                                 success(feedArray);
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                 ;
                             }];
    
//    Feed *feed = [[Feed alloc] init];
//    feed.name = @"Jakub Hladik";
//    feed.message = @"uci iOS…";
//    
//    double delayInSeconds = 2.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        success(@[feed]);
//    });
}

+ (void)postFeed:(Feed *)feed Success:(void (^)())success failure:(void (^)())failure
{
    TRC_ENTRY;
    NSParameterAssert(success);
    NSParameterAssert(failure);
    
    if (feed.image) {
        [[HTTPManager sharedManager] POST:@"feeds" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            /*
             tohle si nekde zapiste, bude se vam to hodit :D
             */
            [formData appendPartWithFormData:[feed.name dataUsingEncoding:NSUTF8StringEncoding]
                                        name:@"feed[author]"];
            [formData appendPartWithFormData:[feed.message dataUsingEncoding:NSUTF8StringEncoding]
                                        name:@"feed[message]"];
            [formData appendPartWithFileData:UIImagePNGRepresentation(feed.image)
                                        name:@"feed[image]"
                                    fileName:@"photo.png"
                                    mimeType:@"image/png"];
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            TRC_ENTRY;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            TRC_ENTRY;
        }];
    }
    else {
        [[HTTPManager sharedManager]POST:@"feeds.json"
                              parameters:[feed JSONObject]
                                 success:^(NSURLSessionDataTask *task, id responseObject) {
                                     TRC_ENTRY;
                                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                     TRC_ENTRY;
                                 }];
    }
}

+ (void)feedThumbnailAtPath:(NSString *)path Success:(void (^)(UIImage *image))success failure:(void (^)())failure
{
    [[HTTPManager sharedManager] getImageAtPath:path
                                     parameters:nil
                                        process:^UIImage *(UIImage *image) {
                                            return [image roundImage];
                                        } success:^(NSHTTPURLResponse *response, id responseObject) {
                                            success(responseObject);
                                        } failure:^(NSError *error) {
                                            TRC_ENTRY;
                                        }];
}

+ (void)imageAtPath:(NSString *)path Success:(void (^)(UIImage *))success failure:(void (^)())failure
{
    [[HTTPManager sharedManager] getImageAtPath:path
                                     parameters:nil
                                        process:^UIImage *(UIImage *image) {
                                            return image;
                                        } success:^(NSHTTPURLResponse *response, id responseObject) {
                                            success(responseObject);
                                        } failure:^(NSError *error) {
                                            TRC_ENTRY;
                                        }];
}

+ (void)createAccountWithNickname:(NSString *)nickname
                          success:(void (^)())success
                          failure:(void (^)())failure
{
    NSParameterAssert(success);
    NSParameterAssert(failure);
    
    NSNumber *accountId = [[NSUserDefaults standardUserDefaults] objectForKey:@"accountId"];
    if (accountId) {
        TRC_LOG(@"account exists, id: %@", accountId);
        success();
        return;
    }
    
    NSDictionary *params = @{ @"account" :
                                  @{ @"login" : @"awesome_login_1",
                                     @"nick" : nickname }};
    
    [[HTTPManager sharedManager] POST:@"accounts.json"
                           parameters:params
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  NSDictionary *dictionary = [responseObject isKindOfClass:[NSDictionary class]]? (NSDictionary *)responseObject : nil;
                                  if (!dictionary) {
                                      failure();
                                  }
                                  
                                  NSNumber *accountId = dictionary[@"id"];
                                  [[NSUserDefaults standardUserDefaults] setObject:accountId forKey:@"accountId"];
                                  [[NSUserDefaults standardUserDefaults] synchronize];
                                  

                                  
                                  success();
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  ;
                              }];
}

+ (void)saveToken:(NSString *)token success:(void (^)())success failure:(void (^)())failure
{
    NSParameterAssert(success);
    NSParameterAssert(failure);
    
    NSNumber *accountId = [[NSUserDefaults standardUserDefaults] objectForKey:@"accountId"];
    if (!accountId) {
        double delayInSeconds = 5.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self saveToken:token success:success failure:failure];
        });
        return;
    }
    
    [[HTTPManager sharedManager] PUT:[NSString stringWithFormat:@"accounts/%@.json", [accountId description]]
                          parameters:@{ @"account" : @{ @"token" : token }}
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 
                                 
                                 success();
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                 ;
                             }];
}

@end
