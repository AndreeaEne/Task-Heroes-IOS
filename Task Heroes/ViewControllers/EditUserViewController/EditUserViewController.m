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

@interface EditUserViewController ()

@end

@implementation EditUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self setupNavigationBar];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)saveAction:(id)sender {
	//We begin by creating our POST's body (ergo. what we'd like to send) as an NSString, and converting it to NSData.
	//for LoggedUser
	NSString *postLogged = [NSString stringWithFormat:@""];
	NSString *post = [NSString stringWithFormat:@"username=%@&pass=%@&username=%@&pass=%@&pass=%@", _firstName.text, _lastName.text, _password, _verifyPassword, _email];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	//Next up, we read the postData's length, so we can pass it along in the request.
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	NSData *postDataLogged = [postLogged dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	//Now that we have what we'd like to post, we can create an NSMutableURLRequest, and include our postData
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"http://localhost:8081/login/user"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	
	//And finally, we can send our request, and read the reply:
	NSURLResponse *requestResponse;
	NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
	
	NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
	//requestReply = [NSString stringWithFormat:@"msg"];
	
	BOOL log = false;
	if(![requestReply isEqualToString:@"{\"msg\":\"user not found\"}"] || ![requestReply isEqualToString:@""]) {
		log = true;
	}
	NSLog(@"requestReply: %@", requestReply);
	
}

@end
