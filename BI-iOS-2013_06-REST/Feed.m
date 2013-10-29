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
        return [NSString stringWithFormat:@"%@%@", @"http://localhost:3000", _imageThumbnailPath];
    }
}

- (instancetype)initWithJSONObject:(id)object
{
    self = [super init];
    if (self) {
        self.name = object[@"author"];
        self.message = object[@"message"];
        self.imageThumbnailPath = object[@"image"][@"image"][@"thumb"][@"url"];
    }
    return self;
}

- (id)JSONObject
{
    return @{ @"feed" : @{ @"author" : self.name,
                           @"message" : self.message }};
//    return @{ @"author" : self.name,
//              @"message" : self.message };
}

- (NSString *)description
{
    return [[NSString alloc] initWithFormat:@"Feed: %@, %@", self.name, self.message];
}

@end
