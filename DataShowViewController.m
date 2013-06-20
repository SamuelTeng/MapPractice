//
//  DataShowViewController.m
//  MapPractice
//
//  Created by Samuel Teng on 13/6/3.
//  Copyright (c) 2013年 Samuel Teng. All rights reserved.
//

#import "DataShowViewController.h"
#import "AppDelegate.h"
#import "MapViewController.h"
#import "Coordinate.h"
#import "RoutingViewController.h"
#import "DataTableViewController.h"

@interface DataShowViewController (){
    AppDelegate *appDelegate;
    MapViewController *mapView;
    Coordinate *coordinateData;
    NSFetchedResultsController *resultController;
    RoutingViewController *routeViewController;
    DataTableViewController *table;
}

@end

@implementation DataShowViewController

@synthesize showData;

-(void)fetchData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Coordinate" inManagedObjectContext:appDelegate.context]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
    [request setSortDescriptors:descriptors];
    
    NSError *error;
    resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:appDelegate.context sectionNameKeyPath:nil cacheName:nil];
    
    if (![resultController performFetch:&error]) {
        NSLog(@"error : %@", [error localizedFailureReason]);
    }
}

-(void)reloadTextView
{
    showData = [[UITextView alloc] initWithFrame:self.view.bounds];
        //showData.text = appDelegate.sharedText.text;
    //[showData setText:appDelegate.sharedText.text];
    //showData.text = @"test";
    //showData.textColor = [UIColor blackColor];
    //[showData setFont:[UIFont systemFontOfSize:20.0]];
    //[self.view addSubview:showData];
    
    if (! resultController.fetchedObjects.count) {
        NSLog(@"Database has no data in this time");
    }
    
    for (Coordinate *coordinate in resultController.fetchedObjects) {
//        NSLog(@"The collected datas, latitude and lontitude are %@, %@ and %@ respectively", coordinate.time, coordinate.latitude, coordinate.lontitude);
        
        /*when save core data attribute as binary data, we must uncode the attribute when retrieving it because it's an encoded data(https://coderwall.com/p/mx_wmq)*/
        
        NSMutableArray *latitudeArray = [NSKeyedUnarchiver unarchiveObjectWithData:coordinate.latitude ];
        for (int i = 0; i <latitudeArray.count; i++) {
            NSLog(@"latitudeArry[%i] = %@",i, latitudeArray[i]);
        }
        
        NSMutableArray *lontitudeArray = [NSKeyedUnarchiver unarchiveObjectWithData:coordinate.lontitude];
        
        NSMutableString *dataString = [NSString stringWithFormat:@"The collected datas, latitude and lontitude are %@, %@ and %@ respectively", coordinate.time, [latitudeArray lastObject], [lontitudeArray lastObject]];
        
        [showData setText:dataString];
        showData.textColor = [UIColor blackColor];
        [showData setFont:[UIFont systemFontOfSize:20.0]];

    }
    [self.view addSubview:showData];


}

-(void)goBack:(id)sender
{
    showData.text = nil;
    [appDelegate.navi pushViewController:mapView animated:YES];
    
    NSLog(@"go back");
}

//-(void)toRoute:(id)sender
//{
//    [appDelegate.navi pushViewController:routeViewController animated:YES];
//}
//
//-(void)tableViewShow:(id)sender
//{
//    [appDelegate.navi pushViewController:table animated:YES];
//}

-(void)loadView
{
    [super loadView];
    appDelegate = [[UIApplication sharedApplication] delegate];
    mapView = [[MapViewController alloc] init];
    routeViewController = [[RoutingViewController alloc] init];
    table = [[DataTableViewController alloc] init];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];

//    UIBarButtonItem *toTable = [[UIBarButtonItem alloc] initWithTitle:@"Table" style:UIBarButtonItemStyleBordered target:self action:@selector(tableViewShow:)];
//    
//    NSArray *leftArray = [[NSArray alloc] initWithObjects:back,toTable, nil];
    
    self.navigationItem.leftBarButtonItem = back;

    
//    UIBarButtonItem *toRoute = [[UIBarButtonItem alloc] initWithTitle:@"Route" style:UIBarButtonItemStyleBordered target:self action:@selector(toRoute:)];
//    self.navigationItem.rightBarButtonItem = toRoute;
    

    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self fetchData];
    [self reloadTextView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
