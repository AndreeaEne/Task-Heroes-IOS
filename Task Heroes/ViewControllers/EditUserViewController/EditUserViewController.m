//
//  EditUserViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 15/04/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

#import "EditUserViewController.h"
#import "SWRevealViewController.h"
#import "UIViewController+NavigationBar.h"
#import <CoreData/CoreData.h>

NSString *id_user;


@interface EditUserViewController ()

@end

@implementation EditUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self setupNavigationBar];
	//[self getUserData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupNavigationBar
{
	[[UIApplication sharedApplication] setStatusBarHidden: NO];
	[self.navigationController setNavigationBarHidden: NO];
	
	[self setTitle:@"Edit User Profile"];
	[self setRevealButtonWithImage: [UIImage imageNamed:@"reveal-icon.png"]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	//	NSLog(@"Hide keyboard");
	[self.view endEditing:YES];
	[super touchesBegan:touches withEvent:event];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)saveButton:(id)sender {
	//We begin by creating our POST's body (ergo. what we'd like to send) as an NSString, and converting it to NSData.
	NSString *post = [NSString stringWithFormat:@"first_name=%@&last_name=%@&email=%@&_id=%@", _firstName.text, _lastName.text, _email.text, id_user];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	//Next up, we read the postData's length, so we can pass it along in the request.
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	//NSData *postDataLogged = [postLogged dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	//Now that we have what we'd like to post, we can create an NSMutableURLRequest, and include our postData
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/update/user"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	
	//Send the request, and read the reply:
	NSURLResponse *requestResponse;
	NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
	
	NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
	
	//Pass Request
	NSString *postPass = [NSString stringWithFormat:@"old=%@&new=%@&_id=%@", _password.text, _verifyPassword.text, id_user];
	NSData *postDataPass = [postPass dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	//Next up, we read the postData's length, so we can pass it along in the request.
	NSString *postLengthPass = [NSString stringWithFormat:@"%lu", (unsigned long)[postDataPass length]];
	
	//Now that we have what we'd like to post, we can create an NSMutableURLRequest, and include our postData
	NSMutableURLRequest *requestPass = [[NSMutableURLRequest alloc] init];
	[requestPass setURL:[NSURL URLWithString:@"https://task-heroes.herokuapp.com/change/password"]];
	[requestPass setHTTPMethod:@"POST"];
	[requestPass setValue:postLengthPass forHTTPHeaderField:@"Content-Length"];
	[requestPass setHTTPBody:postDataPass];
	
	//Send the request, and read the reply:
	NSURLResponse *requestResponsePass;
	NSData *requestHandlerPass = [NSURLConnection sendSynchronousRequest:requestPass returningResponse:&requestResponsePass error:nil];
	
	NSString *requestReplyPass = [[NSString alloc] initWithBytes:[requestHandlerPass bytes] length:[requestHandlerPass length] encoding:NSASCIIStringEncoding];

#warning "Nu verifica daca trimit text gol"
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
//	NSLog(@"\nlog:%hhd\npassLog: %hhd", log, passLog);
//	NSLog(@"requestReply: %@", requestReply);
//	NSLog(@"requestReplyPass: %@", requestReplyPass);
	
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

- (void) getUserData {
	// Fetching
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserData"];
	// Add Sort Descriptor
	//NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"email" ascending:YES];
	//[fetchRequest setSortDescriptors:@[sortDescriptor]];
	
	// Execute Fetch Request
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
			
			NSLog(@"email: %@,\nfirst: %@,\nlast:%@,", email_user, first_name_user, last_name_user);
		}
		
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

- (void) viewWillAppear:(BOOL)animated {
	[self getUserData];

}


@end
