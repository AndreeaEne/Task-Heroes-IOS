//
//  ProjectsViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 31/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

/** This view contains the list with all projects. **/

#import "ProjectsViewController.h"
#import "SWRevealViewController.h"
#import "UIViewController+NavigationBar.h"
#import <CoreData/CoreData.h>
#import "SingleProjectViewController.h"
#import "SingleTaskViewController.h"
#import "AppDelegate.h"

NSString *id_user, *orgID, *orgIDtoSingleTask, *orgIDAddProject, *orgInTextField;		// Variables to save useful data from the server.
NSMutableDictionary *proiecte, *organisationIDtoSingleTask, *orgIDWithoutProjects;
NSArray *publicTimeline, *keyArray, *valueArray;

UIRefreshControl *refreshControl;														// Regresh control for the TableView.

UIAlertView *alert;																		// AlertView.
UITextField *alertTextField1 , *alertTextField2;

@interface ProjectsViewController ()

@end

@implementation ProjectsViewController

@synthesize projectsTable;

- (void)viewDidLoad {
	NSLog(@"ProjectsViewController loaded.");
	[super viewDidLoad];

	_projectID = [[NSMutableArray alloc] init];
	_organisationID = [[NSMutableArray alloc] init];
	_project_name = [[NSMutableArray alloc] init];
	_organisation_name = [[NSMutableArray alloc] init];
	proiecte = [[NSMutableDictionary alloc] init];
	organisationIDtoSingleTask = [[NSMutableDictionary alloc] init];
	orgIDWithoutProjects = [[NSMutableDictionary alloc] init];
	orgIDtoSingleTask = [[NSString alloc] init];
	orgInTextField = [[NSString alloc] init];
	
	// Alert view.
	alert = [[UIAlertView alloc] initWithTitle:@"Add New Project"
									   message:@""
									  delegate:self
							 cancelButtonTitle:@"Cancel"
							 otherButtonTitles:@"OK", nil];
	
	alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
	alertTextField1 = [alert textFieldAtIndex:0];
	
	alertTextField1.placeholder = @"Type Project Name";
	[[alert textFieldAtIndex:0] setSecureTextEntry:NO];
	
	alertTextField2 = [alert textFieldAtIndex:1];

	alertTextField2.placeholder = @"Type Organization Name";
	[[alert textFieldAtIndex:1] setSecureTextEntry:NO];
	
	[self setupNavigationBar];
	
	refreshControl = [[UIRefreshControl alloc]init];
	[self.projectsTable addSubview:refreshControl];
	[refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshTable {
	[self getProjects];
	[refreshControl endRefreshing];
	[self.projectsTable reloadData];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - Setup NavigationBar

- (void) setupNavigationBar {
	[[UIApplication sharedApplication] setStatusBarHidden: NO];
	[self.navigationController setNavigationBarHidden: NO];
	
	// Set right button and Title.
	_addTask = [[UIBarButtonItem alloc] initWithTitle:@"+ Add" style:UIBarButtonItemStylePlain target:self action:@selector(addTask:)];
	self.navigationItem.rightBarButtonItem = _addTask;
	[[[self navigationItem] rightBarButtonItem] setTintColor:[UIColor whiteColor]];
	[self.navigationItem setTitle:@"Projects"];
	[self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
	
	[self setRevealButtonWithImage: [UIImage imageNamed:@"reveal-icon.png"]];
}

-(IBAction)addTask:(id)sender {
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != 0) {  // 0 == Cancel button
		orgInTextField = alertTextField2.text;

		// Send project_name, project_desc, end_date, user_id,org_id.
		NSDate *date = [[NSDate alloc] init];
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
		NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
		[dateComponents setYear:1];
		NSDate *targetDate = [gregorian dateByAddingComponents:dateComponents toDate:date  options:0];
		int timestamp = [targetDate timeIntervalSince1970];

		for (id key in orgIDWithoutProjects) {
			if([key isEqualToString:orgInTextField]){
				orgIDAddProject = [orgIDWithoutProjects objectForKey:key];
				// NSLog(@"Found, orgIDAddProject: %@", orgIDAddProject);
			}
		}
		
		if(orgIDAddProject != NULL) {
			// Create POST's body as an NSString, and convert it to NSData.
			NSString *post = [NSString stringWithFormat:@"project_name=%@&project_desc=%@&end_date=%d&user_id=%@&org_id=%@", alertTextField1.text,@"Added From Mobile",timestamp, id_user, orgIDAddProject];
			
			NSLog(@"trimit: %@, %d, %@, %@", alertTextField2.text, timestamp, id_user, orgIDAddProject);
			
			// NSLog(@"Added the task called %@, project with ID %@, orgID = %@", _addTaskNameField.text, _projectID, _orgID);
			NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
			
			// Read the postData's length, so it can be passed along in the request.
			NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
			
			// Create an NSMutableURLRequest, and include our postData.
			NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
			[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/mobile/insert/project"]];
			[request setHTTPMethod:@"POST"];
			[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
			[request setHTTPBody:postData];
			
			// Request.
			NSURLResponse *requestResponse;
			NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
			NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
			NSLog(@"request: %@", requestReply);
			
			// Show alert about the project.
			NSString *successMessage = [NSString stringWithFormat:@"Project %@ has beend added to %@", alertTextField1.text, alertTextField2.text];
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle: @"Announcement"
								  message: successMessage
								  delegate: nil
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil];
			[alert show];
		}
		else if (alertTextField1.text.length == 0 && alertTextField2.text.length == 0){
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle: @"Announcement"
							  message: @"Please type Project Name and Organization Name!"
							  delegate: nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
		[alert show];
		}
		else if (alertTextField1.text.length == 0){
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle: @"Announcement"
								  message: @"Please type Project Name"
								  delegate: nil
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil];
			[alert show];
		}
		else if (alertTextField2.text.length == 0 && alertTextField2.text.length == 0){
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle: @"Announcement"
								  message: @"Please type Organization Name!"
								  delegate: nil
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil];
			[alert show];
		}
		else if (orgIDAddProject == NULL) {
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle: @"Announcement"
								  message: @"The specified Orgaization doesn't exist!"
								  delegate: nil
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil];
			[alert show];
		}
	}
}

// Get user data and projects from the sever.
- (void) getProjects {
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserData"];
	NSManagedObjectContext *context = [self managedObjectContext];
	NSError *fetchError = nil;
	NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
	
	if (!fetchError) {
		for (NSManagedObject *managedObject in result) {
			id_user = [managedObject valueForKey:@"id_user"];
		}
		
	} else {
		NSLog(@"Error fetching data.");
		NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
	}
	
	NSError *error;
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	if (fetchedObjects == nil) {
		//TODO: Handle the error.
	}
	
	// Create POST's body as an NSString, and convert it to NSData.
	NSString *post = [NSString stringWithFormat:@"id=%@", id_user];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	// Read the postData's length, so it can passed along in the request.
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	
	// Create an NSMutableURLRequest, and include the postData.
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/mobile/get/projects"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	

	// JSON Parse.
	NSData *response = [NSURLConnection sendSynchronousRequest:request
											 returningResponse:nil error:nil];
	NSError *jsonParsingError = nil;
	publicTimeline = [NSJSONSerialization JSONObjectWithData:response
													 options:0 error:&jsonParsingError];
	
	if (!publicTimeline) {
		NSLog(@"Error parsing JSON: %@", fetchError);
	}
	else {
		for(NSDictionary *item in publicTimeline) {
			[_organisation_name addObject:item[@"organization_name"]];
			NSString *orgName = item[@"organization_name"];
			[orgIDWithoutProjects setObject:item[@"_id"] forKey:orgName];
			
			NSMutableArray *aux = [[NSMutableArray alloc] init];
			for(NSDictionary *projName in [item objectForKey:@"organization_projects"]) {
				[_project_name addObject:projName[@"project_name"]];
				[_organisationID addObject:projName[@"org"]];
				[_projectID addObject:projName[@"_id"]];
				[organisationIDtoSingleTask setObject:projName[@"org"] forKey:item[@"organization_name"]];
				
				NSString *name = projName[@"project_name"];
				[aux addObject:name];
			}
			proiecte[orgName] = aux;
		}

		keyArray = [proiecte allKeys];
		valueArray = [proiecte allValues];
	}
}


#pragma mark - Setup TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [keyArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [valueArray[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
	}
	
	NSArray *projectListPerOrg =[proiecte valueForKey:keyArray[indexPath.section]];
	cell.textLabel.text = projectListPerOrg[indexPath.row];
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [keyArray objectAtIndex:section];
}

