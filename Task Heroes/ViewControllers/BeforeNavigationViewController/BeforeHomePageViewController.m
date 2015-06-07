//
//  BeforeHomePageViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 07/06/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

#import "BeforeHomePageViewController.h"
#import "SingleTaskViewController.h"
#import "DashboardViewController.h"
#import "SWRevealViewController.h"

//BOOL logged;
NSManagedObjectID *moID;

@interface BeforeHomePageViewController ()

@end

@implementation BeforeHomePageViewController

- (void)viewDidLoad {
	NSLog(@"BeforeHomePageViewController loaded.");
    [super viewDidLoad];
	[[self navigationController] setNavigationBarHidden:YES animated:YES];
//	logged = false;
    // Do any additional setup after loading the view.
}

- (void)verifyLogIn{
	_userData = (UserData *)[self.managedObjectContext
							existingObjectWithID:moID
							error:nil];
//	logged = _userData.id_user ?: true;
//	NSLog(@"userID: %@", _userData.id_user);
	if (![_userData.id_user  isEqual: @"0"]) {
		NSLog(@"The user is logged in");
		
		SWRevealViewController *rmvc = (SWRevealViewController *)[[self revealViewController] rearViewController];
		[rmvc performSegueWithIdentifier:@"segueToDashboard" sender:rmvc];
		
//		UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//		DashboardViewController *newRootViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"dashboardViewController"];
//		[[UIApplication sharedApplication].keyWindow  setRootViewController:newRootViewController];
	}
	else
		NSLog(@"The user is logged off");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupFetchedResultsController
{
	// 1 - Entity name
	NSString *entityName = @"UserData";
	NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
 
	// 2 - Request  Entity
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
 
	// 3 - Filter it if you want
	//request.predicate = [NSPredicate predicateWithFormat:@"Role.name = Blah"];
 
	// 4 - Sort it if you want
	request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"first_name"
																					 ascending:YES
																					  selector:@selector(localizedCaseInsensitiveCompare:)]];
	// 5 - Fetch it
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
																		managedObjectContext:self.managedObjectContext
																		  sectionNameKeyPath:nil
																				   cacheName:nil];
	[self performFetch];
}

-(void)performFetch{
	NSManagedObjectContext *moc = [self managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"UserData" inManagedObjectContext:moc];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];
	
 
	NSError *error;
	NSArray *array = [moc executeFetchRequest:request error:&error];
	if (array == nil)
	{
		// Deal with error...
	}
//	NSLog(@"array: %@\n, Conturi: %lu", array, (unsigned long)[array count]);
	
	for (NSManagedObject *managedObject in array) {
		moID = [managedObject objectID];
//		NSLog(@"moID: %@", moID);
	}
}

- (NSManagedObjectContext *)managedObjectContext {
	//	NSLog(@"viewDidLoad: moID: %@", moID);
	
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
