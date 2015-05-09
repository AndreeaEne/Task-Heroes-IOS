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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;//[self.dataTest count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger numberOfRows = [self.dataTest count];
	return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell Identifier";
	
	[tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

	NSString *dataTest = [self.dataTest objectAtIndex:[indexPath row]];
	
	[cell.textLabel setText:dataTest];
	
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != 0)  // 0 == the cancel button
	{
		[self.navigationController popToRootViewControllerAnimated:YES];
		//UINavigationController *nav = self.navigationController;
		//[nav pushViewController:UINavigationControllerOperationNone animated:YES];
	}
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
