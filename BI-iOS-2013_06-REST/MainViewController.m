//
//  MainViewController.m
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 29.10.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

#import "MainViewController.h"
#import "APIWrapper.h"
#import "Feed.h"
#import "FeedCell.h"

@interface MainViewController ()

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation MainViewController

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

- (void)addButtonAction:(id)sender
{
    Feed *feed = [[Feed alloc] init];
    feed.name = @"jakub hladi";
    feed.message = [[NSDate date] description];
    feed.image = [UIImage imageNamed:@"birth_of_venus"];
    [APIWrapper postFeed:feed Success:^(NSArray *feeds) {
        ;
    } failure:^{
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
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Feed *feed = self.dataArray[indexPath.row];
    cell.textLabel.text = feed.name;
    cell.detailTextLabel.text = feed.message;
    
    cell.imageView.image = [UIImage imageNamed:@"placeholder"];
    if (feed.imageThumbnailPath) {
        [APIWrapper feedThumbnailAtPath:feed.imageThumbnailPath Success:^(UIImage *image) {
            cell.imageView.image = image;
        } failure:^{
            ;
        }];
    }
    

    
    return cell;
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
