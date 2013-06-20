//
//  DataShowViewController.h
//  MapPractice
//
//  Created by Samuel Teng on 13/6/3.
//  Copyright (c) 2013年 Samuel Teng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataShowViewController : UIViewController

@property (nonatomic,strong) UITextView *showData;


-(void)reloadTextView;

@end
