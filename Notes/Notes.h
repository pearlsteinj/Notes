//
//  Notes.h
//  Notes
//
//  Created by Josh Pearlstein on 3/29/13.
//  Copyright (c) 2013 Josh Pearlstein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Notes : NSManagedObject

@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * title;

@end
