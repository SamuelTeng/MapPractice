//
//  CrumbPath.h
//  MapPractice
//
//  Created by Samuel Teng on 13/5/29.
//  Copyright (c) 2013年 Samuel Teng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <pthread.h>

@interface CrumbPath : NSObject<MKOverlay>{
    MKMapPoint *points;
    NSUInteger pointCount;
    NSUInteger pointSpace;
    
    MKMapRect boundingMapRect;
    
    pthread_rwlock_t rwLock;
    
}


-(id)initWithCenterCoordinate:(CLLocationCoordinate2D)coord;

- (MKMapRect)addCoordinate:(CLLocationCoordinate2D)coord;

-(void)lockForReading;

@property (readonly) MKMapPoint *points;
@property (readonly) NSUInteger pointCount;

-(void) unlockForReading;


@end
