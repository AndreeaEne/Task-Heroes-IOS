//
//  MembersViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 30/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

/** This view contains the list with all members. **/

#import "MembersViewController.h"
#import "SWRevealViewController.h"
#import "UIViewController+NavigationBar.h"
#import <CoreData/CoreData.h>

NSString *userID;									// ID of the current user.
NSManagedObjectID *moID;							// ID of the current object.
NSMutableArray *membersList, *organisationName;		// Arrays with all organisations and members.

NSMutableDictionary *organisationData;				// Dictionary with organisations and IDs.
NSArray *keyArray, *valueArray;						// Values and keys for organisation data.

@interface MembersViewController ()

@end

@implementation MembersViewController
@synthesize userData;

- (void)viewDidLoad {
	NSLog(@"MembersViewController loaded.");
	[super viewDidLoad];
	
	[self setupNavigationBar];
	
	membersList = [[NSMutableArray alloc] init];
	organisationName = [[NSMutableArray alloc] init];
	organisationData = [[NSMutableDictionary alloc] init];
	keyArray = [[NSArray alloc] init];
	valueArray = [[NSArray alloc] init];
	
	[self setupNavigationBar];
	[self getOrganizations];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - Setup NavigationBar

- (void) setupNavigationBar
{
	[[UIApplication sharedApplication] setStatusBarHidden: NO];
	[self.navigationController setNavigationBarHidden: NO];
	
	[self setTitle:@"Volunteers"];
	[self setRevealButtonWithImage: [UIImage imageNamed:@"reveal-icon.png"]];
}

// Get info about the organizations from the server.
- (void)getOrganizations {
	userID = [[NSString alloc] init];
	userData = (UserData *)[self.managedObjectContext
							existingObjectWithID:moID
							error:nil];
	userID = userData.id_user;
	
	// Create POST's body as an NSString, and convert it to NSData.
	NSString *post = [NSString stringWithFormat:@"user_id=%@", userID];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	// Read the postData's length, so it can be passed along in the request.
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	
	// Create an NSMutableURLRequest, and include the postData.
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/mobile/get/volunteers"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSError *jsonParsingError = nil;
	NSDictionary *responseFromServer = [NSJSONSerialization JSONObjectWithData:response
																	   options:0 error:&jsonParsingError];
	
	for(NSDictionary *item in responseFromServer) {
		[organisationName addObject:item[@"organization_name"]];
		NSString *orgName = item[@"organization_name"];
		
		NSMutableArray *aux = [[NSMutableArray alloc] init];
		for(NSDictionary *membersInfo in [item objectForKey:@"organization_members_id"]) {
			NSString *completeName =[NSString stringWithFormat:@"%@ %@", membersInfo[@"first_name"], membersInfo[@"last_name"]];
			[membersList addObject:completeName];
			[aux addObject:completeName];
		}
		organisationData[orgName] = aux;
	}
	
	// Save the data in separate variables.
	keyArray = [organisationData allKeys];
	valueArray = [organisationData allValues];
}

#pragma mark - CoreData
-(void)performFetch {
	NSManagedObjectContext *moc = [self managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"UserData" inManagedObjectContext:moc];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];
	NSError *error;
	NSArray *array = [moc executeFetchRequest:request error:&error];
	for (NSManagedObject *managedObject in array) {
		moID = [managedObject objectID];
	}
}

- (void) setupFetchedResultsController {
	// 1 - Decide what Entity you want
	NSString *entityName = @"UserData";
 
	// 2 - Request that Entity
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
 
	// 3 - Fetch it
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
																		managedObjectContext:self.managedObjectContext
																		  sectionNameKeyPath:nil
																				   cacheName:nil];
	[self performFetch];
}

- (NSManagedObjectContext *)managedObjectContext {
	NSManagedObjectContext *context = nil;
	id delegate = [[UIApplication sharedApplication] delegate];
	if ([delegate performSelector:@selector(managedObjectContext)]) {
		context = [delegate managedObjectContext];
	}
	return context;
}


#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [keyArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [valueArray[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [keyArray objectAtIndex:section];
}

-(UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
	}
	
	NSArray *projectListPerOrg =[organisationData valueForKey:keyArray[indexPath.section]];
	cell.textLabel.text = projectListPerOrg[indexPath.row];
	
	return cell;
}


@end
