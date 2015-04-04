//
//  DashboardViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 22/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import "DashboardViewController.h"
#import "SWRevealViewController.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController


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
    
    SWRevealViewController *revealController = [self revealViewController];
    
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
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
		//home button press programmatically
		UIApplication *app = [UIApplication sharedApplication];
		[app performSelector:@selector(suspend)];
		
		//wait 2 seconds while app is going background
		[NSThread sleepForTimeInterval:2.0];
		
		//exit app when app is in background
		exit(0);
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
