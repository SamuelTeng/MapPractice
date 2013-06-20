//
//  StopAnnotion.m
//  MapPractice
//
//  Created by Samuel Teng on 13/6/20.
//  Copyright (c) 2013年 Samuel Teng. All rights reserved.
//

#import "StopAnnotion.h"
#import "AppDelegate.h"
@implementation StopAnnotion


-(CLLocationCoordinate2D)coordinate
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSString *stoptLat = [delegate.latGIS lastObject];
    NSString *stoptLon = [delegate.lonGIS lastObject];
    NSArray *stoLatLon = [NSArray arrayWithObjects:stoptLat,stoptLon, nil];
    CLLocationDegrees latStart = [[stoLatLon objectAtIndex:0] doubleValue];
    CLLocationDegrees lonStart = [[stoLatLon objectAtIndex:1] doubleValue];
    CLLocationCoordinate2D stopCoordinate = CLLocationCoordinate2DMake(latStart, lonStart);
    
    return stopCoordinate;
}

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    return @"Stop Here";
}

@end
