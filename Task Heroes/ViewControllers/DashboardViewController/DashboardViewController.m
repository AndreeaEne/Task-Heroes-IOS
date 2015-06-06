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
//#import <CoreData/CoreData.h>

float points;
NSString *id_user;
NSDictionary *responseFromServer;
NSMutableArray *task_name, *iVolunteer;
NSMutableDictionary *doneTasks;
NSManagedObjectID *moID;

NSArray *keyArray, *valueArray;

@interface DashboardViewController ()

@end

@implementation DashboardViewController

@synthesize scrollView;
@synthesize pageControl;
@synthesize imageArray;
@synthesize userData;

@synthesize fetchedResultsController;
@synthesize managedObjectContext;

//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    SWRevealViewController *sideBar = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
//
//
//    [self.navigationController pushViewController:sideBar animated:YES];
//    SWRevealViewController *revealController = self.revealViewController;
//    [revealController.view addGestureRecognizer:revealController.panGestureRecognizer];
//
//    // Do any additional setup after loading the view.
//     //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//
//     [self.tableView setContentSize:CGSizeMake(self.tableView.frame.size.width, 150 + 6 * 50)];
//}


- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self getPoints];
	[self getData];
	//	[self printCoreData];
}

- (void) getPoints {
	//	// Fetching
	//	NSManagedObjectContext *context = [self managedObjectContext];
	//	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserData"];
	//
	//	// Execute Fetch Request
	//	NSError *fetchError = nil;
	//	NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
	//	if (!fetchError) {
	//		for (NSManagedObject *managedObject in result) {
	//			NSString *auxPoints = [managedObject valueForKey:@"points"];
	//			id_user = [managedObject valueForKey:@"id_user"];
	//			points = [auxPoints floatValue];
	//		}
	//
	//	} else {
	//		NSLog(@"Error fetching data.");
	//		NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
	//	}
	//	NSError *error;
	//	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	//	if (fetchedObjects == nil) {
	//		// Handle the error.
	//	}
	userData = (UserData *)[self.managedObjectContext
							existingObjectWithID:moID
							error:nil];
	id_user = userData.id_user;
	points = [userData.points floatValue];
	
	_points.text = [NSString stringWithFormat: @"You have %.2f points", points];
	
//		self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:14.0f/255.0f green:108.0f/255.0f blue:164.0f/255.0f alpha:1.0f];
	//#5BBD72
	self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:91.0f/255.0f green:189.0f/255.0f blue:114.0f/255.0f alpha:1.0f];
	
	self.navigationController.navigationBar.translucent = NO;
	
//	_wallImage.image = [UIImage imageNamed:@"wallpaper2.jpg"];
	
//	self.dataTest = @[@"Data1", @"Data2", @"Data3", @"Data4", @"Data5"];
//	NSArray *titles = @[@"Backlog", @"Waiting", @"Doing", @"Done"];
	
	SWRevealViewController *revealController = [self revealViewController];
	
	[revealController panGestureRecognizer];
	[revealController tapGestureRecognizer];
	
	UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
																		 style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
	
	self.navigationItem.leftBarButtonItem = revealButtonItem;
		[[[self navigationItem] leftBarButtonItem] setTintColor:[UIColor whiteColor]];
	
	//Scroll Section
//	imageArray = [[NSArray alloc] initWithObjects:@"graySection.png", @"graySection.png", @"graySection.png", @"graySection.png", nil];
//	
//	for (int i = 0; i < [imageArray count]; i++) {
//		//We'll create an imageView object in every 'page' of our scrollView.
//		CGRect frame;
//		frame.origin.x = self.scrollView.frame.size.width * i;
//		frame.origin.y = 0;
//		frame.size = self.scrollView.frame.size;
//		
//		UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
//		imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
//		
//		UILabel *taskSection = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 90, frame.origin.y, 97, 21)];
//		[taskSection setText:[NSString stringWithFormat:@"%@",[titles objectAtIndex:i]]];
//		
//		[self.scrollView addSubview:imageView];
//		[self.scrollView addSubview:taskSection];
//		
//	}
//	//	Set the content size of our scrollview according to the total width of our imageView objects.
//	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [imageArray count], scrollView.frame.size.height);
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [task_name count];
	
}

-(UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];
	
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
	}
	
	cell.textLabel.text = task_name[indexPath.row];
	
	return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
	// Update the page when more than 50% of the previous/next page is visible
	CGFloat pageWidth = self.scrollView.frame.size.width;
	int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	self.pageControl.currentPage = page;
}

- (IBAction)quitButton:(id)sender {
	//show confirmation message to user
	NSLog(@"quit button pressed");
	
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Confirmation"
													message:@"Do you want to Log Out?"
												   delegate:self
										  cancelButtonTitle:@"Cancel"
										  otherButtonTitles:@"OK", nil];
	[alert show];
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"alertView called");
	
	if (buttonIndex != 0)  // 0 == the cancel button
	{
		//		[self.navigationController popToRootViewControllerAnimated:YES];
		
		[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
		//
		//		HomeViewController *vc = [HomeViewController alloc];
		//		vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Home View Controller"];
		//		[self.navigationController popToViewController:vc animated:YES];
		
		//		FirstPageViewController *controller = [[FirstPageViewController alloc] initWithNibName:@"First Page View Controller" bundle:nil];
		//		[self.navigationController pushViewController:controller animated:YES];
		
		
		
		//UINavigationController *nav = self.navigationController;
		//[nav pushViewController:UINavigationControllerOperationNone animated:YES];
	}
}

