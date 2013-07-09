//
//  SQAppDelegate.h
//  CoreDataAppleDemo
//
//  Created by wsh on 7/3/13.
//  Copyright (c) 2013 wsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
