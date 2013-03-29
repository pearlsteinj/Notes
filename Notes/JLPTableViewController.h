//
//  JLPTableViewController.h
//  Notes
//
//  Created by Josh Pearlstein on 3/9/13.
//  Copyright (c) 2013 Josh Pearlstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLPNotes.h"
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
@interface JLPTableViewController : UITableViewController<NSFetchedResultsControllerDelegate>
@property (nonatomic,retain) NSMutableArray *notes;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
-(void)addNote:(JLPNotes *)note;

@end
