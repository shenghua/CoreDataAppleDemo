//
//  RootViewController.h
//  CoreDataAppleDemo
//
//  Created by wsh on 7/3/13.
//  Copyright (c) 2013 wsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RootViewController : UITableViewController <CLLocationManagerDelegate>

@property (nonatomic, retain) NSMutableArray *list;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) UIBarButtonItem *addButtonItem;

@end
