//
//  HTTPManager.m
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 29.10.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

#import "HTTPManager.h"

@implementation HTTPManager
{
    AFHTTPSessionManager *_imageManager;
}

+ (instancetype)sharedManager
{
//    static HTTPManager *_sharedInstance;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _sharedInstance = [[self alloc] initWithBaseURL:nil];
//    });
//    return _sharedInstance;
    
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
//        NSURL *url = [NSURL URLWithString:@"http://restofka.hippotaps.com"];
        NSURL *url = [NSURL URLWithString:@"http://localhost:3000"];
        return [[self alloc] initWithBaseURL:url];
    });
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        ;
        NSURL *url = [NSURL URLWithString:@"http://localhost:3000"];
        _imageManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
        _imageManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _imageManager.responseSerializer = [AFImageResponseSerializer serializer];
//        _imageManager setco
    }
    return self;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *, id))success
                      failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    return [super GET:URLString
           parameters:parameters
              success:^(NSURLSessionDataTask *task, id responseObject){
                  TRC_LOG(@"%d, %@ %@", ((NSHTTPURLResponse *)task.response).statusCode, task.originalRequest.HTTPMethod, task.originalRequest.URL)
                  success(task, responseObject);
              } failure:^(NSURLSessionDataTask *task, NSError *error){
                  TRC_LOG(@"%d, %@ %@", ((NSHTTPURLResponse *)task.response).statusCode, task.originalRequest.HTTPMethod, task.originalRequest.URL)
                  failure(task, error);
              }];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSURLSessionDataTask *, id))success
                       failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    return [super POST:URLString
            parameters:parameters
               success:^(NSURLSessionDataTask *task, id responseObject){
                   TRC_LOG(@"%d, %@ %@", ((NSHTTPURLResponse *)task.response).statusCode, task.originalRequest.HTTPMethod, task.originalRequest.URL)
                   success(task, responseObject);
               } failure:^(NSURLSessionDataTask *task, NSError *error){
                   TRC_LOG(@"%d, %@ %@", ((NSHTTPURLResponse *)task.response).statusCode, task.originalRequest.HTTPMethod, task.originalRequest.URL)
                   failure(task, error);
               }];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
     constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                       success:(void (^)(NSURLSessionDataTask *, id))success
                       failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    return [super    POST:URLString parameters:parameters
constructingBodyWithBlock:block
                  success:^(NSURLSessionDataTask *task, id responseObject){
                      TRC_LOG(@"%d, %@ %@", ((NSHTTPURLResponse *)task.response).statusCode, task.originalRequest.HTTPMethod, task.originalRequest.URL)
                      success(task, responseObject);
                  }  failure:^(NSURLSessionDataTask *task, NSError *error){
                      TRC_LOG(@"%d, %@ %@", ((NSHTTPURLResponse *)task.response).statusCode, task.originalRequest.HTTPMethod, task.originalRequest.URL)
                      failure(task, error);
                  }];
}
- (void)getImageAtPath:(NSString *)path
            parameters:(NSDictionary *)parameters
               process:(UIImage *(^)(UIImage *))process
               success:(void (^)(NSHTTPURLResponse *, id))success
               failure:(void (^)(NSError *))failure
{
    NSParameterAssert(path);
    NSParameterAssert(success);
    NSParameterAssert(failure);
    
    NSMutableURLRequest *request = [_imageManager.requestSerializer requestWithMethod:@"GET"
                                                                   URLString:path
                                                                  parameters:parameters];
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    __block NSURLSessionDataTask *task = [_imageManager dataTaskWithRequest:request
                                                          completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                                                              if (error) {
                                                                  failure(error);
                                                              } else {
                                                                  UIImage *image = process(responseObject);
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      success((NSHTTPURLResponse *)task.response, image);
                                                                  });
                                                              }
                                                          }];
    
    [task resume];
}

@end
