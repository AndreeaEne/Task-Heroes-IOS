//
//  WelcomeViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 06/04/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

/** Welcome page that shows after signing up. **/

#import "WelcomeViewController.h"
#import "SWRevealViewController.h"

NSString *userID;			// ID of the current user.
NSManagedObjectID *moID;	// ID of the current object.

@interface WelcomeViewController ()
@end

@implementation WelcomeViewController

@synthesize orgName, orgType, userData;

- (void)viewDidLoad {
	NSLog(@"WelcomeViewController loaded.");
	[super viewDidLoad];

	// Get info about the user from CoreData.
	userData = (UserData *)[self.managedObjectContext
							existingObjectWithID:moID
							error:nil];
	userID = userData.id_user;
	
	// Hide the NavigationBar.
	[[self navigationController] setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Start Button.
- (IBAction)startButton:(id)sender {
	[self addOrg];
	[self Login];
	
	SWRevealViewController *rmvc = (SWRevealViewController *)[[self revealViewController] rearViewController];
	[rmvc performSegueWithIdentifier:@"segueToProjects" sender:rmvc];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

// Add an organisation for your user and send it to the server.
- (void) addOrg {
	// The information needed in the name, description and userID.
	NSString *post = [NSString stringWithFormat:@"org_Name=%@&org_Type=%@&org_Desc&user_id=%@",orgName, orgType, userID];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/mobile/new/org"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	
	NSURLResponse *requestResponse;
	NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
	
	NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
	
	NSLog(@"Request from server: %@", requestReply);
}

#pragma mark - Segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
		SWRevealViewControllerSegue* rvcs = (SWRevealViewControllerSegue*) segue;
		SWRevealViewController* rvc = self.revealViewController;
		
		NSAssert( rvc != nil, @"Must have a revealViewController!");
		NSAssert( [rvc.frontViewController isKindOfClass: [UINavigationController class]], @"For this segue we want a permanent navigation controller in the front!");
		
		rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
			UINavigationController* nc = (UINavigationController*)rvc.frontViewController;
			
			[nc setViewControllers: @[ dvc ] animated: NO];
			
			[rvc setFrontViewPosition: FrontViewPositionLeft animated: YES];
		};
	}
}


#pragma mark - CoreData
- (NSManagedObjectContext *)managedObjectContext {
	NSManagedObjectContext *context = nil;
	id delegate = [[UIApplication sharedApplication] delegate];
	if ([delegate performSelector:@selector(managedObjectContext)]) {
		context = [delegate managedObjectContext];
	}
	return context;
}

- (void) setupFetchedResultsController {
	NSString *entityName = @"UserData";
	NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
																		managedObjectContext:self.managedObjectContext
																		  sectionNameKeyPath:nil
																				   cacheName:nil];
	[self performFetch];
}

- (void) Login {
	// Create POST's body as an NSString, and convert it to NSData.
	NSString *post = [NSString stringWithFormat:@"username=%@&pass=%@", _user, _pass];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	// Read the postData's length, so it can passed along in the request.
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	
	// Create an NSMutableURLRequest, and include the postData.
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/login/user"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	
	// Send the request, and read the reply.
	NSURLResponse *requestResponse;
	NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
	
	NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
	
	// Check if the id exists.
	if ([requestReply rangeOfString:@"_id"].location != NSNotFound) {
		NSArray *components = [requestReply componentsSeparatedByString:@","];
		NSLog(@"%@",components);
		
		//Save data about User
		NSString* id_user = [[[[requestReply componentsSeparatedByString:@"_id\":\""]objectAtIndex:1] componentsSeparatedByString:@"\""]objectAtIndex:0];
		NSString *last_name = [[[[requestReply componentsSeparatedByString:@"last_name\":\""]objectAtIndex:1] componentsSeparatedByString:@"\""]objectAtIndex:0];
		NSString *first_name = [[[[requestReply componentsSeparatedByString:@"first_name\":\""]objectAtIndex:1] componentsSeparatedByString:@"\""]objectAtIndex:0];
		// NSString *email = [[[[requestReply componentsSeparatedByString:@"email\":\""]objectAtIndex:1] componentsSeparatedByString:@"\""]objectAtIndex:0];
		NSString *auxPoints = [[[[requestReply componentsSeparatedByString:@"points\":"]objectAtIndex:1] componentsSeparatedByString:@"\""]objectAtIndex:0];
		float points = [auxPoints floatValue];
		// NSLog(@"\n ID: %@ \n lastname: %@ \n firstname: %@ \n email: %@\n points: %f",id_user, last_name, first_name, email, points);
		
		userData = (UserData *)[self.managedObjectContext
								existingObjectWithID:moID
								error:nil];
		
		userData.email = _user;
		userData.id_user = id_user;
		userData.last_name = last_name;
		userData.first_name = first_name;
		userData.points = [NSNumber numberWithFloat:points];
		
		[self.managedObjectContext save:nil];
	}
}

-(void) performFetch {
	NSManagedObjectContext *moc = [self managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"UserData" inManagedObjectContext:moc];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];
	NSError *error;
	NSArray *array = [moc executeFetchRequest:request error:&error];
	for (NSManagedObject *managedObject in array) {
		moID = [managedObject objectID];
		NSLog(@"moID: %@", moID);
	}
}

@end
