//
//  SingleTaskViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 23/05/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

#import "SingleTaskViewController.h"
#import "SingleProjectViewController.h"

@interface SingleTaskViewController ()
@end

@implementation SingleTaskViewController

NSDictionary *responseFromServer;
NSMutableArray *content;
bool pressed;

@synthesize taskName, setTaskName;

- (void)viewDidLoad {
	[super viewDidLoad];
	
//	UIColor *color = [UIColor colorWithRed:0.251 green:0.62 blue:0.765 alpha:1];
//	self.view.backgroundColor = color;
	
	_projectTo = @"backlog";
	content = [NSMutableArray arrayWithObjects:@"Backlog", @"Waiting", @"Doing", @"Done", nil];
	
	[content removeObject:_projectFrom];
	
//	[[self navigationController] setNavigationBarHidden:YES animated:YES];
	
	float auxPoints = [_points floatValue];
	_pointsField.text = [NSString stringWithFormat: @"%.2f", auxPoints];
	
	[_toSectionPicker setAlpha:0];
	[setTaskName setText:taskName];
	
	self.popUpView.layer.cornerRadius = 5;
	self.popUpView.layer.shadowOpacity = 0.8;
	self.popUpView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
	
}

- (void) saveTask {
	NSError *fetchError = nil;
	//	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserData"];
	//	NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
	
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
