//
//  RootViewController.m
//  CoreDataAppleDemo
//
//  Created by wsh on 7/3/13.
//  Copyright (c) 2013 wsh. All rights reserved.
//

#import "RootViewController.h"
#import "Event.h"

@implementation RootViewController

@synthesize list = _list, context = _context, locationManager = _locationManager, addButtonItem = _addButtonItem;

#pragma mark - View life cycle
- (void)dealloc
{
    [_list release];
    [_context release];
    [_locationManager release];
    [_addButtonItem release];
    [super dealloc];
}

- (void)viewUnDidLoad
{
    self.list = nil;
    self.context = nil;
    self.locationManager = nil;
    self.addButtonItem = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (systemVersion >= 6.0)
    {
        self.list = nil;
        self.context = nil;
        self.locationManager = nil;
        self.addButtonItem = nil;
        
        self.view = nil;
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Locations";
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    _addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent)];
    _addButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = _addButtonItem;
    
    [self.locationManager startUpdatingLocation];
    
    [self fetchEvents];
}

#pragma mark - Core data event
- (void)addEvent
{
    CLLocation *location = [_locationManager location];
    if (!location)
        return;
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:_context];
    
    event.latitude = [NSNumber numberWithDouble:coordinate.latitude];
    event.longitude = [NSNumber numberWithDouble:coordinate.longitude];
    event.creationDate = [NSDate date];
    
    NSError *error = nil;
    if ([_context save:&error])
    {
        
    }
    
    [_list insertObject:event atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)fetchEvents
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:_context];
    NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:dateSortDescriptor, nil];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    [sortDescriptors release];
    [dateSortDescriptor release];
    
    NSError *error = nil;
    NSMutableArray *events = [[_context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    self.list = events;
    
    [events release];
    [fetchRequest release];
}

- (CLLocationManager *)locationManager
{
    if (_locationManager != nil)
        return _locationManager;
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    
    return _locationManager;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    _addButtonItem.enabled = YES;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    _addButtonItem.enabled = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    }
    
    static NSNumberFormatter *numberFormatter;
    if (!numberFormatter){
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormatter setMaximumFractionDigits:2];
    }
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Event *event = [_list objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dateFormatter stringFromDate:event.creationDate];
    NSString *detailText = [NSString stringWithFormat:@"%@, %@", [numberFormatter stringFromNumber:event.latitude], [numberFormatter stringFromNumber:event.longitude]];
    
    cell.detailTextLabel.text = detailText;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *event = [_list objectAtIndex:indexPath.row];
        [_context deleteObject:event];
        
        [_list removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSError *error = nil;
        if (![_context save:&error])
        {
            
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
