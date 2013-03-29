//
//  JLPDetailViewController.h
//  Notes
//
//  Created by Josh Pearlstein on 3/9/13.
//  Copyright (c) 2013 Josh Pearlstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "JLPNotes.h"
@interface JLPDetailViewController : UIViewController<CLLocationManagerDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *title;
@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) IBOutlet UITextView *note;
@property (strong,nonatomic) CLLocation *location;
@property (nonatomic,retain) NSString *noteToSet;
@property (nonatomic, retain) NSString *titleToSet;
@property (nonatomic,retain) CLLocation *locationToSet;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property NSInteger *savePushed;
@property (strong, nonatomic) IBOutlet UIImageView *background;

- (IBAction)saveButtonPushed:(id)sender;
-(void) setNoteText:(NSString *)oldNote;
-(void) setTitleText:(NSString *)oldTitle;
-(void) setLocation:(CLLocation *)oldLocation;

@end
