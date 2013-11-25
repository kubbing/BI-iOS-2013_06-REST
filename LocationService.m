//
//  LocationService.m
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 25.11.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

#import "LocationService.h"

@import CoreLocation;

@implementation LocationService
{
    CLLocationManager *_locationManager;
}

+ (LocationService *)sharedService
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        [_locationManager startUpdatingLocation];
    }
    return self;
}

#pragma mark - CLLocationManagerDelefate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations.firstObject;
//    TRC_LOG(@"location: %f, %f", location.coordinate.latitude, location.coordinate.longitude);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"locationUpdated" object:self userInfo:@{ @"location" : location }];
}

@end
