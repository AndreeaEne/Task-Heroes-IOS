//
//  SingeProjectViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 09/05/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

#import "SingleProjectViewController.h"
#import "AppDelegate.h"

NSDictionary *responseFromServer;
NSMutableDictionary *taskList;
NSMutableArray *task_name;

NSArray *keyArray, *valueArray;

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

	tasksTable.dataSource = self;
	tasksTable.delegate = self;
	
	task_name = [[NSMutableArray alloc] init];
	
	setProjectTitle.text = projectTitle;
	_wallImage.image = [UIImage imageNamed:@"wallpaper2.jpg"];
	
//	NSLog(@"projectTitle in SingleProject: %@", projectTitle);
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) getData {
	NSError *fetchError = nil;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserData"];
	NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
	
	//We begin by creating our POST's body (ergo. what we'd like to send) as an NSString, and converting it to NSData.
	NSString *post = [NSString stringWithFormat:@"_id=%@", projectID];
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
	NSLog(@"Response: %@", responseFromServer);
	
	if (!responseFromServer) {
		NSLog(@"Error parsing JSON: %@", fetchError);
	}
	else {
		NSMutableArray *backlog = [[NSMutableArray alloc] init];
		NSMutableArray *waiting = [[NSMutableArray alloc] init];
		NSMutableArray *doing = [[NSMutableArray alloc] init];
		NSMutableArray *done = [[NSMutableArray alloc] init];
		for(NSDictionary *item in responseFromServer[@"backlog"]) {
			[backlog addObject:[item objectForKey:@"task_name"]];
//			NSLog(@"%@",[item objectForKey:@"task_name"]);
		}
		for(NSDictionary *item in responseFromServer[@"waiting"]) {
			[waiting addObject:[item objectForKey:@"task_name"]];
//			NSLog(@"%@",[item objectForKey:@"task_name"]);
		}
		for(NSDictionary *item in responseFromServer[@"doing"]) {
			[doing addObject:[item objectForKey:@"task_name"]];
//			NSLog(@"%@",[item objectForKey:@"task_name"]);
		}
		for(NSDictionary *item in responseFromServer[@"done"]) {
			[done addObject:[item objectForKey:@"task_name"]];
//			NSLog(@"%@",[item objectForKey:@"task_name"]);
		}
		taskList = [[NSMutableDictionary alloc] init];
		[taskList setObject:backlog forKey:@"Backlog"];
		[taskList setObject:waiting forKey:@"Waiting"];
		[taskList setObject:doing forKey:@"Doing"];
		[taskList setObject:done forKey:@"Done"];
		NSLog(@"lista: %@", taskList);
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
