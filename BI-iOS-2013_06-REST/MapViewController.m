//
//  MapViewController.m
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 25.11.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

#import "MapViewController.h"
#import "FeedViewController.h"
#import "LocationService.h"
#import "Profile.h"
#import "APIWrapper.h"

@import MapKit;

@interface MapViewController ()

@property (weak, nonatomic) MKMapView *mapView;

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Feed" style:UIBarButtonItemStylePlain target:self action:@selector(feedButtonAction:)];
    
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.delegate = self;
    [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    mapView.showsUserLocation = YES;
    [self.view addSubview:mapView];
    self.mapView = mapView;
    
    [LocationService sharedService];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdatedNotification:) name:@"locationUpdated" object:nil];
    
    DEFINE_BLOCK_SELF;
    [APIWrapper profilesSuccess:^(NSArray *profiles) {
        TRC_OBJ(profiles);
        [blockSelf addAnnotations:profiles];
    } failure:^{
        ;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)addAnnotations:(NSArray *)annotations
{
    [self.mapView addAnnotations:annotations];
    
    MKMapRect zoomRect = MKMapRectNull;
    for (id<MKAnnotation> annotation in annotations) {
        MKMapPoint point = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect rect = MKMapRectMake(point.x, point.y, 0, 0);
        zoomRect = MKMapRectUnion(zoomRect, rect);
    }
    
    [self.mapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(16, 16, 16, 16) animated:YES];
    
//    CLLocationDistance distance = [location1 distanceFromLocation:location2];
//    CLLocationCoordinate2D cernter = CLLocationCoordinate2DMake((userCoordinate.latitude+festivalCoordinate.latitude)/2.0,
//                                                                (userCoordinate.longitude+festivalCoordinate.longitude)/2.0);
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(cernter, 1.2*distance, 1.2*distance);
//    [self.mapView setRegion:region animated:YES];
}

#pragma mark - Notifications

- (void)locationUpdatedNotification:(NSNotification *)notification
{
//    TRC_OBJ(notification.userInfo);
}

#pragma mark - Actions

- (void)feedButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MKMapViewDeledate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        pinView.pinColor = MKPinAnnotationColorPurple;
//        pinView.draggable = YES;
        
        UIImage *image = [UIImage imageNamed:@"placeholder"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = image;
        pinView.leftCalloutAccessoryView = imageView;
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    return pinView;
}



@end
