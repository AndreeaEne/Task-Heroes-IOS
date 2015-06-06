//
//  ProjectsViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 31/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import "ProjectsViewController.h"
#import "SWRevealViewController.h"
#import "UIViewController+NavigationBar.h"
#import <CoreData/CoreData.h>
#import "SingleProjectViewController.h"
#import "SingleTaskViewController.h"
#import "AppDelegate.h"

//NSArray *projectName;
NSString *id_user, *orgID, *orgIDtoSingleTask, *orgIDAddProject, *orgInTextField;
NSMutableDictionary *proiecte, *organisationIDtoSingleTask, *orgIDWithoutProjects;
NSArray *publicTimeline, *keyArray, *valueArray;
UIRefreshControl *refreshControl;
UIAlertView *alert;
UITextField *alertTextField1 , *alertTextField2;
//UIBarButtonItem *addTask;

@interface ProjectsViewController ()

@end

@implementation ProjectsViewController

@synthesize projectsTable;

- (void)viewDidLoad {
	[super viewDidLoad];
	//	NSLog(@"Se apeleaza viewDidLoad");
	// Do any additional setup after loading the view.
	_projectID = [[NSMutableArray alloc] init];
	_organisationID = [[NSMutableArray alloc] init];
	_project_name = [[NSMutableArray alloc] init];
	_organisation_name = [[NSMutableArray alloc] init];
	proiecte = [[NSMutableDictionary alloc] init];
	organisationIDtoSingleTask = [[NSMutableDictionary alloc] init];
	orgIDWithoutProjects = [[NSMutableDictionary alloc] init];
	orgIDtoSingleTask = [[NSString alloc] init];
	orgInTextField = [[NSString alloc] init];
	
	alert = [[UIAlertView alloc] initWithTitle:@"Add New Project"
									   message:@""
									  delegate:self
							 cancelButtonTitle:@"Cancel"
							 otherButtonTitles:@"OK", nil];
	
	alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
	alertTextField1 = [alert textFieldAtIndex:0];
	//	alertTextField1.keyboardType = UIKeyboardTypeDefault;
	alertTextField1.placeholder = @"Type Project Name";
	[[alert textFieldAtIndex:0] setSecureTextEntry:NO];
	
	alertTextField2 = [alert textFieldAtIndex:1];
	//	alertTextField2.keyboardType = UIKeyboardTypeDefault;
	alertTextField2.placeholder = @"Type Organization Name";
	[[alert textFieldAtIndex:1] setSecureTextEntry:NO];
	
	[self setupNavigationBar];
	
	refreshControl = [[UIRefreshControl alloc]init];
	[self.projectsTable addSubview:refreshControl];
	[refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshTable {
	//Refresh data from the table
	[self getProjects];
	[refreshControl endRefreshing];
	[self.projectsTable reloadData];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark navigation bar

- (void) setupNavigationBar {
	[[UIApplication sharedApplication] setStatusBarHidden: NO];
	[self.navigationController setNavigationBarHidden: NO];
	
	
	//Set right button and Title
	_addTask = [[UIBarButtonItem alloc] initWithTitle:@"+ Add" style:UIBarButtonItemStylePlain target:self action:@selector(addTask:)];
	self.navigationItem.rightBarButtonItem = _addTask;
	[[[self navigationItem] rightBarButtonItem] setTintColor:[UIColor whiteColor]];
	[self.navigationItem setTitle:@"Projects"];
	[self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];



	[self setRevealButtonWithImage: [UIImage imageNamed:@"reveal-icon.png"]];
}

-(IBAction)addTask:(id)sender{
	//	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Add a new project! " message:@"This is an example alert!" delegate:self cancelButtonTitle:@"Hide" otherButtonTitles:nil];
	//	alert.alertViewStyle = UIAlertViewStylePlainTextInput;
	//	[alert show];
	////	[alert release];
	//Create the alert then add any labels and text fields as subviews.
	//You can pad out an alertView by adding newline characters in the message.  This will
	// give the alertView more space to draw the text fields.
	//	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Add New Project"
	//													 message:@""
	//													delegate:self
	//										   cancelButtonTitle:@"Cancel"
	//										   otherButtonTitles:@"OK", nil];
	//
	//	alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
	//	UITextField * alertTextField1 = [alert textFieldAtIndex:0];
	////	alertTextField1.keyboardType = UIKeyboardTypeDefault;
	//	alertTextField1.placeholder = @"Type Project Name";
	//	[[alert textFieldAtIndex:0] setSecureTextEntry:NO];
	//
	//	UITextField * alertTextField2 = [alert textFieldAtIndex:1];
	////	alertTextField2.keyboardType = UIKeyboardTypeDefault;
	//	alertTextField2.placeholder = @"Type Organization Name";
	//	[[alert textFieldAtIndex:1] setSecureTextEntry:NO];
	
	[alert show];
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != 0)  // 0 == Cancel button
	{
		orgInTextField = alertTextField2.text;
		NSLog(@"orgInTextField: %@", alertTextField2.text);
		// send project_name, project_desc, end_date, user_id,org_id
		NSDate *date = [[NSDate alloc] init];
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
		NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
		[dateComponents setYear:1];
		NSDate *targetDate = [gregorian dateByAddingComponents:dateComponents toDate:date  options:0];
		int timestamp = [targetDate timeIntervalSince1970];
		
		NSLog(@"organisationIDToSingleTask = %@", orgIDWithoutProjects);
		for (id key in orgIDWithoutProjects)
		{
			if([key isEqualToString:orgInTextField]){
				orgIDAddProject = [orgIDWithoutProjects objectForKey:key];
				NSLog(@"A gasit, orgIDAddProject: %@", orgIDAddProject);
			}
		}
		
		if(orgIDAddProject != NULL) {
			
			//We begin by creating our POST's body as an NSString, and converting it to NSData.
			NSString *post = [NSString stringWithFormat:@"project_name=%@&project_desc=%@&end_date=%d&user_id=%@&org_id=%@", alertTextField1.text,@"Added From Mobile",timestamp, id_user, orgIDAddProject];
			
			NSLog(@"trimit: %@, %d, %@, %@", alertTextField2.text, timestamp, id_user, orgIDAddProject);
			
			//	NSLog(@"A fost adaugat task-ul cu numele %@, proiectul cu ID-ul %@, orgID = %@", _addTaskNameField.text, _projectID, _orgID);
			NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
			
			//Next up, we read the postData's length, so we can pass it along in the request.
			NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
			
			//Now that we have what we'd like to post, we can create an NSMutableURLRequest, and include our postData
			NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
			[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/mobile/insert/project"]];
			[request setHTTPMethod:@"POST"];
			[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
			[request setHTTPBody:postData];
			
			//Request
			NSURLResponse *requestResponse;
			NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
			
			NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
			
			NSLog(@"request: %@", requestReply);
			
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

- (void) getProjects {
	//Get user data
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
		// Handle the error.
	}
	
	
	//We begin by creating our POST's body (ergo. what we'd like to send) as an NSString, and converting it to NSData.
	NSString *post = [NSString stringWithFormat:@"id=%@", id_user];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	//Next up, we read the postData's length, so we can pass it along in the request.
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	
	//Now that we have what we'd like to post, we can create an NSMutableURLRequest, and include our postData
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/mobile/get/projects"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	
	//Send the request, and read the reply:
	//	NSURLResponse *requestResponse;
	//	NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
	
	//	NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
	//requestReply = [NSString stringWithFormat:@"msg"];
	
	//		NSArray *components = [requestReply componentsSeparatedByString:@"},"];
	//		NSLog(@"\nRequest: %@",requestReply);
	
	//JSON Parse
	NSData *response = [NSURLConnection sendSynchronousRequest:request
											 returningResponse:nil error:nil];
	NSError *jsonParsingError = nil;
	publicTimeline = [NSJSONSerialization JSONObjectWithData:response
													 options:0 error:&jsonParsingError];
	
		NSLog(@"publicTimeline:\n%@", publicTimeline);
	
	if (!publicTimeline) {
		NSLog(@"Error parsing JSON: %@", fetchError);
	}
	else {
		for(NSDictionary *item in publicTimeline) {
			//			[_projectID addObject:item[@"_id"]];
			[_organisation_name addObject:item[@"organization_name"]];
			NSString *orgName = item[@"organization_name"];
			[orgIDWithoutProjects setObject:item[@"_id"] forKey:orgName];
			
			NSMutableArray *aux = [[NSMutableArray alloc] init];
			for(NSDictionary *projName in [item objectForKey:@"organization_projects"]) {
				[_project_name addObject:projName[@"project_name"]];
				[_organisationID addObject:projName[@"org"]];
				[_projectID addObject:projName[@"_id"]];
				[organisationIDtoSingleTask setObject:projName[@"org"] forKey:item[@"organization_name"]];
				
				NSString *ceva = projName[@"project_name"];
				[aux addObject:ceva];
				
				//				NSString *ceva2 = projName[@"_id"];
				//				[aux addObject:ceva2];
				//				proiecte[ceva]=orgName;
			}
			proiecte[orgName] = aux;
			
			
		}
		//		NSLog(@"Dictionary: %@", proiecte);
		//		NSLog(@"organisationIDtoSingleTask: %@",organisationIDtoSingleTask);
		
		keyArray = [proiecte allKeys];
		//		NSLog(@"%@", keyArray);
		valueArray = [proiecte allValues];
		//		NSLog(@"%@", valueArray);
		
		//		for (NSString *item in _project_name)
		//			NSLog(@"obj: %@", item);
		//
		//		for (NSString *item in _organisation_name)
		//			NSLog(@"obj: %@", item);
		//
	}
	
	
	//		for (NSString *item in _projectID)
	//			NSLog(@"obj: %@", item);
	
	//		for(int i=0; i < [publicTimeline count]; i++ )
	//		{
	//			project= [publicTimeline objectAtIndex:i];
	//			NSLog(@"_id: %@", [project objectForKey:@"_id"]);
	//
	//			NSDictionary *organization_projects = [project objectForKey:@"organization_projects"];
	//			NSLog(@"org proj count: %lu", (unsigned long)[organization_projects count]);
	//
	//			_projectID = publicTimeline[1][@"_id"];
	//			NSLog(@"%@", _projectID);
	//		}
	//}
	
	//		for (int j = i; j < [publicTimeline count]; j++) {
	//			_project_name = [project objectForKey:@"project_name"];
	////			NSLog(@"Project Name: %@", [orga objectForKey:@"project_description"]);
	//			NSLog(@"Is this working?[%d] : %@", j, organization_projects);
	
	//			}
	//		}
	//
	//		projectName = [project objectForKey:@"project_name"];
	//		NSLog(@"Project_name: %@", projectName );
	//		NSLog(@"Project manager: %@", [project objectForKey:@"project_manager"]);
	//
	//		NSLog(@"project_members: %@", [project objectForKey:@"project_members"]);
	
	
	//	}
}


//Working
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//
//{
//	static NSString *simpleTableIdentifier = @"SimpleTableCell";
//
//	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//
//	if (cell == nil) {
//		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//	}
//
//	cell.textLabel.text = [_project_name objectAtIndex:indexPath.row];
//	return cell;
//}

//Si mai bun
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
//
//
//	[cell.textLabel setText:[keyArray objectAtIndex:indexPath.row]];
//	[cell.detailTextLabel setText:[valueArray objectAtIndex:indexPath.row]];
//
//	return cell;
//}

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

//send data to SingleProject
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
			NSLog(@"orgIDtoSingleTask: %@",orgIDtoSingleTask);
			break;
		}
	}
	
	//	NSLog(@"Row Selected = %@",indexPath);
	//	NSLog(@"Proiectul are id-ul = %@", orgID);
	
	[self performSegueWithIdentifier:@"goToSingleProject" sender:self.view];
	
}

//Send orgID to SingleProjectViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	//	NSLog(@"prepareForSegue: %@", segue.identifier);
	
	if([segue.identifier isEqualToString:@"goToSingleProject"]) {
		SingleProjectViewController *singleProjectController = segue.destinationViewController;
		//SingleTaskViewController *singleTaskViewController = [[SingleTaskViewController alloc] init];
		
		//NSLog(@"before setting projectID = %@", singleProjectController.projectID);
		singleProjectController.projectID = orgID;
		//		NSLog(@"after setting projectID = %@", singleProjectController.projectID);
		
		NSIndexPath *indexPath = [self.projectsTable indexPathForSelectedRow];
		UITableViewCell *cell = [projectsTable cellForRowAtIndexPath:indexPath];
		
		//NSLog(@"before setting = %@", singleProjectController.projectTitle);
		singleProjectController.projectTitle = cell.textLabel.text;
		singleProjectController.organisationID = orgIDtoSingleTask;
		
		//singleTaskViewController.orgID = orgIDtoSingleTask;
		//NSLog(@"after setting = %@", singleProjectController.projectTitle);
		
		//
		//singleProjectController.projectTitle = [valueArray objectAtIndex:indexPath.row];
		//[singleProjectController.setProjectTitle setText:[valueArray objectAtIndex:indexPath.row]];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	//NSLog(@"Se apeleaza viewWillAppear");
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

// Init the object with information from a dictionary
//- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary {
//	if(self = [self init]) {
//		// Assign all properties with keyed values from the dictionary
//		_organisationID = [jsonDictionary objectForKey:@"org"];
//		_projectID = [jsonDictionary objectForKey:@"_id"];
//		_project_name = [jsonDictionary objectForKey:@"project_name"];
//		_organisation_name = [jsonDictionary objectForKey:@"organisation_name"];
//	}
//
//	return self;
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
