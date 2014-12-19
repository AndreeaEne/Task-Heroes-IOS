//
//  RegisterViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 17/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import "RegisterViewController.h"
#import "HomeViewController.h"

@interface RegisterViewController ()
@end

@implementation RegisterViewController

@synthesize firstnameField, lastnameField, emailField, passField, passConfirmField, OrgNameField, OrgTypeField, orgTypePicker;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)selectOrg:(id)sender {
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    
    BOOL didResign = [textField resignFirstResponder];
    if (!didResign) return NO;
    
    if ([textField isKindOfClass:[SOTextField class]])
        dispatch_async(dispatch_get_main_queue(),
                       ^ { [[(SOTextField *)textField nextField] becomeFirstResponder]; });
    
    return YES;
    
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


@implementation SOTextField
@synthesize nextField;

@end


