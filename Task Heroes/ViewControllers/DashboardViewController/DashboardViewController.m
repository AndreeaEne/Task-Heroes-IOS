//
//  DashboardViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 22/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import "DashboardViewController.h"
#import "SWRevealViewController.h"
#import "FirstPageViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"

/** This view contains the Dashboard with info about the user's activity. **/


NSString *id_user;							// ID of the current user.
NSManagedObjectID *moID;					// ID of the current object.
NSDictionary *responseFromServer;			// All info received from the server.
NSMutableArray *task_name, *iVolunteer;		// Variables to save useful data from the server.
NSMutableDictionary *doneTasks;
float points;

NSArray *keyArray, *valueArray;				// Key and values for the tasks that have been done.

@interface DashboardViewController ()

@end

@implementation DashboardViewController

@synthesize scrollView;
@synthesize pageControl;
@synthesize imageArray;
@synthesize userData;
@synthesize fetchedResultsController;
@synthesize managedObjectContext;

- (void)viewDidLoad {
	NSLog(@"DashboardViewController loaded.");
	[super viewDidLoad];
	
	[self getPoints];
	[self getData];
	[self getTasks];
}

// Show info about the taks that have to be completed.
- (void) getTasks {
	if ([task_name count] == 0) {
		_tasks.text = [NSString stringWithFormat:@"You have completed your tasks"];
		[_tasks setFont:[UIFont systemFontOfSize:15]];
	}
	else if ([task_name count] == 1) {
		_tasks.text = [NSString stringWithFormat:@"1 task"];
	}
	else {
	_tasks.text = [NSString stringWithFormat:@"%lu tasks",(unsigned long)[task_name count]];
	}
}

// Show the number of points that the user has acquired.
- (void) getPoints {
	userData = (UserData *)[self.managedObjectContext
							existingObjectWithID:moID
							error:nil];
	id_user = userData.id_user;
	points = [userData.points floatValue];
	
	if (points == 0) {
		_points.text = [NSString stringWithFormat: @"You don't have any points"];
		[_points setFont:[UIFont systemFontOfSize:15]];
	}
	else if (points == 1) {
		_points.text = [NSString stringWithFormat: @"1 point"];
	}
	else {
		_points.text = [NSString stringWithFormat: @"%.0f points", points];
	}
	
	self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:91.0f/255.0f green:189.0f/255.0f blue:114.0f/255.0f alpha:1.0f];
	
	self.navigationController.navigationBar.translucent = NO;
	
	SWRevealViewController *revealController = [self revealViewController];
	
	[revealController panGestureRecognizer];
	[revealController tapGestureRecognizer];
	
	UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
																		 style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
	self.navigationItem.leftBarButtonItem = revealButtonItem;
		[[[self navigationItem] leftBarButtonItem] setTintColor:[UIColor whiteColor]];
}


#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [task_name count];
}

-(UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];

	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
	}
	
	cell.textLabel.text = task_name[indexPath.row];
	return cell;
}

// Update the tavle after scrolling.
- (void)scrollViewDidScroll:(UIScrollView *)sender {
	// Update the page when more than 50% of the previous/next page is visible.
	CGFloat pageWidth = self.scrollView.frame.size.width;
	int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	self.pageControl.currentPage = page;
}

// Log out and send the ID to 0.
- (IBAction)quitButton:(id)sender {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Confirmation"
													message:@"Do you want to Log Out?"
												   delegate:self
										  cancelButtonTitle:@"Cancel"
										  otherButtonTitles:@"OK", nil];
	[alert show];
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	// Change the ID to 0 in order to avoid auto sign up.
	if (buttonIndex != 0) {
		userData.id_user = @"0";
		[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
	}
}

// Get data from the server about the tasks that are in progress.
- (void) getData {
	doneTasks = [[NSMutableDictionary alloc] init];
	
	NSError *fetchError = nil;
	
	// Create our POST's body as an NSString, and convert it to NSData.
	NSString *post = [NSString stringWithFormat:@"_id=%@", id_user];

	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	//Read the postData's length, so it can passed along in the request.
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	
	// Create an NSMutableURLRequest, and include the postData.
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/get/undonetasks"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSError *jsonParsingError = nil;
	responseFromServer = [NSJSONSerialization JSONObjectWithData:response
														 options:0 error:&jsonParsingError];
	task_name = [[NSMutableArray alloc] init];
	iVolunteer = [[NSMutableArray alloc] init];
	
	if (!responseFromServer) {
		NSLog(@"Error parsing JSON: %@", fetchError);
	}
	else {
		
		for(NSDictionary *item in responseFromServer) {
			//NSLog(@"item: %@ ", item[@"task_name"]);
			[task_name addObject:item[@"task_name"]];
			[iVolunteer addObject:item[@"_id"]];
			if(item[@"done_on_date"])
				[doneTasks setObject:[item objectForKey:@"_id"] forKey:[item objectForKey:@"done_on_date"]];
		}
	}
	NSMutableArray *undoneTasks = [NSMutableArray arrayWithArray:iVolunteer];
	
	for (NSString* item in iVolunteer)
		for (NSString *itemDone in [doneTasks allValues])
			if ([item isEqual:itemDone]){
				[undoneTasks removeObject:item];
			}

	NSArray *auxUndone = [undoneTasks copy];
	NSString *undoneString = [auxUndone componentsJoinedByString:@","];
	NSArray *auxDone = [[doneTasks allValues] copy];
	NSString *doneString = [auxDone componentsJoinedByString:@"m,"];

	userData = (UserData *)[self.managedObjectContext
							existingObjectWithID:moID
							error:nil];
	userData.doneTasks = doneString;
	userData.undoneTasks = undoneString;
	
	[self.managedObjectContext save:nil];
}

#pragma mark - CoreData
- (void) performFetch {
	NSManagedObjectContext *moc = [self managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"UserData" inManagedObjectContext:moc];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];
	
 
	NSError *error;
	NSArray *array = [moc executeFetchRequest:request error:&error];
	if (array == nil) {
		//TODO: Deal with error.
	}
	for (NSManagedObject *managedObject in array) {
		moID = [managedObject objectID];
	}
}

- (NSManagedObjectContext *) managedObjectContext {
	NSManagedObjectContext *context = nil;
	id delegate = [[UIApplication sharedApplication] delegate];
	if ([delegate performSelector:@selector(managedObjectContext)]) {
		context = [delegate managedObjectContext];
	}
	return context;
}

- (void) setupFetchedResultsController
{
	// 1 - Decide what Entity you want
	NSString *entityName = @"UserData";
 
	// 2 - Request that Entity.
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
 
	// 3 - Sort it.
	request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"first_name"
																					 ascending:YES
																					  selector:@selector(localizedCaseInsensitiveCompare:)]];
	// 4 - Fetch it.
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
																		managedObjectContext:self.managedObjectContext
																		  sectionNameKeyPath:nil
																				   cacheName:nil];
	[self performFetch];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL) animated {
	[super viewWillAppear:animated];
	[self setupFetchedResultsController];
}


@end
