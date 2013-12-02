//
//  BookViewController.m
//  BI-iOS-2013_06-REST
//
//  Created by Jakub Hladík on 02.12.13.
//  Copyright (c) 2013 Flowknight s.r.o. All rights reserved.
//

#import "BookViewController.h"
#import "BookOperation.h"

@interface BookViewController ()

@property (readonly) NSOperationQueue *queue;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation BookViewController

@synthesize queue = _queue;

- (NSOperationQueue *)queue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 2;
    });
    return _queue;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"My Book";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    BookOperation *bo1 = [[BookOperation alloc] init];
    
    [bo1 addObserver:self forKeyPath:@"contactArray" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:NULL];
    __weak BookOperation *blockOperation = bo1;
    bo1.onFinish = ^{
        TRC_ENTRY;
        [blockOperation removeObserver:self forKeyPath:@"contactArray"];
    };
    
    [self.queue addOperation:bo1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNumber *kind = (NSNumber *)change[NSKeyValueChangeKindKey];
        switch (kind.integerValue) {
            case NSKeyValueChangeSetting:
            {
                NSArray *newArray = change[NSKeyValueChangeNewKey];
                self.dataArray = [newArray mutableCopy];
                [self.tableView reloadData];
                break;
            }
            case NSKeyValueChangeInsertion:
            {
                NSArray *new = change[NSKeyValueChangeNewKey];
                NSIndexSet *indexes = change[NSKeyValueChangeIndexesKey];
                
                [self.dataArray insertObject:new.firstObject atIndex:indexes.firstIndex];
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:indexes.firstIndex inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
                [self.tableView endUpdates];
                
                break;
            }
            default:
                break;
        }
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self.dataArray[indexPath.row] valueForKey:@"firstName"];
    // Configure the cell...
    
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