- (void) getData {
	doneTasks = [[NSMutableDictionary alloc] init];
	
	NSError *fetchError = nil;
	
	//We begin by creating our POST's body as an NSString, and converting it to NSData.
	NSString *post = [NSString stringWithFormat:@"_id=%@", id_user];
	NSLog(@"iduser: %@", id_user);
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	//Next up, we read the postData's length, so we can pass it along in the request.
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	
	//Now that we have what we'd like to post, we can create an NSMutableURLRequest, and include our postData
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/get/undonetasks"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSError *jsonParsingError = nil;
	responseFromServer = [NSJSONSerialization JSONObjectWithData:response
														 options:0 error:&jsonParsingError];
	NSLog(@"Response: %@", responseFromServer);
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
		//		NSLog(@"taskName: %@", task_name);
	}
	NSLog(@"iVolunteer: %@", iVolunteer);
	NSLog(@"doneTasks: %@", doneTasks);
	NSMutableArray *undoneTasks = [NSMutableArray arrayWithArray:iVolunteer];
	
	for (NSString* item in iVolunteer)
		for (NSString *itemDone in [doneTasks allValues])
			if ([item isEqual:itemDone]){
				[undoneTasks removeObject:item];
			}
	//	NSLog(@"undoneTasks: %@", undoneTasks);
	
	
	//	//	 Save to Core Data
	//	//	 Create a new managed object
	//	NSLog(@"Save to Core Data...");
	//	NSManagedObjectContext *context = [self managedObjectContext];
	//	NSManagedObject *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"UserData" inManagedObjectContext:context];
	//
	NSArray *auxUndone = [undoneTasks copy];
	NSLog(@"auxUndone: %@", auxUndone);
	NSString *undoneString = [auxUndone componentsJoinedByString:@","];
	
	NSArray *auxDone = [[doneTasks allValues] copy];
	NSLog(@"auxDone: %@", auxDone);
	NSString *doneString = [auxDone componentsJoinedByString:@"m,"];
	//
	//	[newUser setValue:doneString forKey:@"doneTasks"];
	//	[newUser setValue:undoneString forKey:@"undoneTasks"];
	
	// Save to Core Data [with objects]
	//	userData = [NSEntityDescription insertNewObjectForEntityForName:@"UserData" inManagedObjectContext:self.managedObjectContext];
	userData = (UserData *)[self.managedObjectContext
							existingObjectWithID:moID
							error:nil];
	userData.doneTasks = doneString;
	userData.undoneTasks = undoneString;
	
	[self.managedObjectContext save:nil];
	NSLog(@"[Dahboard] UserData: %@", userData.doneTasks);
	
}

- (void) performFetch {
	//	// Fetching
	//	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserData"];
	//	// Add Sort Descriptor
	//	//NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"email" ascending:YES];
	//	//[fetchRequest setSortDescriptors:@[sortDescriptor]];
	//
	//	// Execute Fetch Request
	//	NSManagedObjectContext *context = [self managedObjectContext];
	//	NSError *fetchError = nil;
	//	NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
	//
	//	if (!fetchError) {
	//		for (NSManagedObject *managedObject in result) {
	//			NSString *done = [managedObject valueForKey:@"doneTasks"];
	//			NSString *undone = [managedObject valueForKey:@"undoneTasks"];
	//
	//			NSLog(@"User_id: %@ Done: %@,\nUndone:%@,", [managedObject valueForKey:@"id_user"], done, undone);
	//			break;
	//		}
	//
	//	} else {
	//		NSLog(@"Error fetching data.");
	//		NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
	//	}
	//
	//	NSError *error;
	//	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	//	if (fetchedObjects == nil) {
	//		// Handle the error.
	//	}
	
	//	// Print from Core Data
	//	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserData"];
	//	NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
	//
	//	if (!fetchError) {
	//		for (NSManagedObject *managedObject in result) {
	//			NSLog(@"se apeleaza");
	//			NSLog(@"done: %@, \nundone: %@", [managedObject valueForKey:@"doneTasks"], [managedObject valueForKey:@"undoneTasks"]);
	//		}
	//	} else {
	//		NSLog(@"Error fetching data.");
	//		NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
	//	}
	//	NSError *error;
	//	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	//	if (fetchedObjects == nil) {
	//		// Handle the error.
	//	}
	
	//	NSLog(@"userData: %@", userData);
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
	NSLog(@"array: %@\n, Conturi: %lu", array, (unsigned long)[array count]);for (NSManagedObject *managedObject in array) {
		moID = [managedObject objectID];
		NSLog(@"moID: %@", moID);
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
	NSString *entityName = @"UserData"; // Put your entity name here
	NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
 
	// 2 - Request that Entity
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

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL) animated {
	[super viewWillAppear:animated];
	[self setupFetchedResultsController];
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
