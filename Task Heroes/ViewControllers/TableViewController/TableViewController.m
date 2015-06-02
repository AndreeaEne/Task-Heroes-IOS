//
//  TableViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 20/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import "TableViewController.h"
#import "SWRevealViewController.h"
#import "MembersViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController {
	NSArray *content;
	
	__weak IBOutlet UIImageView *profileImageView;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	//NSLog(@"avatar.image = %@", _avatar.image);
	//[self setNewImage:(_avatar.image)];
	
	//NSLog(@"avatar.image = %@", _avatar.image);
	// Do any additional setup after loading the view.
	self.view.backgroundColor = [UIColor blackColor];
	
	self->profileImageView.layer.cornerRadius = self->profileImageView.frame.size.width / 2;
	self->profileImageView.clipsToBounds = YES;
	
	self->profileImageView.layer.borderWidth = 3.0f;
	self->profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
	
	
	//	[[self navigationController] setNavigationBarHidden:NO animated:YES];
	content = [NSArray arrayWithObjects:@"Dashboard", @"Volunteers", @"Organisations", @"Projects", @"Edit User Profile", @"Log Out", nil];
	//	if([content isEqual: @"Members"]) {
	//	[self performSegueWithIdentifier: @"segueToMembers" sender: self];
	//	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [content count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *simpleTableIdentifier = @"SimpleTableCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
	}
	
	cell.textLabel.text = [content objectAtIndex:indexPath.row];
	return cell;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	if([cell.textLabel.text isEqual: @"Volunteers"]) {
		[self performSegueWithIdentifier: @"segueToMembers" sender: self];
		
	}
	else if([cell.textLabel.text isEqual: @"Organisations"]) {
		[self performSegueWithIdentifier: @"segueToOrganisationProfile" sender: self];
		
	}
	else if([cell.textLabel.text isEqual: @"Projects"]) {
		[self performSegueWithIdentifier: @"segueToProjects" sender: self];
		
	}
	else if([cell.textLabel.text isEqual: @"Dashboard"]) {
		[self performSegueWithIdentifier: @"segueToDashboard" sender: self];
	}
	else if([cell.textLabel.text isEqual: @"Edit User Profile"]) {
		[self performSegueWithIdentifier: @"segueToUser" sender: self];
	}
	else if([cell.textLabel.text isEqual: @"Log Out"]) {
		
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Confirmation"
														message:@"Do you want to Log Out?"
													   delegate:self
											  cancelButtonTitle:@"Cancel"
											  otherButtonTitles:@"OK", nil];
		[alert show];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != 0)  // 0 == Cancel button {
		[self performSegueWithIdentifier: @"LogOut" sender: self];
	//	}
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

- (void) viewWillAppear:(BOOL)animated {
	[self setNewImage:(_avatar.image)];
}

- (void) setNewImage: (UIImage*) setimage {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"Default.jpg"];
	NSData *imgData = [NSData dataWithContentsOfFile:getImagePath];
	_avatar.image = [[UIImage alloc] initWithData:imgData];
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
