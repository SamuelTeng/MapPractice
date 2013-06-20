//
//  AppDelegate.h
//  MapPractice
//
//  Created by Samuel Teng on 13/5/28.
//  Copyright (c) 2013年 Samuel Teng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) MapViewController *mapViewController;
@property (strong,nonatomic) UINavigationController *navi;

@property (readonly , strong , nonatomic) NSManagedObjectModel *managedModel;
@property (readonly , strong , nonatomic) NSPersistentStoreCoordinator *persistentstoreCoordinator;
@property (readonly , strong ,nonatomic) NSManagedObjectContext *context;

@property (strong,nonatomic) UITextView *sharedText;

@property (nonatomic,strong) NSArray *latGIS;
@property (nonatomic,strong) NSArray *lonGIS;

-(void)initCoreData;

@end
