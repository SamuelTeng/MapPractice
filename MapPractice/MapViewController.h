//
//  MapViewController.h
//  MapPractice
//
//  Created by Samuel Teng on 13/5/28.
//  Copyright (c) 2013年 Samuel Teng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<MKMapViewDelegate , CLLocationManagerDelegate>

- (void)switchToBackgroundMode:(BOOL)background;

- (void)reloadData;
@property (nonatomic,strong) MKMapView *map;
@property (readonly , strong ,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) CLLocation *location;

@property (nonatomic,strong) UIButton *staAndsto;

@property (nonatomic,strong) UISwitch *toggleBackgroundButton;

@end
