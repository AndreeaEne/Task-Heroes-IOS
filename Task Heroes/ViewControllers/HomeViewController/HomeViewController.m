//
//  HomeViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 17/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import "HomeViewController.h"
#import "Globals.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize emailField, loginButton, passField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
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
    
    BOOL email = [Globals validateEmail:[emailField text]];
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
    
    if ([msg length] > 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
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
