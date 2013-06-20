//
//  AppDelegate.m
//  MapPractice
//
//  Created by Samuel Teng on 13/5/28.
//  Copyright (c) 2013年 Samuel Teng. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Coordinate.h"

@implementation AppDelegate

@synthesize navi,mapViewController,sharedText,context,managedModel,persistentstoreCoordinator,latGIS,lonGIS;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.sharedText = [[UITextView alloc] init];
    //self.sharedText.text = @"from app delegate";
    self.latGIS = [[NSArray alloc] init];
    self.lonGIS = [[NSArray alloc] init];
    
    [self initCoreData];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.mapViewController = [[MapViewController alloc] init];
    self.navi = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    
    self.window.rootViewController = navi;
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    MapViewController *mapView = (MapViewController *)self.navi.visibleViewController;
    [mapView switchToBackgroundMode:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    MapViewController *mapView = (MapViewController *)self.navi.visibleViewController;
    [mapView switchToBackgroundMode:NO];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)initCoreData
{
    NSError *error;
    
    //資料檔路徑
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MapData.db"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    // 初始化model coordinator context
    managedModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    persistentstoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedModel];
    if (![persistentstoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]) {
        NSLog(@"Error: %@", [error localizedFailureReason]);
    }else{
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:persistentstoreCoordinator];
    }
}

@end
