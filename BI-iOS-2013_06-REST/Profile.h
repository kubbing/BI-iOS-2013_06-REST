//
//  Profile.h
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 25.11.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MapKit;

@interface Profile : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *nick;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;

- (instancetype)initWithJSONObject:(id)object;

@end
