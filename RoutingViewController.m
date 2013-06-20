//
//  RoutingViewController.m
//  MapPractice
//
//  Created by Samuel Teng on 13/6/18.
//  Copyright (c) 2013年 Samuel Teng. All rights reserved.
//

#import "RoutingViewController.h"
#import "AppDelegate.h"
#import "MapViewController.h"
#import "Coordinate.h"
#import "DataTableViewController.h"
#import "StartAnnotion.h"
#import "StopAnnotion.h"

@interface RoutingViewController (){
    
    AppDelegate *delegate;
    MapViewController *mapViewController;
    DataTableViewController *table;
    Coordinate *gisData;
    NSFetchedResultsController *resultController;
    NSArray *latArray;
    NSArray *lonArray;
    NSArray *pointsArray;
    MKMapRect _routeRect;
    NSMutableArray *annotations;
    NSArray *_annotations;

}

@end

@implementation RoutingViewController

@synthesize routeMap = _routeMap;
@synthesize routeLine = _routeLine;
@synthesize routeLineView = _routeLineView;

-(void)fetchData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Coordinate" inManagedObjectContext:delegate.context]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
    [request setSortDescriptors:descriptors];
    
    NSError *error;
    resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:delegate.context sectionNameKeyPath:nil cacheName:nil];
    
    if (![resultController performFetch:&error]) {
        NSLog(@"error : %@", [error localizedFailureReason]);
    }
}


-(void)loadRoute
{
    if (!resultController.fetchedObjects.count) {
        NSLog(@"there's no any GIS data in this moment");
    }
    
    for (Coordinate *coordinate in resultController.fetchedObjects) {
        latArray = delegate.latGIS;
        //[NSKeyedUnarchiver unarchiveObjectWithData:coordinate.latitude];
        lonArray = delegate.lonGIS;
        //[NSKeyedUnarchiver unarchiveObjectWithData:coordinate.lontitude];
        
        MKMapPoint northPoint;
        MKMapPoint southPoint;
        
        CLLocationCoordinate2D _rectCoordinate;
        
        MKMapPoint *pointArr = malloc(sizeof(CLLocationCoordinate2D )*latArray.count);
        
        for (int i = 0 ; i<latArray.count; i++) {
            NSString *latString = [latArray objectAtIndex:i];
            NSString *lonString = [lonArray objectAtIndex:i];
            NSArray *latlonArr = [NSArray arrayWithObjects:latString,lonString, nil];
            
            //NSLog(@"latlonArr[%i] = %@", i, latlonArr[i]);
            
            CLLocationDegrees latitude = [[latlonArr objectAtIndex:0]doubleValue];
            CLLocationDegrees lontitude = [[latlonArr objectAtIndex:1]doubleValue];
            
            CLLocationCoordinate2D _coordinate = CLLocationCoordinate2DMake(latitude, lontitude);
            MKMapPoint point = MKMapPointForCoordinate(_coordinate);
            
            if (i == 0) {
                northPoint = point;
                southPoint = point;
            }else{
                if (point.x > northPoint.x) {
                    northPoint.x = point.x;
                }
                if (point.y > northPoint.y) {
                    northPoint.y = point.y;
                }
                if (point.x < southPoint.x) {
                    southPoint.x = point.x;
                }
                if (point.y < southPoint.y) {
                    southPoint.y = point.y;
                }
            }
            
            pointArr[i] = point;
            _rectCoordinate = _coordinate;
        }
        
        _routeLine = [MKPolyline polylineWithPoints:pointArr count:latArray.count];
        
        //_routeRect = MKMapRectMake(southPoint.x, southPoint.y, northPoint.x, northPoint.y);
        
        /*zoom in to desired loading area*/
        MKCoordinateRegion drawRegion = MKCoordinateRegionMakeWithDistance(_rectCoordinate, 400, 400);
        [_routeMap setRegion:drawRegion];
    }
    
    [_routeMap addOverlay:_routeLine];
}

