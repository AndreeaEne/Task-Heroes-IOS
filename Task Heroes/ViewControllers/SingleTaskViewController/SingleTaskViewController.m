//
//  SingleTaskViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 23/05/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

/** This view contains information about a single task. **/

#import "SingleTaskViewController.h"
#import "SingleProjectViewController.h"
#import <CoreData/CoreData.h>

@interface SingleTaskViewController ()
@end

@implementation SingleTaskViewController

NSDictionary *responseFromServer;	// All data received from server.
NSMutableArray *content;			// The content of the picker view.
NSManagedObjectID *moID;            // ID of the current object.
NSString *userID;					// ID of the current user.
bool pressed;						// Saves if the picker has been pressed or not.

@synthesize taskName, setTaskName, userData;

- (void)viewDidLoad {
	NSLog(@"SingleTaskViewController loaded.");
	[super viewDidLoad];
	
	[self getUserData];
	[self parseDate];
	[self printCoreData];
	
	// Checks if there is no task added.
	if(_changeTask == 1) {
		
		// Hides all buttons.
		_moveToButton.hidden = TRUE;
		_eraseButton.hidden = TRUE;
		_pointsField.hidden = TRUE;
		_pointsText.hidden = TRUE;
		_addedOnText.hidden = TRUE;
		_iVolunteerButton.hidden = TRUE;
		
		// And shows a new field to add a new ones.
		_addTaskNameField.hidden = FALSE;
		_addTaskNameLabel.hidden = FALSE;
	}
	
	/*
		Change the color of the background.
	 
		UIColor *color = [UIColor colorWithRed:0.251 green:0.62 blue:0.765 alpha:1];
		self.view.backgroundColor = color;
	 */
	
	// Set the name of the 4 lists.
	content = [NSMutableArray arrayWithObjects:@"Backlog", @"Waiting", @"Doing", @"Done", nil];
	
	// Remove only the one the project is from.
	[content removeObject:_projectFrom];
	_projectTo = content[0];
	
	// Get the points and set them to 2 decimal float.
	float auxPoints = [_points floatValue];
	_pointsField.text = [NSString stringWithFormat: @"%.2f", auxPoints];
	
	[_toSectionPicker setAlpha:0];
	[setTaskName setText:taskName];
	
	// Set the size of the popup.
	self.popUpView.layer.cornerRadius = 5;
	self.popUpView.layer.shadowOpacity = 0.8;
	self.popUpView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[self.view endEditing:YES];
	[super touchesBegan:touches withEvent:event];
}

// Save the info about a single task.
- (void) saveTask {
	if(_changeTask == 1) {
		NSLog(@"projectID: %@, taskIDL %@", _projectID, _taskID);
		
		// Begin by creating POST's body as an NSString, and convert it to NSData.
		NSString *post = [NSString stringWithFormat:@"task=%@&project_id=%@&org=%@&mobile=1", _addTaskNameField.text, _projectID, _orgID];
		NSLog(@"The task named: %@, projectID: %@, organisationID: %@", _addTaskNameField.text, _projectID, _orgID);
		NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
		
		// Read the postData's length, so it can be passed in the request.
		NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
		
		// Create a NSMutableURLRequest, and include the postData
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
		[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/add/backlog"]];
		[request setHTTPMethod:@"POST"];
		[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
		[request setHTTPBody:postData];
		
		
		NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
		NSError *jsonParsingError = nil;
		responseFromServer = [NSJSONSerialization JSONObjectWithData:response
															 options:0 error:&jsonParsingError];
		// NSLog(@"Response: %@", responseFromServer);
	}
	else {
		NSError *fetchError = nil;
		// Create the POST's body as an NSString, and convert it to NSData.
		NSString *post = [NSString stringWithFormat:@"project_id=%@&task_id=%@&from=%@&to=%@", _projectID, _taskID, [_projectFrom lowercaseString], [_projectTo lowercaseString]];
		NSLog(@"projectID: %@, taskID: %@, From: %@, To: %@", _projectID, _taskID, [_projectFrom lowercaseString], [_projectTo lowercaseString]);
		NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
		
		// Read the postData's length, so it can be passed in the request.
		NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
		
		// Create an NSMutableURLRequest, and include the postData
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
		[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/mobile/move/to"]];
		[request setHTTPMethod:@"POST"];
		[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
		[request setHTTPBody:postData];
		
		
		NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
		NSError *jsonParsingError = nil;
		responseFromServer = [NSJSONSerialization JSONObjectWithData:response
															 options:0 error:&jsonParsingError];
		NSLog(@"Response: %@", responseFromServer);
		
		if (!responseFromServer) {
			NSLog(@"Error parsing JSON: %@", fetchError);
		}
		else {
			//TODO: Warning.
		}
	}
}

#pragma mark - Picker
// Picker has only one component.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

// The rows in picker are stored in content.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [content count];
}

// Set the the titles in picker.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [content objectAtIndex:row];
}

// Selected value in picker to move in another list.
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	_projectTo = [content objectAtIndex:row];
	//	NSLog(@"ProjectTO = %@", _projectTo);
}

// Display picker when  the button is pressed.
- (IBAction)selectPicker:(id)sender {
	pressed = 1;
	[UIView animateWithDuration:0.6 delay:0. options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[_toSectionPicker setAlpha:1];
	} completion:nil];
}

