//
//  DashboardViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 22/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import "DashboardViewController.h"
#import "SWRevealViewController.h"
#import "FirstPageViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

float points;
NSString *id_user;
NSDictionary *responseFromServer;
NSMutableArray *task_name;

NSArray *keyArray, *valueArray;

@interface DashboardViewController ()

@end

@implementation DashboardViewController

@synthesize scrollView;
@synthesize pageControl;
@synthesize imageArray;

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    SWRevealViewController *sideBar = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
//    
//    
//    [self.navigationController pushViewController:sideBar animated:YES];
//    SWRevealViewController *revealController = self.revealViewController;
//    [revealController.view addGestureRecognizer:revealController.panGestureRecognizer];
//    
//    // Do any additional setup after loading the view.
//     //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//    
//     [self.tableView setContentSize:CGSizeMake(self.tableView.frame.size.width, 150 + 6 * 50)];
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self getPoints];
	[self getData];
	
}

- (void) getPoints {
	// Fetching
	NSManagedObjectContext *context = [self managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserData"];

	// Execute Fetch Request
	NSError *fetchError = nil;
	NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
	if (!fetchError) {
		for (NSManagedObject *managedObject in result) {
			NSString *auxPoints = [managedObject valueForKey:@"points"];
			id_user = [managedObject valueForKey:@"id_user"];
			points = [auxPoints floatValue];
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
	_points.text = [NSString stringWithFormat: @"You have %.2f points", points];
	
	self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:14.0f/255.0f green:108.0f/255.0f blue:164.0f/255.0f alpha:1.0f];
	self.navigationController.navigationBar.translucent = NO;
	
	_wallImage.image = [UIImage imageNamed:@"wallpaper2.jpg"];
	
	self.dataTest = @[@"Data1", @"Data2", @"Data3", @"Data4", @"Data5"];
	NSArray *titles = @[@"Backlog", @"Waiting", @"Doing", @"Done"];
    
    SWRevealViewController *revealController = [self revealViewController];
	
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
	[[[self navigationItem] leftBarButtonItem] setTintColor:[UIColor whiteColor]];

	imageArray = [[NSArray alloc] initWithObjects:@"graySection.png", @"graySection.png", @"graySection.png", @"graySection.png", nil];
	
	for (int i = 0; i < [imageArray count]; i++) {
		//We'll create an imageView object in every 'page' of our scrollView.
		CGRect frame;
		frame.origin.x = self.scrollView.frame.size.width * i;
		frame.origin.y = 0;
		frame.size = self.scrollView.frame.size;
		
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
		imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:i]];

		UILabel *taskSection = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 90, frame.origin.y, 97, 21)];
		[taskSection setText:[NSString stringWithFormat:@"%@",[titles objectAtIndex:i]]];
		
		[self.scrollView addSubview:imageView];
		[self.scrollView addSubview:taskSection];
		
	}
//	Set the content size of our scrollview according to the total width of our imageView objects.
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [imageArray count], scrollView.frame.size.height);
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [task_name count];
	
}

-(UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];
	
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
	}
	
	cell.textLabel.text = task_name[indexPath.row];
	
	
	return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
	// Update the page when more than 50% of the previous/next page is visible
	CGFloat pageWidth = self.scrollView.frame.size.width;
	int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	self.pageControl.currentPage = page;
}

- (IBAction)quitButton:(id)sender {
	//show confirmation message to user
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Confirmation"
													message:@"Do you want to Log Out?"
												   delegate:self
										  cancelButtonTitle:@"Cancel"
										  otherButtonTitles:@"OK", nil];
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != 0)  // 0 == the cancel button
	{
		[self.navigationController popToRootViewControllerAnimated:YES];
		//UINavigationController *nav = self.navigationController;
		//[nav pushViewController:UINavigationControllerOperationNone animated:YES];
	}
}

- (void) getData {
	NSError *fetchError = nil;
	
	//We begin by creating our POST's body as an NSString, and converting it to NSData.
	NSString *post = [NSString stringWithFormat:@"_id=%@", id_user];
	NSLog(@"iduser: %@", id_user);
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	//Next up, we read the postData's length, so we can pass it along in the request.
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	
	//Now that we have what we'd like to post, we can create an NSMutableURLRequest, and include our postData
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/get/undonetasks"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSError *jsonParsingError = nil;
	responseFromServer = [NSJSONSerialization JSONObjectWithData:response
														 options:0 error:&jsonParsingError];
	NSLog(@"Response: %@", responseFromServer);
	task_name = [[NSMutableArray alloc] init];
	
	if (!responseFromServer) {
		NSLog(@"Error parsing JSON: %@", fetchError);
	}
	else {
		
		for(NSDictionary *item in responseFromServer) {
			NSLog(@"item: %@ ", item[@"task_name"]);
			[task_name addObject:item[@"task_name"]];
		}
		NSLog(@"taskName: %@", task_name);
	}
}

- (NSManagedObjectContext *) managedObjectContext {
	NSManagedObjectContext *context = nil;
	id delegate = [[UIApplication sharedApplication] delegate];
	if ([delegate performSelector:@selector(managedObjectContext)]) {
		context = [delegate managedObjectContext];
	}
	return context;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
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
