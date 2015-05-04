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

NSArray *projectName;
NSArray *publicTimeline;

@interface ProjectsViewController ()

@end

@implementation ProjectsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self setupNavigationBar];
	[self.projectsTable reloadData];
	[self.projectsTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark navigation bar

- (void) setupNavigationBar {
	[[UIApplication sharedApplication] setStatusBarHidden: NO];
	[self.navigationController setNavigationBarHidden: NO];
	
	[self setTitle:@"Projects"];
	[self setRevealButtonWithImage: [UIImage imageNamed:@"reveal-icon.png"]];
}

- (void) getProjects {
	//We begin by creating our POST's body (ergo. what we'd like to send) as an NSString, and converting it to NSData.
	//NSString *post = [NSString stringWithFormat:@"username=%@&pass=%@", emailField.text, passField.text];
	//NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	//Next up, we read the postData's length, so we can pass it along in the request.
	//NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	//Now that we have what we'd like to post, we can create an NSMutableURLRequest, and include our postData
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"http://localhost:8081/mobile/get/projects"]];
	[request setHTTPMethod:@"POST"];
	//[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	//[request setHTTPBody:postData];
	
	//Send the request, and read the reply:
	NSURLResponse *requestResponse;
	NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
	
	NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
	//requestReply = [NSString stringWithFormat:@"msg"];
	
//		NSArray *components = [requestReply componentsSeparatedByString:@"},"];
		NSLog(@"\nRequest: %@",requestReply);
	
	//JSON Parse

	NSData *response = [NSURLConnection sendSynchronousRequest:request
											 returningResponse:nil error:nil];
	NSError *jsonParsingError = nil;
	publicTimeline = [NSJSONSerialization JSONObjectWithData:response
															  options:0 error:&jsonParsingError];
	
	NSDictionary *project;

	for(int i=0; i < [publicTimeline count];i++)
	{
		project= [publicTimeline objectAtIndex:i];
		NSLog(@"Project Description: %@", [project objectForKey:@"project_description"]);
		projectName = [project objectForKey:@"project_name"];
		NSLog(@"Project_name: %@", projectName );
		NSLog(@"Project manager: %@", [project objectForKey:@"project_manager"]);
		NSLog(@"_id: %@", [project objectForKey:@"_id"]);
		NSLog(@"project_members: %@", [project objectForKey:@"project_members"]);
//		NSDictionary *project_members = [project objectForKey:@"project_members"];
//		for (int j=0; j < [project_members count]; j++) {
//			NSLog(@"Is this working? : %@", project_members);}
	}
}

- (NSInteger)ProjectsTable:(UITableView *) ProjectsTable
 numberOfRowsInSection:(NSInteger)section
{
	return [projectName count];
}


- (void) viewWillAppear:(BOOL)animated {
	[self getProjects];
}


-(UITableViewCell *)ProjectsTable:(UITableView *)ProjectsTable
		cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [ProjectsTable dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	NSDictionary *tempDictionary= [publicTimeline objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [tempDictionary objectForKey:@"project_name"];
	
	if([tempDictionary objectForKey:@"_id"] != NULL)
	{
		cell.detailTextLabel.text = [NSString stringWithFormat:@"Rating: %@ of 5",[tempDictionary   objectForKey:@"_id"]];
	}
	else
	{
		cell.detailTextLabel.text = [NSString stringWithFormat:@"Not Rated"];
	}
	
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
