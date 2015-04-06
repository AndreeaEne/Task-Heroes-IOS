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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
