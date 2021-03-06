//
//  OrganisationProfileViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 31/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

/** This view contains the list with all organisations. **/

#import "OrganisationProfileViewController.h"
#import "SWRevealViewController.h"
#import "UIViewController+NavigationBar.h"
#import <CoreData/CoreData.h>

NSString *userID;									// ID of the current user.
NSManagedObjectID *moID;							// ID of the current object.
NSMutableArray *orgName;							// Array with all organisations.
UIRefreshControl *refreshControl;					// Refresh TableView.

UIAlertView *alert;									// AlertView.
UITextField *alertTextField1 , *alertTextField2;


@interface OrganisationProfileViewController ()

@end

@implementation OrganisationProfileViewController
@synthesize userData;

- (void)viewDidLoad {
	NSLog(@"OrganisationViewController loaded.");
	[super viewDidLoad];
	
	[self setupNavigationBar];
	[self getOrganizations];
	
	// Refresh the table.
	refreshControl = [[UIRefreshControl alloc] init];
	[self.orgTable addSubview:refreshControl];
	[refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
	
	_addOrg = [[UIBarButtonItem alloc] initWithTitle:@"+ Add" style:UIBarButtonItemStylePlain target:self action:@selector(addTask:)];
	
	self.navigationItem.rightBarButtonItem = _addOrg;
	[[[self navigationItem] rightBarButtonItem] setTintColor:[UIColor whiteColor]];
	
	
	// Set the TableView.
	alert = [[UIAlertView alloc] initWithTitle:@"Add New Organization"
									   message:@""
									  delegate:self
							 cancelButtonTitle:@"Cancel"
							 otherButtonTitles:@"OK", nil];
	
	
	alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
	
	alertTextField1 = [alert textFieldAtIndex:0];
	alertTextField1.placeholder = @"Type Orgianization Name";
	[[alert textFieldAtIndex:0] setSecureTextEntry:NO];
	
	alertTextField2 = [alert textFieldAtIndex:1];
	alertTextField2.placeholder = @"Type Organization Description";
	[[alert textFieldAtIndex:1] setSecureTextEntry:NO];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - Setup Navigation Bar
- (void)setupNavigationBar {
	[[UIApplication sharedApplication] setStatusBarHidden: NO];
	[self.navigationController setNavigationBarHidden: NO];
	
	[self setTitle:@"Organisations"];
	[self setRevealButtonWithImage: [UIImage imageNamed:@"reveal-icon.png"]];
}

// Get info from the server.
- (void)getOrganizations {
	userID = [[NSString alloc] init];
	userData = (UserData *)[self.managedObjectContext
							existingObjectWithID:moID
							error:nil];
	userID = userData.id_user;
	
	// Create POST's body as an NSString, and converting it to NSData.
	NSString *post = [NSString stringWithFormat:@"user_id=%@", userID];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	// Read the postData's length, so we can pass it along in the request.
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	
	// Create an NSMutableURLRequest, and include our postData.
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/mobile/get/org"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSError *jsonParsingError = nil;
	NSDictionary *responseFromServer = [NSJSONSerialization JSONObjectWithData:response
																	   options:0 error:&jsonParsingError];
	
	orgName = [[NSMutableArray alloc] init];
	for(NSDictionary *item in responseFromServer) {
		[orgName addObject:item[@"organization_name"]];
	}
	
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [orgName count];
}

#pragma mark - Setup tableView
-(UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
	}
	
	cell.textLabel.text = orgName[indexPath.row];
	return cell;
}

// Refresh data from the table.
- (void)refreshTable {
	orgName = nil;
	[self getOrganizations];
	[refreshControl endRefreshing];
	[_orgTable reloadData];
}

# pragma mark - alerView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != 0) {
		if (alertTextField1.text.length > 0 && alertTextField2.text.length > 0 && [orgName containsObject:alertTextField1.text] == false) {
			
			//We begin by creating our POST's body as an NSString, and converting it to NSData.
			NSString *post = [NSString stringWithFormat:@"org_Name=%@&org_Type&org_Desc=%@&user_id=%@",alertTextField1.text, alertTextField2.text,userID];
			
			NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
			
			//Next up, we read the postData's length, so we can pass it along in the request.
			NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
			
			//Now that we have what we'd like to post, we can create an NSMutableURLRequest, and include our postData
			NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
			[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/mobile/new/org"]];
			[request setHTTPMethod:@"POST"];
			[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
			[request setHTTPBody:postData];

			NSString *successMessage = [NSString stringWithFormat:@"The organization %@ has beend added!", alertTextField1.text];
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle: @"Announcement"
								  message: successMessage
								  delegate: nil
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil];
			[alert show];
		}
		else  if ([orgName containsObject:alertTextField1.text]) {
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle: @"Announcement"
								  message: @"The Organization already exists!"
								  delegate: nil
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil];
			[alert show];
		}
		else  if (alertTextField2.text.length == 0 && alertTextField1.text.length == 0) {
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle: @"Announcement"
								  message: @"Please type Organization Name and Organization Description!"
								  delegate: nil
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil];
			[alert show];
		}
		else  if (alertTextField1.text.length == 0) {
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle: @"Announcement"
								  message: @"Please type Organization Name!"
								  delegate: nil
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil];
			[alert show];
		}
		else {
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle: @"Announcement"
								  message: @"Please type Organization Description!"
								  delegate: nil
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil];
			[alert show];
		}
	}
}

-(IBAction)addTask:(id)sender{
	[alert show];
	
}



@end
