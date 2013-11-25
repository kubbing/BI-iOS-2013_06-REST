//
//  Profile.m
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 25.11.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

#import "Profile.h"

@implementation Profile
{
    NSString *_address;
}

- (instancetype)initWithJSONObject:(id)object
{
    self = [super init];
    if (self) {
        self.nick = object[@"nick"];
        self.bio = object[@"bio"];
        self.latitude = object[@"latitude"];
        self.longitude = object[@"longitude"];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:self.latitude.floatValue longitude:self.longitude.floatValue];
        [[[CLGeocoder alloc] init] reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            for (CLPlacemark *placemark in placemarks) {
                _address = placemark.name;
            }
        }];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: %@, %@, %@", [[self class] description], self.nick, self.latitude, self.longitude];
}

#pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.latitude.floatValue, self.longitude.floatValue);
}

- (NSString *)title
{
    return self.nick;
}

- (NSString *)subtitle
{
    return _address;
}

@end
