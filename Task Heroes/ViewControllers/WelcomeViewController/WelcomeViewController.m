//
//  WelcomeViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 06/04/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

#import "WelcomeViewController.h"
#import "SWRevealViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
	NSLog(@"WelcomeViewController loaded.");
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	[[self navigationController] setNavigationBarHidden:YES animated:YES];
	//[self performSegueWithIdentifier: @"segueToDashboard" sender: self];
}
- (IBAction)startButton:(id)sender {
	SWRevealViewController *rmvc = (SWRevealViewController *)[[self revealViewController] rearViewController];
	[rmvc performSegueWithIdentifier:@"segueToProjects" sender:rmvc];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
		SWRevealViewControllerSegue* rvcs = (SWRevealViewControllerSegue*) segue;
		SWRevealViewController* rvc = self.revealViewController;
		
		NSAssert( rvc != nil, @"oops! must have a revealViewController");
		NSAssert( [rvc.frontViewController isKindOfClass: [UINavigationController class]], @"oops! for this segue we want a permanent navigation controller in the front!");
		
		rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
			UINavigationController* nc = (UINavigationController*)rvc.frontViewController;
			
			[nc setViewControllers: @[ dvc ] animated: NO];
			
			[rvc setFrontViewPosition: FrontViewPositionLeft animated: YES];
		};
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
