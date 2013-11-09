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

/*
 pri prvnim zavolani to vytvori GCD frontu ktera zpracovava tasky na pozadi
 */
- (dispatch_queue_t)backgroundCompletionQueue
{
    static dispatch_queue_t _bg_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bg_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    });
    
    return _bg_queue;
}

+ (instancetype)sharedManager
{
    /*
     zakomentovany kod dela to same jako to makro
     */
//    static HTTPManager *_sharedInstance;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _sharedInstance = [[self alloc] initWithBaseURL:nil];
//    });
//    return _sharedInstance;
    
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        NSURL *url = [NSURL URLWithString:kBaseURLString];
        return [[self alloc] initWithBaseURL:url];
    });
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        ;
        /*
         druhy sessionManader ktery umi deserializovat obrazky
         */
        NSURL *url = [NSURL URLWithString:kBaseURLString];
        _imageManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
        _imageManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _imageManager.responseSerializer = [AFImageResponseSerializer serializer];
        /*
         callbacky budou bezet na pozadi ve fronte
         */
        [_imageManager setCompletionQueue:[self backgroundCompletionQueue]];
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
          
          TRC_LOG(@"%d, %@ %@", ((NSHTTPURLResponse *)task.response).statusCode, task.originalRequest.HTTPMethod, task.originalRequest.URL)
          
          if (error) {
              failure(error);
          } else {
              NSAssert(![NSThread currentThread].isMainThread, @"this must be executed on background thread");
              UIImage *image = process(responseObject);
              dispatch_async(dispatch_get_main_queue(), ^{
                  NSAssert([NSThread currentThread].isMainThread, @"this must be executed on main thread");
                  success((NSHTTPURLResponse *)task.response, image);
              });
          }
      }];
    
    [task resume];
}

@end
