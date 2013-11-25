//
//  LocationService.h
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 25.11.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

@import CoreLocation;

#import <Foundation/Foundation.h>

@interface LocationService : NSObject <CLLocationManagerDelegate>

+ (LocationService *)sharedService;

@end
