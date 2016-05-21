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
#import <CoreData/CoreData.h>

/** This view contains the table from RevealViewController. **/

NSManagedObjectID *moID;

@interface TableViewController ()

@end

@implementation TableViewController {
	NSArray *content;
	__weak IBOutlet UIImageView *profileImageView;
}

- (void)viewDidLoad {
	NSLog(@"TableViewController loaded.");
	[super viewDidLoad];

	self.view.backgroundColor = [UIColor blackColor];
	
	self->profileImageView.layer.cornerRadius = self->profileImageView.frame.size.width / 2;
	self->profileImageView.clipsToBounds = YES;
	
	self->profileImageView.layer.borderWidth = 3.0f;
	self->profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
	
	content = [NSArray arrayWithObjects:@"Dashboard", @"Volunteers", @"Organisations", @"Projects", @"Edit User Profile", @"Log Out", nil];
}

# pragma mark - TableView
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

#pragma mark - AlertView.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != 0)  /* 0 == Cancel button*/ {
		_userData = (UserData *)[self.managedObjectContext
								 existingObjectWithID:moID
								 error:nil];
		_userData.id_user = @"0";
		[self.managedObjectContext save:nil];
		
		[self performSegueWithIdentifier: @"LogOut" sender: self];
		}
}

#pragma mark - Segue.
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

#pragma mark - Avatar image.
- (void) viewWillAppear:(BOOL)animated {
	[self setNewImage:(_avatar.image)];
	[self setupFetchedResultsController];
}

- (void) setNewImage: (UIImage*) setimage {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"Default.jpg"];
	NSData *imgData = [NSData dataWithContentsOfFile:getImagePath];
	_avatar.image = [[UIImage alloc] initWithData:imgData];
}

- (void) setupFetchedResultsController {
	// 1 - Entity name
	NSString *entityName = @"UserData";
 
	// 2 - Request  Entity
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
	
	// 3 - Sort it if you want
	request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"first_name"
																					 ascending:YES
																					  selector:@selector(localizedCaseInsensitiveCompare:)]];
 
	// 4 - Fetch it
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
																		managedObjectContext:self.managedObjectContext
																		  sectionNameKeyPath:nil
																				   cacheName:nil];
	[self performFetch];
}

#pragma mark - CoreData.
-(void)performFetch {
	NSManagedObjectContext *moc = [self managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"UserData" inManagedObjectContext:moc];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];
 
	NSError *error;
	NSArray *array = [moc executeFetchRequest:request error:&error];
	if (array == nil) {
		//TODO: Deal with error.
	}
	
	for (NSManagedObject *managedObject in array) {
		moID = [managedObject objectID];
	}
}

- (NSManagedObjectContext *)managedObjectContext {
	NSManagedObjectContext *context = nil;
	id delegate = [[UIApplication sharedApplication] delegate];
	if ([delegate performSelector:@selector(managedObjectContext)]) {
		context = [delegate managedObjectContext];
	}
	return context;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
