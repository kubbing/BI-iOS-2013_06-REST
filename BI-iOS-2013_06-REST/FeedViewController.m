//
//  MainViewController.m
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 29.10.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

#import "FeedViewController.h"
#import "APIWrapper.h"
#import "Feed.h"
#import "FeedCell.h"
#import "NewFeedViewController.h"
#import "GalleryViewController.h"
#import "MapViewController.h"

@interface FeedViewController ()

@property (strong, nonatomic) NSArray *dataArray;
@property (readonly) UIImage *placeholderImage;

@end

@implementation FeedViewController

@synthesize placeholderImage = _placeholderImage;

- (UIImage *)placeholderImage
{
    if (!_placeholderImage) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _placeholderImage = [[UIImage imageNamed:@"placeholder"] roundImage];
        });
    }
    
    return _placeholderImage;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Restofka";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonAction:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(mapButtonAction:)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[FeedCell class] forCellReuseIdentifier:@"Cell"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlAction:) forControlEvents:UIControlEventValueChanged];
    [self refreshControlAction:self.refreshControl];
    [self.refreshControl beginRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)mapButtonAction:(id)sender
{
    MapViewController *mainController = [[MapViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainController];
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

- (void)addButtonAction:(id)sender
{
//    NSAssert(false, @"lol fail & lame");
//    Feed *feed = [[Feed alloc] init];
//    feed.name = @"jakub hladi";
//    feed.message = [[NSDate date] description];
//    feed.image = [UIImage imageNamed:@"birth_of_venus"];
//    [APIWrapper postFeed:feed Success:^(NSArray *feeds) {
//        ;
//    } failure:^{
//        ;
//    }];
    
    NewFeedViewController *controller = [[NewFeedViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.navigationController presentViewController:navController animated:YES completion:^{
        ;
    }];
}

- (void)refreshControlAction:(UIRefreshControl *)refreshControl
{
    [APIWrapper feedsSuccess:^(NSArray *feeds) {
        TRC_ENTRY;
        self.dataArray = feeds;
        [self.tableView reloadData];
        [refreshControl endRefreshing];
    } failure:^{
        TRC_ENTRY;
        [refreshControl endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Feed *feed = self.dataArray[indexPath.row];
    cell.nameLabel.text = feed.name;
    cell.messageLabel.text = feed.message;
    
    cell.thumbView.image = self.placeholderImage;
    if (feed.imageThumbnailPath) {
        [APIWrapper feedThumbnailAtPath:feed.imageThumbnailPath Success:^(UIImage *image) {
            cell.thumbView.image = image;
        } failure:^{
            ;
        }];
    }
    

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Feed *feed = self.dataArray[indexPath.row];
    
    GalleryViewController* galleryVC = [[GalleryViewController alloc] init];
    galleryVC.feed = feed;
    galleryVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:galleryVC];
    [self presentViewController:navController animated:YES completion:nil];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
