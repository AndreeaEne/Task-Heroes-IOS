//
//  EditUserViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 15/04/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

/** This view contains information about the user and has the option to update it. **/

#import "EditUserViewController.h"
#import "SWRevealViewController.h"
#import "UIViewController+NavigationBar.h"
#import <CoreData/CoreData.h>

NSString *id_user;	// ID of the current user.

@interface EditUserViewController ()

@end

@implementation EditUserViewController

@synthesize userData;

- (void)viewDidLoad {
	NSLog(@"EditUserViewController loaded.");
	[super viewDidLoad];
	[self setupNavigationBar];
	[self setPlaceHolderColor];
}

// Change the color of the placeholder image.
- (void)setPlaceHolderColor {
	[self.password setValue:[UIColor whiteColor]
					forKeyPath:@"_placeholderLabel.textColor"];
	[self.verifyPassword setValue:[UIColor whiteColor]
					forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - NavigationBar.
- (void)setupNavigationBar {
	[[UIApplication sharedApplication] setStatusBarHidden: NO];
	[self.navigationController setNavigationBarHidden: NO];
	
	[self setTitle:@"Edit User Profile"];
	[self setRevealButtonWithImage: [UIImage imageNamed:@"reveal-icon.png"]];
	[self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
}

// Hide Keyboard when pressing out of it.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[self.view endEditing:YES];
	[super touchesBegan:touches withEvent:event];
}

#pragma mark - Update info.
// Save the information that has been change and send it to the server.
- (IBAction)saveButton:(id)sender {
	NSString *post = [NSString stringWithFormat:@"first_name=%@&last_name=%@&email=%@&_id=%@", _firstName.text, _lastName.text, _email.text, id_user];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/update/user"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];

	NSURLResponse *requestResponse;
	NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
	
	NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
	
	// Old and new password.
	NSString *postPass = [NSString stringWithFormat:@"old=%@&new=%@&_id=%@", _password.text, _verifyPassword.text, id_user];
	NSData *postDataPass = [postPass dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLengthPass = [NSString stringWithFormat:@"%lu", (unsigned long)[postDataPass length]];
	
	// Send it to the server.
	NSMutableURLRequest *requestPass = [[NSMutableURLRequest alloc] init];
	[requestPass setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/change/password"]];
	[requestPass setHTTPMethod:@"POST"];
	[requestPass setValue:postLengthPass forHTTPHeaderField:@"Content-Length"];
	[requestPass setHTTPBody:postDataPass];
	
	// Get the response.
	NSURLResponse *requestResponsePass;
	NSData *requestHandlerPass = [NSURLConnection sendSynchronousRequest:requestPass returningResponse:&requestResponsePass error:nil];
	
	NSString *requestReplyPass = [[NSString alloc] initWithBytes:[requestHandlerPass bytes] length:[requestHandlerPass length] encoding:NSASCIIStringEncoding];
	
	//TODO: Doesn't check if the sent text is null.
	BOOL log = false;
	BOOL passLog = false;
	if([requestReply isEqualToString:@"{\"msg\":\"success update!\"}"] || ![requestReply isEqualToString:@""]) {
		if(![_lastName.text isEqualToString:@""] || ![_firstName.text isEqualToString:@""] || ![_email.text isEqualToString:@""]){
			log = true;
			NSLog(@"ie bine");
		}
	}
	if(![_password.text isEqual:@""] && ![_verifyPassword.text isEqual:@""])
		if([requestReplyPass isEqualToString:@"{\"msg\":\"update succesful\"}"] || ![requestReplyPass isEqualToString:@""]) {
			passLog = true;
		}
	
	// Set an alert view to show if the info has been updated.
	UIAlertView *alert;
	if(log == true && passLog == true) {
		alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"The user info and the pass have been succesfully updated." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alert show];
	}
	else if (log == false & passLog == true) {
		alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"The pass has been succesfully updated." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alert show];
	}
	else if (log == true & passLog == false) {
		alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"The user info has been succesfully updated." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alert show];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"The user info has not been updated." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alert show];
	}
	
}

#pragma mark - Get info from CoreData.
- (void)getUserData {
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserData"];
	NSManagedObjectContext *context = [self managedObjectContext];
	NSError *fetchError = nil;
	NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
	
	if (!fetchError) {
		for (NSManagedObject *managedObject in result) {
			NSString *email_user = [managedObject valueForKey:@"email"];
			NSString *last_name_user = [managedObject valueForKey:@"last_name"];
			NSString *first_name_user = [managedObject valueForKey:@"first_name"];
			id_user = [managedObject valueForKey:@"id_user"];
			_firstName.text = first_name_user;
			_lastName.text = last_name_user;
			_email.text = email_user;
		}
		
	} else {
		NSLog(@"Error fetching data.");
		NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
	}
	
	NSError *error;
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	if (fetchedObjects == nil) {
		//TODO: Handle the error.
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

- (void) viewWillAppear:(BOOL)animated {
	[self getUserData];
	[self setupFetchedResultsController];
}

- (void) setupFetchedResultsController
{
	// 1 - Decide what Entity you want
	NSString *entityName = @"UserData";
 
	// 2 - Request that Entity
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
	
	// 3 - Sort it.
	request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"first_name"
																					 ascending:YES
																					  selector:@selector(localizedCaseInsensitiveCompare:)]];
	// 4 - Fetch it.
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
																		managedObjectContext:self.managedObjectContext
																		  sectionNameKeyPath:nil
																				   cacheName:nil];
}


@end
