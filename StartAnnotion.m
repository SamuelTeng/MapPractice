//
//  StartAnnotion.m
//  MapPractice
//
//  Created by Samuel Teng on 13/6/20.
//  Copyright (c) 2013年 Samuel Teng. All rights reserved.
//

#import "StartAnnotion.h"
#import "AppDelegate.h"
@implementation StartAnnotion

-(CLLocationCoordinate2D)coordinate
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSString *startLat = [delegate.latGIS objectAtIndex:0];
    NSString *startLon = [delegate.lonGIS objectAtIndex:0];
    NSArray *staLatLon = [NSArray arrayWithObjects:startLat,startLon, nil];
    CLLocationDegrees latStart = [[staLatLon objectAtIndex:0] doubleValue];
    CLLocationDegrees lonStart = [[staLatLon objectAtIndex:1] doubleValue];
    CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake(latStart, lonStart);
    
    return startCoordinate;
}

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    return @"Start Here";
}

@end