// Send data to SingleProject.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	NSString *currentSection = keyArray[indexPath.section];
	
	for(NSDictionary *item in publicTimeline) {
		NSString *orgName = item[@"organization_name"];
		if([orgName isEqualToString:currentSection]) {
			for(NSDictionary *projName in [item objectForKey:@"organization_projects"]) {
				NSString *currentProject = projName[@"project_name"];
				if([cell.textLabel.text isEqualToString:currentProject]) {
					orgID = projName[@"_id"];
					break;
				}
			}
			break;
		}
	}
	
	for(NSString *key in [organisationIDtoSingleTask allKeys]) {
		if([key isEqualToString:currentSection]) {
			orgIDtoSingleTask = [organisationIDtoSingleTask objectForKey:key];
			break;
		}
	}
	[self performSegueWithIdentifier:@"goToSingleProject" sender:self.view];
	
}

#pragma mark - Segue
// Send orgID to SingleProjectViewController.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if([segue.identifier isEqualToString:@"goToSingleProject"]) {
		SingleProjectViewController *singleProjectController = segue.destinationViewController;
		singleProjectController.projectID = orgID;

		NSIndexPath *indexPath = [self.projectsTable indexPathForSelectedRow];
		UITableViewCell *cell = [projectsTable cellForRowAtIndexPath:indexPath];
		
		singleProjectController.projectTitle = cell.textLabel.text;
		singleProjectController.organisationID = orgIDtoSingleTask;
	}
}

// Get data before the view appears.
- (void)viewWillAppear:(BOOL)animated {
	[self getProjects];
}

- (NSManagedObjectContext *) managedObjectContext {
	NSManagedObjectContext *context = nil;
	id delegate = [[UIApplication sharedApplication] delegate];
	if([delegate performSelector:@selector(managedObjectContext)]) {
		context = [delegate managedObjectContext];
	}
	return context;
}

@end
