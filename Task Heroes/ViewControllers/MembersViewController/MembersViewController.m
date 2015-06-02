//
//  MembersViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 30/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import "MembersViewController.h"
#import "SWRevealViewController.h"
#import "UIViewController+NavigationBar.h"
#import <CoreData/CoreData.h>

NSString *userID;
NSMutableArray *membersList, *organisationName;
NSManagedObjectID *moID;
NSMutableDictionary *organisationData;
NSArray *keyArray, *valueArray;

@interface MembersViewController ()

@end

@implementation MembersViewController
@synthesize userData;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self setupNavigationBar];
	// Do any additional setup after loading the view.
	
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
	// Dispose of any resources that can be recreated.
}

#pragma mark navigation bar

- (void) setupNavigationBar
{
	[[UIApplication sharedApplication] setStatusBarHidden: NO];
	[self.navigationController setNavigationBarHidden: NO];
	
	[self setTitle:@"Volunteers"];
	[self setRevealButtonWithImage: [UIImage imageNamed:@"reveal-icon.png"]];
}

- (void)getOrganizations {
	userID = [[NSString alloc] init];
	userData = (UserData *)[self.managedObjectContext
							existingObjectWithID:moID
							error:nil];
	userID = userData.id_user;
	NSLog(@"userID: %@", userID);
	
	
	//We begin by creating our POST's body as an NSString, and converting it to NSData.
	NSString *post = [NSString stringWithFormat:@"user_id=%@", userID];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	//Next up, we read the postData's length, so we can pass it along in the request.
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	
	//Now that we have what we'd like to post, we can create an NSMutableURLRequest, and include our postData
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/mobile/get/volunteers"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSError *jsonParsingError = nil;
	NSDictionary *responseFromServer = [NSJSONSerialization JSONObjectWithData:response
																	   options:0 error:&jsonParsingError];
	NSLog(@"Response: %@", responseFromServer);
	
	//	for(NSDictionary *item in responseFromServer) {
	//		//NSLog(@"item: %@ ", item[@"task_name"]);
	//		[membersList addObject:item[@"organization_name"]];
	//	}
	
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
	keyArray = [organisationData allKeys];
	//		NSLog(@"%@", keyArray);
	valueArray = [organisationData allValues];
}

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
		NSLog(@"moID: %@", moID);
	}
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

- (NSManagedObjectContext *)managedObjectContext {
	NSManagedObjectContext *context = nil;
	id delegate = [[UIApplication sharedApplication] delegate];
	if ([delegate performSelector:@selector(managedObjectContext)]) {
		context = [delegate managedObjectContext];
	}
	return context;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [keyArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [valueArray[section] count];
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return [keyArray objectAtIndex:section];
}

-(UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
	}
	
	NSArray *projectListPerOrg =[organisationData valueForKey:keyArray[indexPath.section]];
	cell.textLabel.text = projectListPerOrg[indexPath.row];
	
	return cell;
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
