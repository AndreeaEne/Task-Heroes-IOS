//
//  HomeViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 17/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import "HomeViewController.h"
#import "Globals.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

BOOL semafor = false;

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize emailField, loginButton, passField;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
	//[self performSegueWithIdentifier: @"LogIn" sender: self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Hide Keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Hide keyboard");
    //NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)loginButton:(id)sender {
    NSString *msg;
    //BOOL email = [Globals validateEmail:[emailField text]];
	BOOL email = [emailField.text length] > 0;
    BOOL pass = [passField.text length] > 0;
    
    if (!email && !pass) {
        msg = @"Enter a valid email and password.";
    }
    else if (!email) {
        msg = @"Enter a valid email address.";
    }
    else if (!pass) {
        msg = @"Enter a password. ";
    }
    else if([self Login] == true) {
         [self performSegueWithIdentifier: @"LogIn" sender: self];
    }
	else msg = @"User or password incorrect";
    
    if ([msg length] > 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

- (BOOL)Login
{
	//We begin by creating our POST's body (ergo. what we'd like to send) as an NSString, and converting it to NSData.
	NSString *post = [NSString stringWithFormat:@"username=%@&pass=%@", emailField.text, passField.text];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	//Next up, we read the postData's length, so we can pass it along in the request.
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	//Now that we have what we'd like to post, we can create an NSMutableURLRequest, and include our postData
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"http://localhost:8081/login/user"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	
	//Send the request, and read the reply:
	NSURLResponse *requestResponse;
	NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
	
	NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
	//requestReply = [NSString stringWithFormat:@"msg"];
	
	//Check if the user/pass exists
	if ([requestReply rangeOfString:@"_id"].location != NSNotFound) {
		semafor = true;
	}
	
	if (semafor == true) {
		NSArray *components = [requestReply componentsSeparatedByString:@","];
		NSLog(@"%@",components);
		
		//Save data about User
		NSString* id_user = [[[[requestReply componentsSeparatedByString:@"_id\":\""]objectAtIndex:1] componentsSeparatedByString:@"\""]objectAtIndex:0];
		NSString *last_name = [[[[requestReply componentsSeparatedByString:@"last_name\":\""]objectAtIndex:1] componentsSeparatedByString:@"\""]objectAtIndex:0];
		NSString *first_name = [[[[requestReply componentsSeparatedByString:@"first_name\":\""]objectAtIndex:1] componentsSeparatedByString:@"\""]objectAtIndex:0];
		NSString *email = [[[[requestReply componentsSeparatedByString:@"email\":\""]objectAtIndex:1] componentsSeparatedByString:@"\""]objectAtIndex:0];
		NSString *aux = [[[[requestReply componentsSeparatedByString:@"points\":"]objectAtIndex:1] componentsSeparatedByString:@"\""]objectAtIndex:0];
		float points = [aux floatValue];
		
		NSLog(@"\n ID: %@ \n lastname: %@ \n firstname: %@ \n email: %@\n points: %f",id_user, last_name, first_name, email, points);
	
		// Save to Core Data
		// Create a new managed object
		NSManagedObjectContext *context = [self managedObjectContext];
		NSManagedObject *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"UserData" inManagedObjectContext:context];
		[newUser setValue:id_user forKey:@"id_user"];
		[newUser setValue:last_name forKey:@"last_name"];
		[newUser setValue:first_name forKey:@"first_name"];
		[newUser setValue:email forKey:@"email"];
		[newUser setValue:[NSNumber numberWithFloat:points]  forKey:@"points"];
		
		//Test
		// Fetching
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserData"];
		
		// Add Sort Descriptor
		//NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"email" ascending:YES];
		//[fetchRequest setSortDescriptors:@[sortDescriptor]];
		
		// Execute Fetch Request
		NSError *fetchError = nil;
		NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
		
		if (!fetchError) {
			for (NSManagedObject *managedObject in result) {
				NSLog(@"%@, %@, %@, %@", [managedObject valueForKey:@"email"], [managedObject valueForKey:@"last_name"], [managedObject valueForKey:@"id_user"], [managedObject valueForKey:@"points"]);
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
	
	return semafor;
}

- (NSManagedObjectContext *)managedObjectContext {
	NSManagedObjectContext *context = nil;
	id delegate = [[UIApplication sharedApplication] delegate];
	if ([delegate performSelector:@selector(managedObjectContext)]) {
		context = [delegate managedObjectContext];
	}
	return context;
}

- (void) viewWillAppear:(BOOL)animated {
	semafor = false;
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