#pragma mark - Move Task
// Window that appears after moving a task.
- (IBAction)closePopup:(id)sender {
	if (pressed == 1) {
		[self saveTask];
		NSString *messageString = [NSString stringWithFormat:@"The task %@ has been moved to %@", taskName, _projectTo];
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Save"
							  message:messageString
							  delegate:self
							  cancelButtonTitle:nil
							  otherButtonTitles:@"OK", nil];
		[alert show];
		
		[self removeAnimate];
		[self dismissViewControllerAnimated:YES completion:nil];
	}
	else if(_changeTask == 1) {
		[self saveTask];
		NSString *messageString = [NSString stringWithFormat:@"The task %@ has been added to Backlog", _addTaskNameField.text];
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Save"
							  message:messageString
							  delegate:self
							  cancelButtonTitle:nil
							  otherButtonTitles:@"OK", nil];
		[alert show];
		
		[self removeAnimate];
		[self dismissViewControllerAnimated:YES completion:nil];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Save"
							  message:@"Please select the list where you want to move the task!"
							  delegate:self
							  cancelButtonTitle:nil
							  otherButtonTitles:@"OK", nil];
		[alert show];
	}
}

// Window pops in animation.
- (void)showAnimate {
	self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
	self.view.alpha = 0;
	[UIView animateWithDuration:.25 animations:^{
		self.view.alpha = 1;
		self.view.transform = CGAffineTransformMakeScale(1, 1);
	}];
}

// Window fades away animation.
- (void)removeAnimate {
	[UIView animateWithDuration:.25 animations:^{
		self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
		self.view.alpha = 0.0;
	} completion:^(BOOL finished) {
		if (finished) {
			[self.view removeFromSuperview];
		}
	}];
}

// Dismiss the view.
- (IBAction)closePopupBack:(id)sender {
	[self removeAnimate];
	[self dismissViewControllerAnimated:YES completion:nil];
}

// Shows the view.
- (void)showInView:(UIView *)aView animated:(BOOL)animated {
	[aView addSubview:self.view];
	if (animated) {
		[self showAnimate];
	}
}

#pragma mark - Delete task
// Delete a taks
- (IBAction)eraseButton:(id)sender {
	NSError *fetchError = nil;
	NSString *post = [NSString stringWithFormat:@"project_id=%@&task_id=%@", _projectID, _taskID];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/mobile/erase/task"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSError *jsonParsingError = nil;
	responseFromServer = [NSJSONSerialization JSONObjectWithData:response
														 options:0 error:&jsonParsingError];
	NSLog(@"Response: %@", responseFromServer);
	
	if (!responseFromServer) {
		NSLog(@"Error parsing JSON: %@", fetchError);
	}
	else {
		// TODO: Warning
	}
	NSString *messageString = [NSString stringWithFormat:@"The task %@ has been erased", taskName];
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Save"
						  message:messageString
						  delegate:self
						  cancelButtonTitle:nil
						  otherButtonTitles:@"OK", nil];
	[alert show];
	[self removeAnimate];
	[self dismissViewControllerAnimated:YES completion:nil];
}

// Sets the current date in the specified format.
- (void)parseDate {
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
	
	NSDate *date = [dateFormat dateFromString:_addedDate];
	NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc] init];
	[newDateFormatter setDateFormat:@"dd MMMM yyyy"];
	
	NSString *newString = [newDateFormatter stringFromDate:date];
	[_addedOn setText:newString];
}

// Gets the ID of the current user.
- (void)getUserData {
	userData = (UserData *)[self.managedObjectContext
							existingObjectWithID:moID
							error:nil];
	userID = userData.id_user;
}

- (NSManagedObjectContext *)managedObjectContext {
	NSManagedObjectContext *context = nil;
	id delegate = [[UIApplication sharedApplication] delegate];
	if ([delegate performSelector:@selector(managedObjectContext)]) {
		context = [delegate managedObjectContext];
	}
	return context;
}

#pragma mark - Volunteer to a task.
// Adds the user to a task.
- (IBAction)iVolunteerAction:(id)sender {
	NSError *fetchError = nil;
	NSString *post = [NSString stringWithFormat:@"user_id=%@&task_id=%@", userID, _taskID];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/mobile/i/volunteer"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSError *jsonParsingError = nil;
	responseFromServer = [NSJSONSerialization JSONObjectWithData:response
														 options:0 error:&jsonParsingError];
	NSLog(@"Response: %@", responseFromServer);
	
	NSString *messageString = [NSString stringWithFormat:@"You are now volunteering to %@", taskName];
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"You are a HERO!"
						  message:messageString
						  delegate:self
						  cancelButtonTitle:@"Cancel"
						  otherButtonTitles:@"OK", nil];
	
	if (!responseFromServer) {
		NSLog(@"Error parsing JSON: %@", fetchError);
	}
	else {
		[alert show];
	}
}

#pragma mark - Get info from CoreData.
- (void)printCoreData {
	userData = (UserData *)[self.managedObjectContext
							existingObjectWithID:moID
							error:nil];
	
	NSString *done = userData.doneTasks;
	NSString *undone = userData.undoneTasks;
	
	if ([undone containsString:_taskID]) {
		[_iVolunteerButton setTitle:@"This is your task! " forState:UIControlStateNormal];
		_iVolunteerButton.enabled = false;
		[_iVolunteerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	}
	else if ([done containsString:_taskID]) {
		[_iVolunteerButton setTitle:@"Done" forState:UIControlStateNormal];
		_iVolunteerButton.enabled = false;
		[_iVolunteerButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
	}
}

- (void)setupFetchedResultsController {
	NSString *entityName = @"UserData";
	NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);

	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];

	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
																		managedObjectContext:self.managedObjectContext
																		  sectionNameKeyPath:nil
																			cacheName:nil];
	[self performFetch];
}

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
	NSLog(@"array: %@\n, Conturi: %lu", array, (unsigned long)[array count]);
	for (NSManagedObject *managedObject in array) {
		moID = [managedObject objectID];
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end
