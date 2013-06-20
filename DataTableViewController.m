//
//  DataTableViewController.m
//  MapPractice
//
//  Created by Samuel Teng on 13/6/19.
//  Copyright (c) 2013年 Samuel Teng. All rights reserved.
//

#import "DataTableViewController.h"
#import "AppDelegate.h"
#import "MapViewController.h"
#import "Coordinate.h"
#import "RoutingViewController.h"

@interface DataTableViewController (){
    
    AppDelegate *appDelegate;
    MapViewController *mapView;
    Coordinate *coordinateData;
    NSFetchedResultsController *resultController;
    RoutingViewController *routeViewController;

}

@end

@implementation DataTableViewController

@synthesize tableView = _tableView;


-(void)fetchData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Coordinate" inManagedObjectContext:appDelegate.context]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
    [request setSortDescriptors:descriptors];
    
    NSError *error;
    resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:appDelegate.context sectionNameKeyPath:@"time" cacheName:nil];
    
    if (![resultController performFetch:&error]) {
        NSLog(@"error : %@", [error localizedFailureReason]);
    }
}

-(void)toMap:(id)sender
{
    [appDelegate.navi pushViewController:mapView animated:YES];
}

-(void)loadView
{
    [super loadView];
    
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    routeViewController = [[RoutingViewController alloc] init];
    mapView = [[MapViewController alloc] init];
    
     UIBarButtonItem *toMap = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:self action:@selector(toMap:)];
     self.navigationItem.leftBarButtonItem = toMap;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fetchData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return [[resultController sections] count];
    //return 1;
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
//    NSArray *titles = [resultController sectionIndexTitles];
//    if (titles.count <= section) {
//        return @"Error";
//    }
//    
//    return [titles objectAtIndex:section];
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView
{
//    return [resultController sectionIndexTitles];
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [[[resultController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basic cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"basic cell"];
    }
    
    NSManagedObject *managedObject = [resultController objectAtIndexPath:indexPath];
    NSDate *dataTime = [managedObject valueForKey:@"time"];
    NSDateFormatter *toString = [[NSDateFormatter alloc] init];
    [toString setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeStr = [toString stringFromDate:dataTime];
    cell.textLabel.text = timeStr;
    
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    NSManagedObject *managedObject = [resultController objectAtIndexPath:indexPath];
    NSArray *latArr = [NSKeyedUnarchiver unarchiveObjectWithData:[managedObject valueForKey:@"latitude"]];
    NSLog(@"latitude is %@", [latArr lastObject]);
    NSArray *lonArr = [NSKeyedUnarchiver unarchiveObjectWithData:[managedObject valueForKey:@"lontitude"]];
    
    appDelegate.latGIS = latArr;
    appDelegate.lonGIS = lonArr;
    
    [appDelegate.navi pushViewController:routeViewController animated:YES];
}

@end