-(void)addAnnotation
{
    annotations = [[NSMutableArray alloc] initWithCapacity:2];
    
    StartAnnotion *startAnnotation = [[StartAnnotion alloc] init];
    [annotations insertObject:startAnnotation atIndex:0];
    
    StopAnnotion *stopAnnotation = [[StopAnnotion alloc] init];
    [annotations insertObject:stopAnnotation atIndex:1];
    
    _annotations = [NSArray arrayWithObjects:[annotations objectAtIndex:0],[annotations objectAtIndex:1], nil];
    [_routeMap addAnnotations:_annotations];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id < MKOverlay >)overlay
{
    MKOverlayPathView *overlayView = nil;
    
    if (overlay == _routeLine) {
        if (nil == _routeLineView) {
            _routeLineView = [[MKPolylineView alloc] initWithPolyline:_routeLine];
            _routeLineView.fillColor = [UIColor redColor];
            _routeLineView.strokeColor = [UIColor redColor];
            _routeLineView.lineWidth = 3;
        }
        
        overlayView = _routeLineView;
    }
    
    return overlayView;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)aAnnotation
{
    if ([aAnnotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    if ([aAnnotation isKindOfClass:[StartAnnotion class]]) {
        static NSString *startIdentifier = @"startIdentifier";
        MKPinAnnotationView *startPin = (MKPinAnnotationView *)[_routeMap dequeueReusableAnnotationViewWithIdentifier:startIdentifier];
        if (startPin == nil) {
            MKPinAnnotationView *customView = [[MKPinAnnotationView alloc] initWithAnnotation:aAnnotation reuseIdentifier:startIdentifier];
            customView.pinColor = MKPinAnnotationColorGreen;
            customView.animatesDrop = NO;
            customView.canShowCallout = YES;
            return customView;
        }else{
            startPin.annotation = aAnnotation;
            
        }
        
        return startPin;
        
    }else if ([aAnnotation isKindOfClass:[StopAnnotion class]]){
        
        static NSString *stopIdentifier = @"stopIdentifier";
        MKPinAnnotationView *stopPin = (MKPinAnnotationView *)[_routeMap dequeueReusableAnnotationViewWithIdentifier:stopIdentifier];
        if (stopPin == nil) {
            MKPinAnnotationView *customView = [[MKPinAnnotationView alloc] initWithAnnotation:aAnnotation reuseIdentifier:stopIdentifier];
            customView.pinColor = MKPinAnnotationColorRed;
            customView.animatesDrop = NO;
            customView.canShowCallout = YES;
            return customView;
        }else{
            stopPin.annotation = aAnnotation;
            
        }
        
        return stopPin;
    }
    
    return nil;
}

//-(void)toMap:(id)sender
//{
//    [delegate.navi pushViewController:mapViewController animated:YES];
//}

-(void)tableViewShow:(id)sender
{
    [delegate.navi pushViewController:table animated:YES];
}


-(void)loadView
{
    [super loadView];
    
    mapViewController = [[MapViewController alloc] init];
    table = [[DataTableViewController alloc] init];
    
    delegate = [[UIApplication sharedApplication] delegate];
    
    _routeMap = [[MKMapView alloc] initWithFrame:delegate.window.frame];
    _routeMap.delegate = self;
    [self.view addSubview:_routeMap];
    
//    UIBarButtonItem *toMap = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:self action:@selector(toMap:)];
//    self.navigationItem.leftBarButtonItem = toMap;
    
    UIBarButtonItem *toTable = [[UIBarButtonItem alloc] initWithTitle:@"Table" style:UIBarButtonItemStyleBordered target:self action:@selector(tableViewShow:)];
    self.navigationItem.leftBarButtonItem = toTable;
    
    UIBarButtonItem *drawLine = [[UIBarButtonItem alloc] initWithTitle:@"Draw" style:UIBarButtonItemStyleBordered target:self action:@selector(loadRoute)];
    self.navigationItem.rightBarButtonItem = drawLine;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self fetchData];
    [self loadRoute];
    [self addAnnotation];
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
