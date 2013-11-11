//
//  Feed.h
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 29.10.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feed : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *imageThumbnailPath;
@property (nonatomic, strong) NSString *imageGalleryPath;

- (instancetype)initWithJSONObject:(id)object;
- (id)JSONObject;

@end
