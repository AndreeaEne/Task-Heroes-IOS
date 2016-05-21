//
//  RegisterViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 17/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import "RegisterViewController.h"
#import "HomeViewController.h"
#import <CoreData/CoreData.h>
#import "WelcomeViewController.h"

/** This view contains the register page. **/

@interface RegisterViewController ()

@end

@implementation RegisterViewController {
	NSManagedObjectID *moID;	// ID of the current object.
	NSArray *content;			// List of organisation types.
	BOOL checkSignUp;			// Checks if all data has been completed.
	NSString *selectedType;		// The organisation type that has been selected.
}

@synthesize firstnameField, lastnameField, emailField, passField, passConfirmField, OrgNameField, orgTypeButton, orgTypePicker, userData;

- (void)viewDidLoad {
	NSLog(@"RegisterViewController loaded.");
	[super viewDidLoad];

	selectedType = [[NSString alloc] init];
	[[self navigationController] setNavigationBarHidden:NO animated:YES];
	[orgTypePicker setAlpha:0];
	content = [NSArray arrayWithObjects:@"Youth", @"School", @"Religious", nil];
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
	BOOL didResign = [textField resignFirstResponder];
	if (!didResign) return NO;
	
	if ([textField isKindOfClass:[SOTextField class]])
		dispatch_async(dispatch_get_main_queue(),
					   ^ { [[(SOTextField *)textField nextField] becomeFirstResponder]; });
	return YES;
	
}

// Hide Keyboard.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
	[super touchesBegan:touches withEvent:event];
}

#pragma mark - PickerView.
- (IBAction)selectPicker:(id)sender {
	[UIView animateWithDuration:0.6 delay:0. options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[orgTypePicker setAlpha:1];
	} completion:nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [content count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [content objectAtIndex:row];
}

- (IBAction)signupButton:(id)sender {
	NSLog(@"Button Pressed");
	NSString *msg;
	checkSignUp = 0;
	
	BOOL email = [Globals validateEmail:[emailField text]];
	BOOL pass = [passField.text length] > 0;
	BOOL passConf = [passConfirmField.text length] > 0;
	BOOL firstName = [firstnameField.text length] > 0;
	BOOL lastName = [lastnameField.text length] > 0;
	BOOL orgName = [OrgNameField.text length] > 0;
	
//TODO: warning Dynamic messages!
	if (!email && !pass) {
		msg = @"Enter a valid email and password.";
	}
	else if (!email) {
		msg = @"Enter a valid email address.";
	}
	else if (!pass && !passConf) {
		msg = @"Enter a password. ";
	}
	else if(!firstName) {
		msg = @"Enter your First Name";
	}
	else if(!lastName) {
		msg = @"Enter your Last Name";
	}
	else if (!orgName) {
		msg = @"Enter the Organisation Name";
	}
	else if(pass != passConf) {
		msg = @"Password mismatch";
	}
	
	else if (pass && email && passConf && firstName && lastName && orgName) {
		checkSignUp = 1;
	}
	
	if ([msg length] > 0 ) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alert show];
	}
	
	if (checkSignUp == 1 && [self Register] == 1) {
		[self performSegueWithIdentifier: @"SignUp" sender: self];
	}
}

// Send the added data to server.
- (BOOL)Register {
	// Create our POST's body as an NSString, and convert it to NSData.
	NSString *post = [NSString stringWithFormat:@"Email=%@&Pass1=%@&First=%@&Last=%@", emailField.text, passField.text, firstnameField.text, lastnameField.text];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	// Read the postData's length, so it can passed along in the request.
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	
	// Create an NSMutableURLRequest, and include our postData.
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/register/user"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	
	// Send our request, and read the reply.
	NSURLResponse *requestResponse;
	NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
	
	NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
	
	BOOL log = false;
	if([requestReply isEqualToString:@"{\"success\":\"User Inserted successfuly!\"}"]) {
		log = true;
		
		// Create our POST's body as an NSString, and convert it to NSData.
		NSString *post = [NSString stringWithFormat:@"username=%@&pass=%@", emailField.text, passField.text];
		NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
		
		// Read the postData's length, so we can pass it along in the request.
		NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
		
		// Create an NSMutableURLRequest, and include the postData.
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
		[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/login/user"]];
		[request setHTTPMethod:@"POST"];
		[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
		[request setHTTPBody:postData];
		
		// Send the request, and read the reply.
		NSURLResponse *requestResponse;
		NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
		
		NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
		
		NSArray *components = [requestReply componentsSeparatedByString:@","];
		NSLog(@"%@",components);
		
		// Save data about User.
		NSString* id_user = [[[[requestReply componentsSeparatedByString:@"_id\":\""]objectAtIndex:1] componentsSeparatedByString:@"\""]objectAtIndex:0];
		
		// Save to Core Data.
		userData = (UserData *)[self.managedObjectContext
								existingObjectWithID:moID
								error:nil];
		userData.email = emailField.text;
		userData.last_name = lastnameField.text;
		userData.first_name = firstnameField.text;
		userData.doneTasks = nil;
		userData.undoneTasks = nil;
		userData.points = nil;
		userData.id_user = id_user;
		
		[self.managedObjectContext save:nil];
	}
	NSLog(@"requestReply: %@", requestReply);
	return log;
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
		NSLog(@"moID: %@", moID);
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

- (void) setupFetchedResultsController {
	// 1 - Decide what Entity you want.
	NSString *entityName = @"UserData";
 
	// 2 - Request that Entity.
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

- (void) viewWillAppear:(BOOL) animated {
	[super viewWillAppear:animated];
	[self setupFetchedResultsController];
}

#pragma mark - PickerView.
- (void)pickerView:(UIPickerView *)orgTypePicker didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	selectedType = [content objectAtIndex:row];
}

#pragma mark - Segue.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if([segue.identifier isEqualToString:@"SignUp"]){
		WelcomeViewController *sendTo = segue.destinationViewController;
		sendTo.orgType = selectedType;
		sendTo.orgName = OrgNameField.text;
		sendTo.user = emailField.text;
		sendTo.pass = passField.text;
	}
}


@end

@implementation SOTextField

@synthesize nextField;

@end



