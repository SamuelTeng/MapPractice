//
//  DataTableViewController.h
//  MapPractice
//
//  Created by Samuel Teng on 13/6/19.
//  Copyright (c) 2013年 Samuel Teng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DataTableViewController : UITableViewController<UITableViewDelegate, NSFetchedResultsControllerDelegate>


@property (nonatomic,strong) UITableView *tableView;

@end
