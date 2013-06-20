//
//  MapViewController.m
//  MapPractice
//
//  Created by Samuel Teng on 13/5/28.
//  Copyright (c) 2013年 Samuel Teng. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"
#import "CrumbPath.h"
#import "CrumpPathView.h"
#import "DataShowViewController.h"
#import "Coordinate.h"
#import "DataTableViewController.h"

@interface MapViewController (){
    AppDelegate *appDelegate ;
    NSMutableArray *coordinateArray;
    UITextView *demo;
    DataShowViewController *dataViewController;
    DataTableViewController *tableViewController;
    NSTimer *timer;
    NSMutableArray *latitudeArray;
    NSMutableArray *lontitudeArray;

    
}

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) UIBarButtonItem *startTracking;
@property (nonatomic,strong) UIBarButtonItem *stopTracking;
@property (nonatomic,strong) CrumbPath *path;
@property (nonatomic,strong) CrumpPathView *pathView;
@property (nonatomic,strong) UIView *containerView;


@end

@implementation MapViewController

@synthesize map = _map;
@synthesize locationManager = _locationManager;
@synthesize startTracking = _startTracking;
@synthesize stopTracking = _stopTracking;
@synthesize path,pathView,containerView,managedObjectContext;
@synthesize location = _location;
@synthesize staAndsto = _staAndsto;
@synthesize toggleBackgroundButton = _toggleBackgroundButton;

- (void)switchToBackgroundMode:(BOOL)background
{
    
    if (background) {
        if (! _toggleBackgroundButton.isOn){
            
            [_locationManager stopUpdatingLocation];
            _locationManager.delegate = nil;
        }

    }else{
        
        if (!_toggleBackgroundButton.isOn) {
            _locationManager.delegate = self;
            [_locationManager startUpdatingLocation];
        }
    }
}

-(void)reloadData
{
    
//    for (int i =0; i < coordinateArray.count; i++) {
//        NSMutableString *coordinate = [NSString stringWithFormat:@"latitude is %@, longitude is %@ ,time is %@",coordinateArray[i], coordinateArray[i], coordinateArray[i]];
//        demo.text = coordinate;
//        
//                
//    }
   
    //[appDelegate.sharedText setText:demo.text];

    [appDelegate.navi pushViewController:dataViewController animated:NO];

}

-(void)updating:(id)sender
{
    NSLog(@"latitude = %f", self.location.coordinate.latitude);
//    NSLog(@"longitude = %f", self.location.coordinate.longitude);
//    NSLog(@"time = %@", [NSDate date]);
//    NSLog(@"speed = %f", self.location.speed);
//    NSLog(@"course = %f", self.location.course);
//    NSLog(@"altitude = %f", self.location.verticalAccuracy);
    
    /*tranform array to data, since they both conform nscoding protocal, then build binary data type core data attribute so that we can save array into core data 
     (https://coderwall.com/p/mx_wmq)*/
    
    [latitudeArray addObject:[NSMutableString stringWithFormat:@"%f", self.location.coordinate.latitude]];
    
    [lontitudeArray addObject:[NSMutableString stringWithFormat:@"%f", self.location.coordinate.longitude]];


    

}

-(void)trackIngstart:(id)sender
{
    [_locationManager startUpdatingLocation];
    [_map setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:NO];
    
    _toggleBackgroundButton.hidden = YES;
    
    NSLog(@"begin with %@", [NSDate date]);
    
    [latitudeArray addObject:[NSMutableString stringWithFormat:@"%f", _map.userLocation.location.coordinate.latitude]];
    
    [lontitudeArray addObject:[NSMutableString stringWithFormat:@"%f", _map.userLocation.location.coordinate.longitude]];
    
    /*record every 30 seconds*/
    timer = [NSTimer timerWithTimeInterval:10.0 target:self selector:@selector(updating:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    if (nil == coordinateArray) {
        coordinateArray = [[NSMutableArray alloc] init];
    }
    
}

-(void)trackingStop:(id)sender
{
    [_locationManager stopUpdatingLocation];
    [_map setUserTrackingMode:MKUserTrackingModeNone animated:NO];
    
    [latitudeArray addObject:[NSMutableString stringWithFormat:@"%f", _map.userLocation.location.coordinate.latitude]];
    
    [lontitudeArray addObject:[NSMutableString stringWithFormat:@"%f", _map.userLocation.location.coordinate.longitude]];
    
    NSData *latitudeData = [NSKeyedArchiver archivedDataWithRootObject:latitudeArray];
    
    NSData *lontitudeData = [NSKeyedArchiver archivedDataWithRootObject:lontitudeArray];
    
    
    /*putting GIS info into database*/
    Coordinate *database = (Coordinate *)[NSEntityDescription insertNewObjectForEntityForName:@"Coordinate" inManagedObjectContext:managedObjectContext];
    
    //CLLocationCoordinate2D locCoordinate = [_location coordinate];
    database.latitude = latitudeData;
    database.lontitude = lontitudeData;
    //[database setLatitude:[NSNumber numberWithDouble:locCoordinate.latitude]];
    //[database setLontitude:[NSNumber numberWithDouble:locCoordinate.longitude]];
    [database setTime:[NSDate date]];
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"error:%@", [error localizedFailureReason]);
    }

    
    NSLog(@"number of test array is %i", latitudeArray.count);


//    Coordinate *database = (Coordinate *)[NSEntityDescription insertNewObjectForEntityForName:@"Coordinate" inManagedObjectContext:managedObjectContext];
//    
//    CLLocationCoordinate2D locCoordinate = [_location coordinate];
//    [database setLatitude:[NSNumber numberWithDouble:locCoordinate.latitude]];
//    [database setLontitude:[NSNumber numberWithDouble:locCoordinate.longitude]];
//    [database setTime:[NSDate date]];
//    
//    NSError *error;
//    if (![managedObjectContext save:&error]) {
//        NSLog(@"error:%@", [error localizedFailureReason]);
//    }
    //[_locationManager startUpdatingLocation];
    
//    NSLog(@"latitude = %@", coordinateArray[0]);
//    NSLog(@"longitude = %@", coordinateArray[1]);
//    NSLog(@"time = %@", coordinateArray[2]);
//    NSLog(@"the number of records = %i", coordinateArray.count);
        //NSMutableString *coordinate = [NSString stringWithFormat:@"latitude is %@, longitude is %@ ,time is %@",coordinateArray[0], coordinateArray[1], coordinateArray[2]];
    [self reloadData];
    //demo.text = coordinate;
        //appDelegate.sharedText.text = demo.text;
    
    /*stop the timer*/
    [timer invalidate];
        
}

