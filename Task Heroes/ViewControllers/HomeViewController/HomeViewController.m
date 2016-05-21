//
//  HomeViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 17/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import "HomeViewController.h"
#import "Globals.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "UserData.h"
#import "SWRevealViewController.h"

/** This view contains login page where the user has to insert the name and the password. **/

BOOL semafor = false;		// For checking if already exists any user.
NSManagedObjectID *moID;	// ID of the current object.

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize emailField, loginButton, passField;
@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize userData;


- (void)viewDidLoad {
	NSLog(@"HomeViewController loaded.");
	[super viewDidLoad];

	[[self navigationController] setNavigationBarHidden:NO animated:YES];
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	
	moID = [[NSManagedObjectID alloc] init];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

// Hide Keyboard.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	//    NSLog(@"Hide keyboard");
	[self.view endEditing:YES];
	[super touchesBegan:touches withEvent:event];
}

// Set the login button.
- (IBAction)loginButton:(id)sender {
	NSString *msg;
	BOOL email = [emailField.text length] > 0;
	BOOL pass = [passField.text length] > 0;

	if (!email && !pass) {
		msg = @"Enter a valid email and password.";
	}
	else if (!email) {
		msg = @"Enter a valid email address.";
	}
	else if (!pass) {
		msg = @"Enter a password. ";
	}
	else if([self Login] == true) {
			[self performSegueWithIdentifier: @"LogIn" sender: self];
	}
	else msg = @"User or password incorrect";
	
	if ([msg length] > 0 ) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alert show];
	}
}

// Login by sending a request to the server.
- (BOOL) Login {
	// Create POST's body as an NSString, and convert it to NSData.
	NSString *post = [NSString stringWithFormat:@"username=%@&pass=%@", emailField.text, passField.text];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	// Read the postData's length, so it can be passed along in the request.
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	
	// Create an NSMutableURLRequest, and include our postData.
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/login/user"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	
	//Send the request, and read the reply.
	NSURLResponse *requestResponse;
	NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
	
	NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
	
	// Check if the user/pass exists.
	if ([requestReply rangeOfString:@"_id"].location != NSNotFound) {
		semafor = true;
	}
	
	if (semafor == true) {
		NSArray *components = [requestReply componentsSeparatedByString:@","];
		NSLog(@"%@",components);
		
		// Save data about User.
		NSString* id_user = [[[[requestReply componentsSeparatedByString:@"_id\":\""]objectAtIndex:1] componentsSeparatedByString:@"\""]objectAtIndex:0];
		NSString *last_name = [[[[requestReply componentsSeparatedByString:@"last_name\":\""]objectAtIndex:1] componentsSeparatedByString:@"\""]objectAtIndex:0];
		NSString *first_name = [[[[requestReply componentsSeparatedByString:@"first_name\":\""]objectAtIndex:1] componentsSeparatedByString:@"\""]objectAtIndex:0];
		NSString *email = [[[[requestReply componentsSeparatedByString:@"email\":\""]objectAtIndex:1] componentsSeparatedByString:@"\""]objectAtIndex:0];
		NSString *auxPoints = [[[[requestReply componentsSeparatedByString:@"points\":"]objectAtIndex:1] componentsSeparatedByString:@"\""]objectAtIndex:0];
		float points = [auxPoints floatValue];
		
		NSLog(@"\n ID: %@ \n lastname: %@ \n firstname: %@ \n email: %@\n points: %f",id_user, last_name, first_name, email, points);
		
		userData = (UserData *)[self.managedObjectContext
								existingObjectWithID:moID
								error:nil];
		
		userData.email = emailField.text;
		userData.id_user = id_user;
		userData.last_name = last_name;
		userData.first_name = first_name;
		userData.points = [NSNumber numberWithFloat:points];
		
		[self.managedObjectContext save:nil];
		
		NSLog(@"[Home]_userData: %@", userData);
		NSLog(@"viewDidLoad: moID: %@", moID);
	}
	return semafor;
}

#pragma mark - CoreData.
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
	if([array count] == 0) {
		NSLog(@"Adding new account.");
		userData = [NSEntityDescription insertNewObjectForEntityForName:@"UserData" inManagedObjectContext:self.managedObjectContext];
		userData.email = @"a";
		[self.managedObjectContext save:nil];
	}
	for (NSManagedObject *managedObject in array) {
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
	// 1 - Decide what Entity you want.
	NSString *entityName = @"UserData";
 
	// 2 - Request that Entity.
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];

	// 3 - Sort it if you want.
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

- (void) viewWillAppear:(BOOL) animated {
	[super viewWillAppear:animated];
	[self setupFetchedResultsController];
	semafor = false;
}

#pragma mark - Segue.
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
		SWRevealViewControllerSegue* rvcs = (SWRevealViewControllerSegue*) segue;
		SWRevealViewController* rvc = self.revealViewController;
		
		NSAssert( rvc != nil, @"Must have a revealViewController");
		NSAssert( [rvc.frontViewController isKindOfClass: [UINavigationController class]], @"For this segue we want a permanent navigation controller in the front!");
		
		rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
			UINavigationController* nc = (UINavigationController*)rvc.frontViewController;
			
			[nc setViewControllers: @[ dvc ] animated: NO];
			
			[rvc setFrontViewPosition: FrontViewPositionLeft animated: YES];
		};
	}
}

@end
