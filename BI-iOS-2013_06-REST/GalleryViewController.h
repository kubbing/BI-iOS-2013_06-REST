//
//  GalleryViewController.h
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 11.11.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"

@interface GalleryViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) Feed *feed;

@end