-(void)tableViewShow:(id)sender
{
    [appDelegate.navi pushViewController:tableViewController animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    self.location = [locations lastObject];
    NSTimeInterval eventInterval = [newLocation.timestamp timeIntervalSinceNow];
    
//    CLLocationDegrees latitude = newLocation.coordinate.latitude;
//    CLLocationDegrees longitude = newLocation.coordinate.longitude;
    
//    NSString *lat = [NSString stringWithFormat:@"%f", latitude];
//    NSString *lon = [NSString stringWithFormat:@"%f", longitude];
//    NSString *time = [NSString stringWithFormat:@"%i", abs(eventInterval)];
    //NSArray *temp = [[NSArray alloc] initWithObjects:lat,lon, time,nil];
    
    if (newLocation) {
        if (abs(eventInterval) < 10.0) {
            if (! self.path) {
                self.path = [[CrumbPath alloc] initWithCenterCoordinate:newLocation.coordinate];
                [_map addOverlay:self.path];
                
                MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 400, 400);
                MKCoordinateRegion adjustedRegion = [_map regionThatFits:region];
                [_map setRegion:adjustedRegion animated:YES];
//                NSLog(@"latitude = %@", lat);
//                NSLog(@"longitude = %@", lon);
//                NSLog(@"time = %@", time);
//                NSLog(@"speed = %f", newLocation.speed);
//                NSLog(@"course = %f", newLocation.course);
//                NSLog(@"altitude = %f", newLocation.verticalAccuracy);
                
                //[coordinateArray addObjectsFromArray:locations];
                
                
            }else{
                
                MKMapRect updateRect = [self.path addCoordinate:newLocation.coordinate];
                
                if (!MKMapRectIsNull(updateRect)) {
                    MKZoomScale currentZoomScale = (CGFloat)(_map.bounds.size.width/_map.visibleMapRect.size.width);
                    CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
                    updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
                    
                    [self.pathView setNeedsDisplayInMapRect:updateRect];
                }
            }
        }
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error = %@", [error localizedFailureReason]);
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id < MKOverlay >)overlay
{
    if (!self.pathView) {
        self.pathView = [[CrumpPathView alloc] initWithOverlay:overlay];
        
    }
    return self.pathView;
}

-(void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor grayColor];
    appDelegate = [[UIApplication sharedApplication] delegate];
    //appDelegate.navi.navigationItem.leftItemsSupplementBackButton = NO;
    /*hide default back button*/
    self.navigationItem.hidesBackButton = YES;

    dataViewController = [[DataShowViewController alloc] init];
    //demo = [[UITextView alloc] init];
    tableViewController = [[DataTableViewController alloc] init];
    
    _map = [[MKMapView alloc] initWithFrame:appDelegate.window.frame];
    _map.showsUserLocation = YES;
    _map.delegate = self;
    [self.view addSubview:_map];
    
    UIButton *test = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [test setTitle:@"Start" forState:UIControlStateNormal];
    test.frame = CGRectMake(270, 370, 50, 40);
    [test addTarget:self action:@selector(trackIngstart:) forControlEvents:UIControlEventTouchUpInside];
    _staAndsto = test;
    [_map addSubview:_staAndsto];
    
    _toggleBackgroundButton = [[UISwitch alloc] initWithFrame:CGRectMake(100, 370, 79, 27)];
    [_toggleBackgroundButton addTarget:self action:@selector(switchToBackgroundMode:) forControlEvents:UIControlEventValueChanged];
    [_toggleBackgroundButton setOn:YES];
    [_map addSubview:_toggleBackgroundButton];

    
    _startTracking = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(trackIngstart:)];
    _stopTracking = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(trackingStop:)];
    NSArray *itemArray = [[NSArray alloc] initWithObjects:_startTracking,_stopTracking, nil];
    self.navigationItem.rightBarButtonItems = itemArray;
    
    UIBarButtonItem *toTable = [[UIBarButtonItem alloc] initWithTitle:@"Table" style:UIBarButtonItemStyleBordered target:self action:@selector(tableViewShow:)];
    self.navigationItem.leftBarButtonItem = toTable;
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    managedObjectContext = appDelegate.context;
    //[_locationManager startUpdatingLocation];
    
    latitudeArray = [[NSMutableArray alloc] init];
    lontitudeArray = [[NSMutableArray alloc] init];
}

- (void)dealloc
{
    self.locationManager.delegate = nil;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
