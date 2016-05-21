//
//  BeforeHomePageViewController.h
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 07/06/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "UserData.h"

@interface BeforeHomePageViewController : UINavigationController

	// CoreData.
	@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
	@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
	@property (strong, nonatomic) UserData *userData;

@end
