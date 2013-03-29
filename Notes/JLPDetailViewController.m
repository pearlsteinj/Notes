//
//  JLPDetailViewController.m
//  Notes
//
//  Created by Josh Pearlstein on 3/9/13.
//  Copyright (c) 2013 Josh Pearlstein. All rights reserved.
//

#import "JLPDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JLPNotes.h"
#import "JLPTableViewController.h"
#import <CoreData/CoreData.h>
#import "JLPAppDelegate.h"
#import "Notes.h"
@interface JLPDetailViewController ()

@end

@implementation JLPDetailViewController
@synthesize note,title,noteToSet,titleToSet,map,locationManager,locationToSet,savePushed,location,background,managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"Here");
    locationManager = [[CLLocationManager alloc]init];
    note.delegate = self;
    title.delegate = self;
    savePushed = 0;
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Enable Location!"
                                                       message:@"Please Enable Location Services in Settings to continue."
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"OK!", nil];
        [alert show];
        
    }
    NSLog(@"(%f,%f)",locationToSet.coordinate.longitude,locationToSet.coordinate.latitude);
    locationManager.distanceFilter = 10;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.delegate = self;
    JLPAppDelegate *appDelegate = (JLPAppDelegate *)[[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    NSLog(@"Starting to monitor location");
    [title setText:titleToSet];
    self.navigationItem.title = titleToSet;
    [note setText:noteToSet];
    if(locationToSet != nil){
        MKPointAnnotation *pin = [[MKPointAnnotation alloc]init];
        pin.coordinate = locationToSet.coordinate;
        [self.map addAnnotation:pin];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(locationToSet.coordinate, 1000, 1000);
        [map setRegion:region animated:YES];
    }
    else{
        self.navigationItem.title = @"New Note";
    [locationManager startMonitoringSignificantLocationChanges];
    }
    [locationManager startMonitoringSignificantLocationChanges];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    location = newLocation;
    NSLog(@"%@",newLocation);
    MKPointAnnotation *pin = [[MKPointAnnotation alloc]init];
    pin.coordinate = newLocation.coordinate;
    pin.title = @"My Location";
    [self.map addAnnotation:pin];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1000, 1000);
    [map setRegion:region animated:YES];
    [map selectAnnotation:pin animated:YES];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"could not get location");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    if(savePushed==0){
        NSLog(@"Here");
        if (!([titleToSet isEqualToString:@"Insert Title"] &&
              [noteToSet isEqualToString:@"Type your note here..."])) {
            NSManagedObjectContext *context = [self managedObjectContext];
            Notes *newNote = [NSEntityDescription
                                               insertNewObjectForEntityForName:@"Notes"
                                               inManagedObjectContext:context];
            newNote.title = titleToSet;
            newNote.note = noteToSet;
            NSString *longitude = [NSString stringWithFormat:@"%f",locationToSet.coordinate.longitude];
            NSString *latitude = [NSString stringWithFormat:@"%f",locationToSet.coordinate.latitude];
            newNote.longitude =longitude;
            newNote.latitude = latitude;
            NSError *error;
            if (![context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }

        }
        [locationManager stopUpdatingLocation];
            
}
            }
- (IBAction)saveButtonPushed:(id)sender {
    savePushed = 1;
    NSManagedObjectContext *context = [self managedObjectContext];
    Notes *newNote = [NSEntityDescription
                                insertNewObjectForEntityForName:@"Notes"
                                inManagedObjectContext:context];
    newNote.title = title.text;
    newNote.note = note.text;
    
    CLLocation *loc = [self location];
    NSString *longitude = [NSString stringWithFormat:@"%f",loc.coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%f",loc.coordinate.latitude];
    NSLog(@"(%@,%@)",longitude,latitude);
    newNote.longitude = longitude;
    newNote.latitude = latitude;
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) setNoteText:(NSString *)oldNote {
    self.noteToSet = oldNote;

}
-(void) setTitleText:(NSString *)oldTitle {

    self.titleToSet = oldTitle;
}

-(void) setLocation:(CLLocation *)oldLocation{
    locationToSet = [[CLLocation alloc] init];
    self.locationToSet = oldLocation;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    NSLog(@"%@",text);
    
    return YES;
}

@end

