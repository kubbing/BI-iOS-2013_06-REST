//
//  Feed.m
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 29.10.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

#import "Feed.h"

@implementation Feed

- (NSString *)imageThumbnailPath
{
    if ((NSNull *)_imageThumbnailPath == [NSNull null]) {
        return nil;
    }
    else {
        /*
         TODO: vysledna URL by se mela konstruovat jinde nez tady
         */
        return [NSString stringWithFormat:@"%@%@", kBaseURLString, _imageThumbnailPath];
    }
}

- (NSString *)imageGalleryPath
{
    if ((NSNull *)_imageGalleryPath == [NSNull null]) {
        return nil;
    }
    else {
        /*
         TODO: vysledna URL by se mela konstruovat jinde nez tady
         */
        return [NSString stringWithFormat:@"%@%@", kBaseURLString, _imageGalleryPath];
    }
}

- (instancetype)initWithJSONObject:(id)object
{
    self = [super init];
    if (self) {
        self.name = object[@"account"][@"nick"];
        self.message = object[@"message"];
        self.imageThumbnailPath = object[@"image"][@"image"][@"thumb_160"][@"url"];
        self.imageGalleryPath = object[@"image"][@"image"][@"gallery_960"][@"url"];
    }
    return self;
}

- (id)JSONObject
{
    return @{ @"feed" : @{ @"author" : self.name,
                           @"message" : self.message }};
}

- (NSString *)description
{
    return [[NSString alloc] initWithFormat:@"Feed: %@, %@", self.name, self.message];
}

@end
