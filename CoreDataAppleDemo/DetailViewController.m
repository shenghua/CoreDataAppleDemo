//
//  DetailViewController.m
//  CoreDataAppleDemo
//
//  Created by wsh on 7/3/13.
//  Copyright (c) 2013 wsh. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

@synthesize array = _array;

- (void)dealloc
{
    [_array release];
    [super dealloc];
}

- (void)setArray:(NSArray *)array
{
     NSLog(@"array1");
}

- (NSArray *)array
{
    NSLog(@"array");
    return _array;
}

- (void)viewDidUnload
{
    _array = nil;
    self.array = nil;
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(back)];
}

- (void)back
{
    _array = nil;
    self.array = nil;
    NSLog(@"%@", self.array);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
