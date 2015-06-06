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

BOOL semafor = false;
NSManagedObjectID *moID;

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize emailField, loginButton, passField;
@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize userData;


- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	[[self navigationController] setNavigationBarHidden:NO animated:YES];
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	//	[self performSegueWithIdentifier: @"LogIn" sender: self];
	moID = [[NSManagedObjectID alloc] init];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

//Hide Keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	//    NSLog(@"Hide keyboard");
	[self.view endEditing:YES];
	[super touchesBegan:touches withEvent:event];
}

- (IBAction)loginButton:(id)sender {
	NSString *msg;
	//BOOL email = [Globals validateEmail:[emailField text]];
	BOOL email = [emailField.text length] > 0;
	BOOL pass = [passField.text length] > 0;
	
//	[self performSegueWithIdentifier: @"LogIn" sender: self];
	
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

- (BOOL) Login {
	//	cell.textLabel.text = use.name;
	
	//We begin by creating our POST's body (ergo. what we'd like to send) as an NSString, and converting it to NSData.
	NSString *post = [NSString stringWithFormat:@"username=%@&pass=%@", emailField.text, passField.text];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	//Next up, we read the postData's length, so we can pass it along in the request.
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	
	//Now that we have what we'd like to post, we can create an NSMutableURLRequest, and include our postData
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/login/user"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	
	//Send the request, and read the reply:
	NSURLResponse *requestResponse;
	NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
	
	NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
	//requestReply = [NSString stringWithFormat:@"msg"];
	
	//Check if the user/pass exists
	if ([requestReply rangeOfString:@"_id"].location != NSNotFound) {
		semafor = true;
	}
	
	if (semafor == true) {
		NSArray *components = [requestReply componentsSeparatedByString:@","];
		NSLog(@"%@",components);
		
		//Save data about User
		NSString* id_user = [[[[requestReply componentsSeparatedByString:@"_id\":\""]objectAtIndex:1] componentsSeparatedByString:@"\""]objectAtIndex:0];
		NSString *last_name = [[[[requestReply componentsSeparatedByString:@"last_name\":\""]objectAtIndex:1] componentsSeparatedByString:@"\""]objectAtIndex:0];
		NSString *first_name = [[[[requestReply componentsSeparatedByString:@"first_name\":\""]objectAtIndex:1] componentsSeparatedByString:@"\""]objectAtIndex:0];
		NSString *email = [[[[requestReply componentsSeparatedByString:@"email\":\""]objectAtIndex:1] componentsSeparatedByString:@"\""]objectAtIndex:0];
		NSString *auxPoints = [[[[requestReply componentsSeparatedByString:@"points\":"]objectAtIndex:1] componentsSeparatedByString:@"\""]objectAtIndex:0];
		float points = [auxPoints floatValue];
		
		NSLog(@"\n ID: %@ \n lastname: %@ \n firstname: %@ \n email: %@\n points: %f",id_user, last_name, first_name, email, points);
		
		// Save to Core Data
		//		// Create a new managed object
		//		NSManagedObject *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"UserData" inManagedObjectContext:context];
		//		[newUser setValue:id_user forKey:@"id_user"];
		//		[newUser setValue:last_name forKey:@"last_name"];
		//		[newUser setValue:first_name forKey:@"first_name"];
		//		[newUser setValue:email forKey:@"email"];
		//		[newUser setValue:[NSNumber numberWithFloat:points]  forKey:@"points"];
		
		// Save to Core Data [with objects]
		
		
		//		userData = [NSEntityDescription insertNewObjectForEntityForName:@"UserData" inManagedObjectContext:self.managedObjectContext];
		
		//		NSManagedObjectID *moID = [userData objectID];
		//		NSLog(@"userID: %@", moID);
		
		
		userData = (UserData *)[self.managedObjectContext
								existingObjectWithID:moID
								error:nil];
		
		userData.email = emailField.text;
		userData.id_user = id_user;
		userData.last_name = last_name;
		userData.first_name = first_name;
		userData.points = [NSNumber numberWithFloat:points];
		
		[self.managedObjectContext save:nil];
		
		//		[[userData objectID] URIRepresentation];
		//		NSManagedObjectID* moid = [storeCoordinator managedObjectIDForURIRepresentation:[[userData objectID] URIRepresentation]];
		
		NSLog(@"[Home]_userData: %@", userData);
		NSLog(@"viewDidLoad: moID: %@", moID);
		//		NSManagedObjectID *moID = [userData objectID];
		//		NSLog(@"moID: %@", moID);
		
		
		//		NSLog(@"userData: %@", userData);
	}
	return semafor;
}

- (void) performFetch {
	//	NSManagedObjectContext *context = [self managedObjectContext];
	// Fetching
	//	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserData"];
	
	//	// Execute Fetch Request
	//	NSError *fetchError = nil;
	//	NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
	//
	//	if (!fetchError) {
	//		for (NSManagedObject *managedObject in result) {
	//			NSLog(@"[Home] ManagedObject: %@", managedObject);
	//
	//			NSLog(@"%@, %@, %@, %@", [managedObject valueForKey:@"email"], [managedObject valueForKey:@"last_name"], [managedObject valueForKey:@"id_user"], [managedObject valueForKey:@"points"]);
	//		}
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
	//	NSLog(@"email: %@, last_name: %@, id_user: %@, points: %@", _userData.email, _userData.last_name, _userData.id_user, _userData.points);
	//	_userData = [NSEntityDescription insertNewObjectForEntityForName:@"UserData" inManagedObjectContext:context];
	
	//	NSLog(@"[Home][Fetch]userData: %@", userData);
	//	[self.managedObjectContext _userData];
	//	[self.managedObjectContext save:nil];
	
	NSManagedObjectContext *moc = [self managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"UserData" inManagedObjectContext:moc];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];
	
 
	NSError *error;
	NSArray *array = [moc executeFetchRequest:request error:&error];
	if (array == nil) {
		// Deal with error...
	}
	NSLog(@"array: %@\n, Conturi: %lu", array, (unsigned long)[array count]);
	if([array count] == 0) {
		NSLog(@"ajunge?");
		userData = [NSEntityDescription insertNewObjectForEntityForName:@"UserData" inManagedObjectContext:self.managedObjectContext];
		userData.email = @"a";
		[self.managedObjectContext save:nil];
	}
	for (NSManagedObject *managedObject in array) {
		moID = [managedObject objectID];
		NSLog(@"moID: %@", moID);
	}
	
	//	userData = [self managedObjectContext];
	
	
}

- (void) viewWillAppear:(BOOL) animated {
	[super viewWillAppear:animated];
	[self setupFetchedResultsController];
	semafor = false;
}


//-(NSManagedObject *)existingObjectWithID:(NSManagedObjectID *)objectID
//								   error:(NSError **)error {
//	NSManagedObjectID *moID = [userData objectID];
//	NSLog(@"moID: %@", moID);
//
//	userData = (UserData *)[self.managedObjectContext
//									  existingObjectWithID:moID
//									  error:nil];
//
//	return userData;
//
//}
- (NSManagedObjectContext *) managedObjectContext {
	//	NSLog(@"viewDidLoad: moID: %@", moID);
	
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
