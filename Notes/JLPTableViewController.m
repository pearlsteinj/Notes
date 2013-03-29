//
//  JLPTableViewController.m
//  Notes
//
//  Created by Josh Pearlstein on 3/9/13.
//  Copyright (c) 2013 Josh Pearlstein. All rights reserved.
//

#import "JLPTableViewController.h"
#import "JLPDetailViewController.h"
#import "JLPAppDelegate.h"
#define kJLPCellIdentifier @"My Cell Identifier"
#import <CoreData/CoreData.h>
@interface JLPTableViewController ()

@end

@implementation JLPTableViewController
@synthesize notes,managedObjectContext;
NSFetchedResultsController *controller;
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
    notes = [[NSMutableArray alloc]init];
    JLPAppDelegate *appDelegate = (JLPAppDelegate *)[[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Notes" inManagedObjectContext:context];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"title" ascending:YES];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:@[sort]];
    notes = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    [[self tableView] reloadData];

}
-(void)viewWillAppear:(BOOL)animated{
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Notes" inManagedObjectContext:context];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"title" ascending:YES];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:@[sort]];
    notes = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSLog(@"%x",[notes count]);
    
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    
    return [notes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kJLPCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kJLPCellIdentifier];
    }
    
    cell.textLabel.text = [self.notes[indexPath.row] title];
    return cell;
}

#pragma mark - Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"tableSelect"]){
        NSString *title = [self.notes[[self.tableView indexPathForSelectedRow].row] title];
        [segue.destinationViewController setTitleText:title];
        NSString *note = [self.notes[[self.tableView indexPathForSelectedRow].row] note];
        [segue.destinationViewController setNoteText:note];
        NSString *longitude =[self.notes[[self.tableView indexPathForSelectedRow].row] longitude];
        NSString *latitude = [self.notes[[self.tableView indexPathForSelectedRow].row] latitude];
        NSLog(@"(%f,%f)",[longitude doubleValue],[latitude doubleValue]);
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
        [segue.destinationViewController setLocation:location];
        NSFetchRequest *request= [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notes" inManagedObjectContext:managedObjectContext];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(title matches[cd] %@) AND (note matches[cd] %@)",                                                              ([self.notes[[self.tableView indexPathForSelectedRow].row] title]),
            ([self.notes[[self.tableView indexPathForSelectedRow].row] note])];
        [request setEntity:entity];
        [request setPredicate:predicate];
        [request setFetchLimit:1];
        NSError *error;
        NSMutableArray *note1 = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        [managedObjectContext deleteObject:[note1 objectAtIndex:0]];

    }
    else if([segue.identifier isEqualToString:@"newNote"]){
        JLPDetailViewController *controller =(JLPDetailViewController *)segue.destinationViewController;
        [controller setTitleText:@"Insert Title"];
        [controller setNoteText:@"Type your note here..."];
        [controller setLocationToSet:nil];
    }
}


-(void)addNote:(JLPNotes *)note {
    [notes insertObject:note atIndex:0];
}
@end