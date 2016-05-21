//
//  ViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 16/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import "FirstPageViewController.h"
#import "SWRevealViewController.h"

/** This view contains the presentation of the app, with the signup and login buttons. **/

@interface FirstPageViewController ()
@end


@implementation FirstPageViewController

- (void)viewDidLoad {
	NSLog(@"FirstPageViewController loaded.");
	[super viewDidLoad];
	[[self navigationController] setNavigationBarHidden:YES animated:YES];
}

-(void) viewWillAppear:(BOOL)animated{
	[[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end
