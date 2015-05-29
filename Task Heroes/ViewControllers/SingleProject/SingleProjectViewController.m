//
//  SingeProjectViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 09/05/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

#import "SingleProjectViewController.h"
#import "SingleTaskViewController.h"
#import "AppDelegate.h"

NSDictionary *responseFromServer;
NSMutableDictionary *taskList, *taskID, *taskPoints, *addedDate;
NSMutableArray *task_name;
NSString *results, *singleTaskPoints, *singleAddedDate;
NSArray *keyArray, *valueArray;
UIRefreshControl *refreshControl;

@interface SingleProjectViewController ()

@end

@implementation SingleProjectViewController

@synthesize projectID;
@synthesize setProjectTitle;
@synthesize projectTitle;
@synthesize tasksTable;



- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	[self getData];
	
	results = [[NSString alloc] init];
	singleTaskPoints = [[NSString alloc] init];
	singleAddedDate = [[NSString alloc] init];

	tasksTable.dataSource = self;
	tasksTable.delegate = self;
	
	task_name = [[NSMutableArray alloc] init];
	
	setProjectTitle.text = projectTitle;
	_wallImage.image = [UIImage imageNamed:@"wallpaper2.jpg"];
	
	refreshControl = [[UIRefreshControl alloc]init];
	[self.tasksTable addSubview:refreshControl];
	[refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshTable {
	//TODO: refresh your data
	[self getData];
	[refreshControl endRefreshing];
	[self.tasksTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self getData];
	[tasksTable reloadData];
	NSLog(@"SingleProject: viewWillAppear called");
}

- (void) getData {
	NSError *fetchError = nil;
//	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserData"];
//	NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
	
	//We begin by creating our POST's body as an NSString, and converting it to NSData.
	NSString *post = [NSString stringWithFormat:@"_id=%@", projectID];
//	NSLog(@"projectID: %@", projectID);
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	//Next up, we read the postData's length, so we can pass it along in the request.
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	
	//Now that we have what we'd like to post, we can create an NSMutableURLRequest, and include our postData
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/get/tasks"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSError *jsonParsingError = nil;
	responseFromServer = [NSJSONSerialization JSONObjectWithData:response
														 options:0 error:&jsonParsingError];
//	NSLog(@"Response: %@", responseFromServer);
	
	if (!responseFromServer) {
		NSLog(@"Error parsing JSON: %@", fetchError);
	}
	else {
		taskID = [[NSMutableDictionary alloc] init];
		taskPoints = [[NSMutableDictionary alloc] init];
		addedDate = [[NSMutableDictionary alloc] init];
		NSMutableArray *backlog = [[NSMutableArray alloc] init];
		NSMutableArray *waiting = [[NSMutableArray alloc] init];
		NSMutableArray *doing = [[NSMutableArray alloc] init];
		NSMutableArray *done = [[NSMutableArray alloc] init];
		for(NSDictionary *item in responseFromServer[@"backlog"]) {
			[backlog addObject:[item objectForKey:@"task_name"]];
//			[taskID addObject:[item objectForKey:@"_id"]];
			[taskID setObject:[item objectForKey:@"_id"] forKey:[item objectForKey:@"task_name"]];
			[taskPoints setObject:[item objectForKey:@"points"] forKey:[item objectForKey:@"task_name"]];
			[addedDate setObject:[item objectForKey:@"added_on"] forKey:[item objectForKey:@"task_name"]];
			
//			NSLog(@"%@",[item objectForKey:@"task_name"]);
		}
		for(NSDictionary *item in responseFromServer[@"waiting"]) {
			[waiting addObject:[item objectForKey:@"task_name"]];
			[taskID setObject:[item objectForKey:@"_id"] forKey:[item objectForKey:@"task_name"]];
			[taskPoints setObject:[item objectForKey:@"points"] forKey:[item objectForKey:@"task_name"]];
			[addedDate setObject:[item objectForKey:@"added_on"] forKey:[item objectForKey:@"task_name"]];
//			NSLog(@"%@",[item objectForKey:@"task_name"]);
		}
		for(NSDictionary *item in responseFromServer[@"doing"]) {
			[doing addObject:[item objectForKey:@"task_name"]];
			[taskID setObject:[item objectForKey:@"_id"] forKey:[item objectForKey:@"task_name"]];
			[taskPoints setObject:[item objectForKey:@"points"] forKey:[item objectForKey:@"task_name"]];
			[addedDate setObject:[item objectForKey:@"added_on"] forKey:[item objectForKey:@"task_name"]];
//			NSLog(@"%@",[item objectForKey:@"task_name"]);
		}
		for(NSDictionary *item in responseFromServer[@"done"]) {
			[done addObject:[item objectForKey:@"task_name"]];
			[taskID setObject:[item objectForKey:@"_id"] forKey:[item objectForKey:@"task_name"]];
			[taskPoints setObject:[item objectForKey:@"points"] forKey:[item objectForKey:@"task_name"]];
			[addedDate setObject:[item objectForKey:@"added_on"] forKey:[item objectForKey:@"task_name"]];
//			NSLog(@"%@",[item objectForKey:@"task_name"]);
		}
		taskList = [[NSMutableDictionary alloc] init];
		[taskList setObject:backlog forKey:@"Backlog"];
		[taskList setObject:waiting forKey:@"Waiting"];
		[taskList setObject:doing forKey:@"Doing"];
		[taskList setObject:done forKey:@"Done"];
//		NSLog(@"lista: %@", taskList);
//		NSLog(@"taskID list: %@", taskID);
		keyArray = [taskList allKeys];
		valueArray = [taskList allValues];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [keyArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [valueArray[section] count];
	
}

-(UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];
	
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
	}
	
//	if ([keyArray[indexPath.section] isEqualToString:@"done"])
//		[cell.textLabel setText:@"done"];
//		NSLog(@"e done!");

	NSArray *projectListPerOrg =[taskList valueForKey:keyArray[indexPath.section]];
	cell.textLabel.text = projectListPerOrg[indexPath.row];

	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return [keyArray objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//	NSString *currentSection = keyArray[indexPath.section];
//	
//	for(NSDictionary *item in publicTimeline) {
//		NSString *orgName = item[@"organization_name"];
//		if([orgName isEqualToString:currentSection]) {
//			for(NSDictionary *projName in [item objectForKey:@"organization_projects"])
//			{
//				NSString *currentProject = projName[@"project_name"];
//				if([cell.textLabel.text isEqualToString:currentProject])
//				{
//					orgID = projName[@"_id"];
//					NSLog(@"a gasit");
//					break;
//				}
//			}
//			break;
//		}	
//	}
//	//	NSLog(@"Row Selected = %@",indexPath);
//	NSLog(@"Proiectul are id-ul = %@", orgID);
//	NSArray *projectListPerOrg =[taskList valueForKey:keyArray[indexPath.section]];
	
//	SingleTaskViewController *singleTaskViewController = [[SingleTaskViewController alloc] init];
//	[singleTaskViewController.taskName setText:(@"merge sa trimit")];//projectListPerOrg[indexPath.row];
	for (NSString *key in [taskID allKeys]) {
		if ([key isEqualToString:cell.textLabel.text]) {
			results = [taskID objectForKey:key];
//			NSLog(@"results: %@", results);
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
			
		self.definesPresentationContext = YES; //self is presenting view controller
		
		singleTaskViewController.view.backgroundColor = self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];//[UIColor colorWithWhite:1.0 alpha:0.5];
		singleTaskViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
	}
	else if([segue.identifier isEqualToString:@"addNewTask"]){
		singleTaskViewController.taskName = @"Add New Task";
		self.definesPresentationContext = YES; //self is presenting view controller
		
		singleTaskViewController.
		singleTaskViewController.view.backgroundColor = self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];//[UIColor colorWithWhite:1.0 alpha:0.5];
		singleTaskViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
	}
}

- (IBAction)addNewTask:(id)sender {
	[self performSegueWithIdentifier:@"addNewTask" sender:self.view];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//	//	NSLog(@"prepareForSegue: %@", segue.identifier);
//	
//	if([segue.identifier isEqualToString:@"goToSingleTask"]){
//		SingleTaskViewController *singleTaskViewController = segue.destinationViewController;
//		singleTaskViewController.taskTitle =
//		
//}
//}

- (NSManagedObjectContext *) managedObjectContext {
	NSManagedObjectContext *context = nil;
	id delegate = [[UIApplication sharedApplication] delegate];
	if ([delegate performSelector:@selector(managedObjectContext)]) {
		context = [delegate managedObjectContext];
	}
	return context;
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
