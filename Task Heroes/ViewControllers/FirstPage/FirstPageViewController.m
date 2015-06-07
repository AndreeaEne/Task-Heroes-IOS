//
//  ViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 16/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import "FirstPageViewController.h"
#import "SWRevealViewController.h"



@interface FirstPageViewController ()
@end


@implementation FirstPageViewController

- (void)viewDidLoad {
	NSLog(@"FirstPageViewController loaded.");
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//	self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
	
	[[self navigationController] setNavigationBarHidden:YES animated:YES];
	
	//UIViewController *rmvc = (UINavigationController *)[[self revealViewController] frontViewController];
	//NSLog(@"%@", [rmvc class]);
	
	//Deschide Dashboard <3
	//	SWRevealViewController *rmvc = (SWRevealViewController *)[[self revealViewController] rearViewController];
	//	[rmvc performSegueWithIdentifier:@"segueToProjects" sender:rmvc];
	
	
}

-(void) viewWillAppear:(BOOL)animated{
	[[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
