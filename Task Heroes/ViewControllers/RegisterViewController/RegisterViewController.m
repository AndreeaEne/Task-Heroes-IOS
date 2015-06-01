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

@interface RegisterViewController ()

@end

@implementation RegisterViewController
{
    NSArray *content;
    BOOL checkSignUp;
	NSManagedObjectID *moID;
}

@synthesize firstnameField, lastnameField, emailField, passField, passConfirmField, OrgNameField, orgTypeButton, orgTypePicker, userData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [orgTypePicker setAlpha:0];
     content = [NSArray arrayWithObjects:@"Youth", @"School", @"Religious", nil];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL) textFieldShouldReturn:(UITextField *) textField
{
    BOOL didResign = [textField resignFirstResponder];
    if (!didResign) return NO;
    
    if ([textField isKindOfClass:[SOTextField class]])
        dispatch_async(dispatch_get_main_queue(),
                       ^ { [[(SOTextField *)textField nextField] becomeFirstResponder]; });
    return YES;
    
}

/*
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}
*/
- (IBAction)selectPicker:(id)sender
{
    [UIView animateWithDuration:0.6 delay:0. options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [orgTypePicker setAlpha:1];
    } completion:nil];
}

//Hide Keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Hide keyboard");
    //NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
/*
- (IBAction)hidePicker {
    NSLog(@"Hide Picker");
    UIPickerView *pickerView = [[UIPickerView alloc] init]; // default frame is set
    float pvHeight = pickerView.frame.size.height;
    float y = self.view.bounds.size.height - (pvHeight * -2); // the root view of view controller
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.orgTypePicker.frame = CGRectMake(0 , y, pickerView.frame.size.width, pvHeight);
    } completion:nil];
}

- (IBAction)showPicker {
    NSLog(@"Show picker");
    UIPickerView *pickerView = [[UIPickerView alloc] init]; // default frame is set
    float pvHeight = pickerView.frame.size.height;
    float y = self.view.bounds.size.height - (pvHeight); // the root view of view controller
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.orgTypePicker.frame = CGRectMake(0 , y, pickerView.frame.size.width, pvHeight);
    } completion:nil];
}
*/
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

- (IBAction)signupButton:(id)sender
{
    NSLog(@"Button Pressed");
    NSString *msg;
    checkSignUp = 0;
    
    BOOL email = [Globals validateEmail:[emailField text]];
    BOOL pass = [passField.text length] > 0;
    BOOL passConf = [passConfirmField.text length] > 0;
    BOOL firstName = [firstnameField.text length] > 0;
    BOOL lastName = [lastnameField.text length] > 0;
    BOOL orgName = [OrgNameField.text length] > 0;
    
#warning Dynamic messages!
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
    
    else if (pass && email && passConf && firstName && lastName && orgName){
        checkSignUp = 1;
    }
    
    if ([msg length] > 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
    if (checkSignUp == 1 && [self Register] == 1){
        [self performSegueWithIdentifier: @"SignUp" sender: self];
        }
}
/* Transmite info la urmatorul view
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"SignUp"]) {
        NSLog(@"Segue Blocked");
        //Put your validation code here and return YES or NO as needed
        if (checkSignUp == 1)
        return NO;
    }
    
    return YES;
}
*/

- (BOOL)Register {
	//We begin by creating our POST's body (ergo. what we'd like to send) as an NSString, and converting it to NSData.
	NSString *post = [NSString stringWithFormat:@"Email=%@&Pass1=%@&First=%@&Last=%@", emailField.text, passField.text, firstnameField.text, lastnameField.text];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	//Next up, we read the postData's length, so we can pass it along in the request.
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	
	//Now that we have what we'd like to post, we can create an NSMutableURLRequest, and include our postData
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/register/user"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	
	//And finally, we can send our request, and read the reply:
	NSURLResponse *requestResponse;
	NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
	
	NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
	//requestReply = [NSString stringWithFormat:@"msg"];
	
	BOOL log = false;
	if([requestReply isEqualToString:@"{\"success\":\"User Inserted successfuly!\"}"]) {
		log = true;
		
		//We begin by creating our POST's body (ergo. what we'd like to send) as an NSString, and converting it to NSData.
		NSString *post = [NSString stringWithFormat:@"username=%@&pass=%@", emailField.text, passField.text];
		NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
		
		//Next up, we read the postData's length, so we can pass it along in the request.
		NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
		
		//Now that we have what we'd like to post, we can create an NSMutableURLRequest, and include our postData
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
		[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/login/user"]];
		[request setHTTPMethod:@"POST"];
		[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
		[request setHTTPBody:postData];
		
		//Send the request, and read the reply:
		NSURLResponse *requestResponse;
		NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
		
		NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
		//requestReply = [NSString stringWithFormat:@"msg"];
		
			NSArray *components = [requestReply componentsSeparatedByString:@","];
			NSLog(@"%@",components);
			
			//Save data about User
			NSString* id_user = [[[[requestReply componentsSeparatedByString:@"_id\":\""]objectAtIndex:1] componentsSeparatedByString:@"\""]objectAtIndex:0];
			
			NSLog(@"\n ID: %@",id_user);
		
		//Save to Core Data
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

-(void)performFetch {
	NSManagedObjectContext *moc = [self managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"UserData" inManagedObjectContext:moc];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];
	
 
	NSError *error;
	NSArray *array = [moc executeFetchRequest:request error:&error];
	if (array == nil)
	{
		// Deal with error...
	}
	NSLog(@"array: %@\n, Conturi: %lu", array, (unsigned long)[array count]);
	for (NSManagedObject *managedObject in array) {
		moID = [managedObject objectID];
		NSLog(@"moID: %@", moID);
	}
}

- (NSManagedObjectContext *) managedObjectContext {
	//	NSLog(@"viewDidLoad: moID: %@", moID);
	
	NSManagedObjectContext *context = nil;
	id delegate = [[UIApplication sharedApplication] delegate];
	if ([delegate performSelector:@selector(managedObjectContext)]) {
		context = [delegate managedObjectContext];
	}
	return context;
}

- (void) setupFetchedResultsController {
	// 1 - Decide what Entity you want
	NSString *entityName = @"UserData"; // Put your entity name here
	NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
 
	// 2 - Request that Entity
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
 
	// 3 - Filter it if you want
	//request.predicate = [NSPredicate predicateWithFormat:@"Role.name = Blah"];
 
	// 4 - Sort it if you want
	request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"first_name"
																					 ascending:YES
																					  selector:@selector(localizedCaseInsensitiveCompare:)]];
	// 5 - Fetch it
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


@end

@implementation SOTextField

@synthesize nextField;

@end

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

