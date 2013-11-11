//
//  GalleryViewController.m
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 11.11.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

#import "GalleryViewController.h"
#import "APIWrapper.h"

@interface GalleryViewController ()

@property (nonatomic,weak) UIScrollView* scrollView;
@property (nonatomic,weak) UIImageView* imageView;

@end

@implementation GalleryViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scrollView.minimumZoomScale = 1.0;
    scrollView.maximumZoomScale = 2.0;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    {
        scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(scrollView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(scrollView)]];
    }
    self.scrollView = scrollView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
    imageView.tag = 1;
    imageView.contentMode = UIViewContentModeCenter;
    [self.scrollView addSubview:imageView];
    {
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
//        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.scrollView
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0
                                                                     constant:0.0]];
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.scrollView
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0
                                                                     constant:0.0]];
    }
    self.imageView = imageView;
    
    DEFINE_BLOCK_SELF;
    [APIWrapper imageAtPath:self.feed.imageGalleryPath
                    Success:^(UIImage *image) {
                        blockSelf.imageView.image = image;
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

- (void)cancelAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView viewWithTag:1];
}


@end
