//
//  JLPNotes.h
//  Notes
//
//  Created by Josh Pearlstein on 3/9/13.
//  Copyright (c) 2013 Josh Pearlstein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface JLPNotes : NSObject
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *note;
@property (strong,nonatomic) NSString *longitude;
@property (strong,nonatomic) NSString *latitude;
@end
