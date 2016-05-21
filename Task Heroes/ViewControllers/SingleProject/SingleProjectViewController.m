//
//  SingeProjectViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 09/05/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

/** This view contains information about a single project. **/

#import "SingleProjectViewController.h"
#import "SingleTaskViewController.h"
#import "AppDelegate.h"

NSDictionary *responseFromServer;									// All data received from server.
NSMutableDictionary *taskList, *taskID, *taskPoints, *addedDate;	// Variables to save useful data from server.
NSString *results, *singleTaskPoints, *singleAddedDate;
NSMutableArray *task_name;											// Array wih all tasks in a project.
NSArray *keyArray, *valueArray;										// Keys & values for taskList dictionary.
UIRefreshControl *refreshControl;									// Refresh the view.

@interface SingleProjectViewController ()

@end

@implementation SingleProjectViewController

@synthesize projectID;
@synthesize setProjectTitle;
@synthesize projectTitle;
@synthesize tasksTable;


- (void)viewDidLoad {
	NSLog(@"SingleProjectViewController loaded.");
	[super viewDidLoad];
	[self getData];
	
	// Change the color of the navigation bar.
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	
	// Initialize the variables.
	results = [[NSString alloc] init];
	singleTaskPoints = [[NSString alloc] init];
	singleAddedDate = [[NSString alloc] init];
	task_name = [[NSMutableArray alloc] init];
	
	// Set the dataSource and delegate for the table of the tasks.
	tasksTable.dataSource = self;
	tasksTable.delegate = self;
	
	setProjectTitle.text = projectTitle;

	// Set the refresh control of the table.
	refreshControl = [[UIRefreshControl alloc] init];
	[self.tasksTable addSubview:refreshControl];
	[refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

// Gets the data of the current user from the server.
- (void)getData {
	NSError *fetchError = nil;
	
	NSString *post = [NSString stringWithFormat:@"_id=%@", projectID];
	
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/get/tasks"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSError *jsonParsingError = nil;
	responseFromServer = [NSJSONSerialization JSONObjectWithData:response
														 options:0 error:&jsonParsingError];
	
	if (!responseFromServer) {
		NSLog(@"Error parsing JSON: %@", fetchError);
	}
	else {
		taskID = [[NSMutableDictionary alloc] init];
		taskPoints = [[NSMutableDictionary alloc] init];
		addedDate = [[NSMutableDictionary alloc] init];
		
		// Get the tasks for the 4 lists and save them in separate arrays.
		NSMutableArray *backlog = [[NSMutableArray alloc] init];
		NSMutableArray *waiting = [[NSMutableArray alloc] init];
		NSMutableArray *doing = [[NSMutableArray alloc] init];
		NSMutableArray *done = [[NSMutableArray alloc] init];
		for(NSDictionary *item in responseFromServer[@"backlog"]) {
			[backlog addObject:[item objectForKey:@"task_name"]];
			[taskID setObject:[item objectForKey:@"_id"] forKey:[item objectForKey:@"task_name"]];
			[taskPoints setObject:[item objectForKey:@"points"] forKey:[item objectForKey:@"task_name"]];
			[addedDate setObject:[item objectForKey:@"added_on"] forKey:[item objectForKey:@"task_name"]];
		}
		for(NSDictionary *item in responseFromServer[@"waiting"]) {
			[waiting addObject:[item objectForKey:@"task_name"]];
			[taskID setObject:[item objectForKey:@"_id"] forKey:[item objectForKey:@"task_name"]];
			[taskPoints setObject:[item objectForKey:@"points"] forKey:[item objectForKey:@"task_name"]];
			[addedDate setObject:[item objectForKey:@"added_on"] forKey:[item objectForKey:@"task_name"]];
		}
		for(NSDictionary *item in responseFromServer[@"doing"]) {
			[doing addObject:[item objectForKey:@"task_name"]];
			[taskID setObject:[item objectForKey:@"_id"] forKey:[item objectForKey:@"task_name"]];
			[taskPoints setObject:[item objectForKey:@"points"] forKey:[item objectForKey:@"task_name"]];
			[addedDate setObject:[item objectForKey:@"added_on"] forKey:[item objectForKey:@"task_name"]];
		}
		for(NSDictionary *item in responseFromServer[@"done"]) {
			[done addObject:[item objectForKey:@"task_name"]];
			[taskID setObject:[item objectForKey:@"_id"] forKey:[item objectForKey:@"task_name"]];
			[taskPoints setObject:[item objectForKey:@"points"] forKey:[item objectForKey:@"task_name"]];
			[addedDate setObject:[item objectForKey:@"added_on"] forKey:[item objectForKey:@"task_name"]];
		}
		taskList = [[NSMutableDictionary alloc] init];
		[taskList setObject:backlog forKey:@"Backlog"];
		[taskList setObject:waiting forKey:@"Waiting"];
		[taskList setObject:doing forKey:@"Doing"];
		[taskList setObject:done forKey:@"Done"];

		keyArray = [taskList allKeys];
		valueArray = [taskList allValues];
	}
}

#pragma mark - Setup TableView
// Set up the TableView.
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
	
	NSArray *projectListPerOrg =[taskList valueForKey:keyArray[indexPath.section]];
	cell.textLabel.text = projectListPerOrg[indexPath.row];
	
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [keyArray objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	for (NSString *key in [taskID allKeys]) {
		if ([key isEqualToString:cell.textLabel.text]) {
			results = [taskID objectForKey:key];
			break;
		}
	}
	for (NSString *key in [taskPoints allKeys]) {
		if ([key isEqualToString:cell.textLabel.text]) {
			singleTaskPoints = [taskPoints objectForKey:key];
			break;
		}
	}
	for (NSString *key in [addedDate allKeys]) {
		if ([key isEqualToString:cell.textLabel.text]) {
			singleAddedDate = [addedDate objectForKey:key];
			break;
		}
	}
	[self performSegueWithIdentifier:@"goToSingleTask" sender:self.view];
}

// Refresh the table.
- (void)refreshTable {
	[self getData];
	[refreshControl endRefreshing];
	[self.tasksTable reloadData];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	SingleTaskViewController *singleTaskViewController = segue.destinationViewController;
	
	if([segue.identifier isEqualToString:@"goToSingleTask"]){
		NSIndexPath *indexPath = [self.tasksTable indexPathForSelectedRow];
		UITableViewCell *cell = [tasksTable cellForRowAtIndexPath:indexPath];
		singleTaskViewController.taskName = cell.textLabel.text;
		singleTaskViewController.projectID = projectID;
		
		NSInteger section = indexPath.section;
		switch (section) {
			case 0:
				singleTaskViewController.projectFrom = @"Backlog";
				break;
			case 1:
				singleTaskViewController.projectFrom = @"Waiting";
				break;
			case 2:
				singleTaskViewController.projectFrom = @"Doing";
				break;
			case 3:
				singleTaskViewController.projectFrom = @"Done";
				break;
		}
		singleTaskViewController.taskID = results;
		singleTaskViewController.points = singleTaskPoints;
		singleTaskViewController.addedDate = singleAddedDate;
		singleTaskViewController.changeTask = 0;
		
		self.definesPresentationContext = YES;
		
		singleTaskViewController.view.backgroundColor = self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];//[UIColor colorWithWhite:1.0 alpha:0.5];
		singleTaskViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
	}
	else if([segue.identifier isEqualToString:@"addNewTask"]){
		singleTaskViewController.orgID = _organisationID;
		singleTaskViewController.projectID = projectID;
		singleTaskViewController.taskID = results;
		
		[singleTaskViewController.taskName isEqualToString:@"Add New Task"];
		self.definesPresentationContext = YES;
		
		singleTaskViewController.changeTask = 1;
		singleTaskViewController.view.backgroundColor = self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
		singleTaskViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
	}
}

#pragma mark - Add new task.
- (IBAction)addNewTask:(id)sender {
	[self performSegueWithIdentifier:@"addNewTask" sender:self.view];
}

#pragma mark - CoreData
- (NSManagedObjectContext *) managedObjectContext {
	NSManagedObjectContext *context = nil;
	id delegate = [[UIApplication sharedApplication] delegate];
	if ([delegate performSelector:@selector(managedObjectContext)]) {
		context = [delegate managedObjectContext];
	}
	return context;
}


@end
