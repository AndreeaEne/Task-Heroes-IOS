//
//  BeforeHomePageViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 07/06/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

/** This view checks if the user logged in already. **/

#import "BeforeHomePageViewController.h"
#import "SingleTaskViewController.h"
#import "DashboardViewController.h"
#import "SWRevealViewController.h"

/* 
  First method to check if the ID of the current user is the same as the one saved in CoreData:
  use a bool variable that is true if the ID of the current user is the same ad the one in CoreData,
  and false if it is different.
 
BOOL logged;
*/

NSManagedObjectID *moID;	// ID of the current object.

@interface BeforeHomePageViewController ()

@end

@implementation BeforeHomePageViewController

- (void)viewDidLoad {
	NSLog(@"BeforeHomePageViewController loaded.");
    [super viewDidLoad];
	[[self navigationController] setNavigationBarHidden:YES animated:YES];
	// logged = false;
}

- (void)verifyLogIn{
	/*
	 Set the logged variable to *true* if it is the same as the one saved in CoreData.
	
	logged = _userData.id_user ?: true; NSLog(@"userID: %@", _userData.id_user);
	 */
	
	/* 
	 In the second method there is only one user saved in CoreData.
	 Every time the user logs out, the ID changes to the value 0.
	*/
	if (![_userData.id_user isEqual: @"0"]) {
		// If the user logged in already (the ID is not 0), go directly to the Dashboard controller.
		NSLog(@"The user is logged in");
		SWRevealViewController *rmvc = (SWRevealViewController *)[[self revealViewController] rearViewController];
		[rmvc performSegueWithIdentifier:@"segueToDashboard" sender:rmvc];
	}
	else
		NSLog(@"The user is logged out");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CoreData.
- (void)setupFetchedResultsController
{
	// 1 - Entity name
	NSString *entityName = @"UserData";
 
	// 2 - Request Entity
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
 
 
	// 3 - Sort it by first_name
	request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"first_name"
																					 ascending:YES
																					  selector:@selector(localizedCaseInsensitiveCompare:)]];
	// 4 - Fetch it
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
																		managedObjectContext:self.managedObjectContext
																		  sectionNameKeyPath:nil
																				   cacheName:nil];
	[self performFetch];
}

- (void)performFetch {
	NSManagedObjectContext *moc = [self managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"UserData" inManagedObjectContext:moc];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];
	
 
	NSError *error;
	NSArray *array = [moc executeFetchRequest:request error:&error];
	if (array == nil)
	{
		//TODO: Deal with error.
	}
	
	/* 
	 Shows the number of accounts. This is not used anymore because only one account is saved in CoreData.
	 
	 NSLog(@"array: %@\n, Number of accounts: %lu", array, (unsigned long)[array count]);
	*/
	for (NSManagedObject *managedObject in array) {
		moID = [managedObject objectID];
		// NSLog(@"moID: %@", moID);
	}
}

- (NSManagedObjectContext *)managedObjectContext {
	NSManagedObjectContext *context = nil;
	id delegate = [[UIApplication sharedApplication] delegate];
	if ([delegate performSelector:@selector(managedObjectContext)]) {
		context = [delegate managedObjectContext];
	}
	return context;
}

- (void) viewWillAppear:(BOOL) animated {
	[super viewWillAppear:animated];
	[self setupFetchedResultsController];
	[self verifyLogIn];
}


@end
