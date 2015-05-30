//
//  SingleTaskViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 23/05/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

#import "SingleTaskViewController.h"
#import "SingleProjectViewController.h"
#import <CoreData/CoreData.h>

@interface SingleTaskViewController ()
@end

@implementation SingleTaskViewController

NSDictionary *responseFromServer;
NSMutableArray *content;
NSString *userID;
bool pressed;

@synthesize taskName, setTaskName;

- (void)viewDidLoad {
	[super viewDidLoad];
	[self getUserData];
//	NSLog(@"Added date: %@", _addedDate);
	[self parseDate];
	
	if(_changeTask == 1) {
		_moveToButton.hidden = TRUE;
		_eraseButton.hidden = TRUE;
		_pointsField.hidden = TRUE;
		_pointsText.hidden = TRUE;
		_addedOnText.hidden = TRUE;
		_addTaskNameField.hidden = FALSE;
		_addTaskNameLabel.hidden = FALSE;
		_iVolunteerButton.hidden = TRUE;
	}
	
//	UIColor *color = [UIColor colorWithRed:0.251 green:0.62 blue:0.765 alpha:1];
//	self.view.backgroundColor = color;
	
	content = [NSMutableArray arrayWithObjects:@"Backlog", @"Waiting", @"Doing", @"Done", nil];
	
	[content removeObject:_projectFrom];
	_projectTo = content[0];
//	[[self navigationController] setNavigationBarHidden:YES animated:YES];
	
	float auxPoints = [_points floatValue];
	_pointsField.text = [NSString stringWithFormat: @"%.2f", auxPoints];
	
	[_toSectionPicker setAlpha:0];
	[setTaskName setText:taskName];
	
	self.popUpView.layer.cornerRadius = 5;
	self.popUpView.layer.shadowOpacity = 0.8;
	self.popUpView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//	NSLog(@"Hide keyboard");
	[self.view endEditing:YES];
	[super touchesBegan:touches withEvent:event];
}

- (void) saveTask {
	if(_changeTask == 1) {
		NSLog(@"Save button pressed!");
		
		//We begin by creating our POST's body as an NSString, and converting it to NSData.
		NSString *post = [NSString stringWithFormat:@"task=%@&project_id=%@&org=%@", _addTaskNameField.text, _projectID, _orgID];
		NSLog(@"A fost adaugat task-ul cu numele %@, proiectul cu ID-ul %@, orgID = %@", _addTaskNameField.text, _projectID, _orgID);
		NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
		
		//Next up, we read the postData's length, so we can pass it along in the request.
		NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
		
		//Now that we have what we'd like to post, we can create an NSMutableURLRequest, and include our postData
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
		[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/add/backlog"]];
		[request setHTTPMethod:@"POST"];
		[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
		[request setHTTPBody:postData];
		
		
		NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
		NSError *jsonParsingError = nil;
		responseFromServer = [NSJSONSerialization JSONObjectWithData:response
															 options:0 error:&jsonParsingError];
		NSLog(@"Response: %@", responseFromServer);
	}
	else {
		NSError *fetchError = nil;
		//We begin by creating our POST's body as an NSString, and converting it to NSData.
		NSString *post = [NSString stringWithFormat:@"project_id=%@&task_id=%@&from=%@&to=%@", _projectID, _taskID, [_projectFrom lowercaseString], [_projectTo lowercaseString]];
		NSLog(@"projectID: %@, taskID: %@, From: %@, To: %@", _projectID, _taskID, [_projectFrom lowercaseString], [_projectTo lowercaseString]);
		NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
		
		//Next up, we read the postData's length, so we can pass it along in the request.
		NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
		
		//Now that we have what we'd like to post, we can create an NSMutableURLRequest, and include our postData
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
			//warning
		}
	}
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [content count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [content objectAtIndex:row];
}


- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
//	NSLog(@"Selected content: %@. Index of selected color: %ld", [content objectAtIndex:row], (long)row);
	_projectTo = [content objectAtIndex:row];
//	NSLog(@"ProjectTO = %@", _projectTo);
}


- (IBAction)selectPicker:(id)sender
{
	pressed = 1;
	[UIView animateWithDuration:0.6 delay:0. options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[_toSectionPicker setAlpha:1];
	} completion:nil];
}

- (void)showAnimate
{
	self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
	self.view.alpha = 0;
	[UIView animateWithDuration:.25 animations:^{
		self.view.alpha = 1;
		self.view.transform = CGAffineTransformMakeScale(1, 1);
	}];
}

- (void)removeAnimate
{
	[UIView animateWithDuration:.25 animations:^{
		self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
		self.view.alpha = 0.0;
	} completion:^(BOOL finished) {
		if (finished) {
			[self.view removeFromSuperview];
		}
	}];
}

- (IBAction)closePopup:(id)sender {
	if (pressed == 1) {
		[self saveTask];
		NSString *messageString = [NSString stringWithFormat:@"The task %@ has been moved to %@", taskName, _projectTo];
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Save"
							  message:messageString
							  delegate:self
							  cancelButtonTitle:@"Cancel"
							  otherButtonTitles:@"OK", nil];
		[alert show];
		
		[self removeAnimate];
		[self dismissViewControllerAnimated:YES completion:nil];
	}
	else if(_changeTask == 1)
	{
		[self saveTask];
		NSString *messageString = [NSString stringWithFormat:@"The task %@ has been added to Backlog", _addTaskNameField.text];
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Save"
							  message:messageString
							  delegate:self
							  cancelButtonTitle:@"Cancel"
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
							  cancelButtonTitle:@"Cancel"
							  otherButtonTitles:@"OK", nil];
		[alert show];
	}
	
}

- (IBAction)closePopupBack:(id)sender {
	[self removeAnimate];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
	[aView addSubview:self.view];
	if (animated) {
		[self showAnimate];
	}
}

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
		//warning
	}
	NSString *messageString = [NSString stringWithFormat:@"The task %@ has been erased", taskName];
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Save"
						  message:messageString
						  delegate:self
						  cancelButtonTitle:@"Cancel"
						  otherButtonTitles:@"OK", nil];
	[alert show];
}

- (void)parseDate {
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
	
	NSDate *date = [dateFormat dateFromString:_addedDate];
	NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc]init];
	[newDateFormatter setDateFormat:@"dd MMMM yyyy"];
	NSString *newString = [newDateFormatter stringFromDate:date];
//	NSLog(@"Date: %@, formatted date: %@", date, newString);
	[_addedOn setText:newString];
}

- (void) getUserData {
	// Fetching
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserData"];
	
	// Execute Fetch Request
	NSManagedObjectContext *context = [self managedObjectContext];
	NSError *fetchError = nil;
	NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
	
	if (!fetchError) {
		for (NSManagedObject *managedObject in result)
			userID = [managedObject valueForKey:@"id_user"];
		
	} else {
		NSLog(@"Error fetching data.");
		NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
	}
	
	NSError *error;
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	if (fetchedObjects == nil) {
		// Handle the error.
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
						  initWithTitle:@""
						  message:messageString
						  delegate:self
						  cancelButtonTitle:@""
						  otherButtonTitles:@"OK", nil];
	
	if (!responseFromServer) {
		NSLog(@"Error parsing JSON: %@", fetchError);
	}
	else {
		[alert show];
		//warning
	}
	
	
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
