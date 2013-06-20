//
//  RoutingViewController.h
//  MapPractice
//
//  Created by Samuel Teng on 13/6/18.
//  Copyright (c) 2013年 Samuel Teng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface RoutingViewController : UIViewController<MKMapViewDelegate>

@property (nonatomic,strong) MKMapView *routeMap;
@property (nonatomic,strong) MKPolylineView *routeLineView;
@property (nonatomic,strong) MKPolyline *routeLine;

@end
