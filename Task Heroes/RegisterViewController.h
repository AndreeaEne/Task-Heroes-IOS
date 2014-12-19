//
//  RegisterViewController.h
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 17/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstnameField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passField;
@property (weak, nonatomic) IBOutlet UITextField *passConfirmField;
@property (weak, nonatomic) IBOutlet UITextField *OrgNameField;
@property (weak, nonatomic) IBOutlet UITextField *OrgTypeField;
@property (weak, nonatomic) IBOutlet UIPickerView *orgTypePicker;

@end

@interface SOTextField : UITextField
@property (nonatomic, readwrite, assign) IBOutlet UITextField *nextField;
@end
