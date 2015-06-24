//
//  WelcomeViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 06/04/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

#import "WelcomeViewController.h"
#import "SWRevealViewController.h"

NSString *userID;
NSManagedObjectID *moID;

@interface WelcomeViewController ()
@end

@implementation WelcomeViewController

@synthesize orgName, orgType, userData;

- (void)viewDidLoad {
	NSLog(@"WelcomeViewController loaded.");
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	userData = (UserData *)[self.managedObjectContext
							existingObjectWithID:moID
							error:nil];
	userID = userData.id_user;
	[[self navigationController] setNavigationBarHidden:YES animated:YES];
	//[self performSegueWithIdentifier: @"segueToDashboard" sender: self];
}
- (IBAction)startButton:(id)sender {
	[self addOrg];
	[self Login];
//	[self performSegueWithIdentifier:@"pushToDashboard" sender:self];
	
	SWRevealViewController *rmvc = (SWRevealViewController *)[[self revealViewController] rearViewController];
	[rmvc performSegueWithIdentifier:@"segueToProjects" sender:rmvc];
//	[rmvc performSegueWithIdentifier:@"segueToOrganisationProfile" sender:rmvc];
	
//	SWRevealViewController *rmvc = (SWRevealViewController *)[[self revealViewController] rearViewController];
//	[rmvc performSegueWithIdentifier:@"segueToDashboard" sender:rmvc];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//	if([segue.identifier isEqualToString:@"pushToDashboard"]){
//		WelcomeViewController *sendTo = segue.destinationViewController;
//	}
//}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void) addOrg {
	//We begin by creating our POST's body as an NSString, and converting it to NSData.
//	NSLog(@"orgName = %@, orgType = %@, userID = %@", orgName, orgType, userID);
	NSString *post = [NSString stringWithFormat:@"org_Name=%@&org_Type=%@&org_Desc&user_id=%@",orgName, orgType, userID];
	
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	//Next up, we read the postData's length, so we can pass it along in the request.
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	
	//Now that we have what we'd like to post, we can create an NSMutableURLRequest, and include our postData
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/mobile/new/org"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	
	//Request
	NSURLResponse *requestResponse;
	NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
	
	NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
	
	NSLog(@"request: %@", requestReply);
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
		SWRevealViewControllerSegue* rvcs = (SWRevealViewControllerSegue*) segue;
		SWRevealViewController* rvc = self.revealViewController;
		
		NSAssert( rvc != nil, @"oops! must have a revealViewController");
		NSAssert( [rvc.frontViewController isKindOfClass: [UINavigationController class]], @"oops! for this segue we want a permanent navigation controller in the front!");
		
		rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
			UINavigationController* nc = (UINavigationController*)rvc.frontViewController;
			
			[nc setViewControllers: @[ dvc ] animated: NO];
			
			[rvc setFrontViewPosition: FrontViewPositionLeft animated: YES];
		};
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

- (void) setupFetchedResultsController {
	// 1 - Decide what Entity you want
	NSString *entityName = @"UserData"; // Put your entity name here
	NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
 
	// 2 - Request that Entity
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
 
	// 3 - Sort it if you want
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

- (void) Login {
	//	cell.textLabel.text = use.name;
	
	//We begin by creating our POST's body (ergo. what we'd like to send) as an NSString, and converting it to NSData.
	NSString *post = [NSString stringWithFormat:@"username=%@&pass=%@", _user, _pass];
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
		
		userData.email = _user;
		userData.id_user = id_user;
		userData.last_name = last_name;
		userData.first_name = first_name;
		userData.points = [NSNumber numberWithFloat:points];
		
		[self.managedObjectContext save:nil];
		
		//		[[userData objectID] URIRepresentation];
		//		NSManagedObjectID* moid = [storeCoordinator managedObjectIDForURIRepresentation:[[userData objectID] URIRepresentation]];
		
		NSLog(@"[Welcome]_userData: %@", userData);
		NSLog(@"viewDidLoad: moID: %@", moID);
		//		NSManagedObjectID *moID = [userData objectID];
		//		NSLog(@"moID: %@", moID);
		
		
		//		NSLog(@"userData: %@", userData);
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
