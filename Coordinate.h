//
//  Coordinate.h
//  MapPractice
//
//  Created by Samuel Teng on 13/6/5.
//  Copyright (c) 2013年 Samuel Teng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Coordinate : NSManagedObject

@property (nonatomic, retain) NSData * latitude;
@property (nonatomic, retain) NSData * lontitude;
@property (nonatomic, retain) NSDate * time;

@end
