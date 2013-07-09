//
//  Event.h
//  CoreDataAppleDemo
//
//  Created by wsh on 7/3/13.
//  Copyright (c) 2013 wsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate *creationDate;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSNumber *latitude;

@end
