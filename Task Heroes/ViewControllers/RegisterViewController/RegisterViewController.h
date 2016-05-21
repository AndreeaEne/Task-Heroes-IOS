//
//  RegisterViewController.h
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 17/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "UserData.h"

@interface RegisterViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

	//TextFields.
	@property (weak, nonatomic) IBOutlet UITextField *firstnameField;
	@property (weak, nonatomic) IBOutlet UITextField *lastnameField;
	@property (weak, nonatomic) IBOutlet UITextField *emailField;
	@property (weak, nonatomic) IBOutlet UITextField *passField;
	@property (weak, nonatomic) IBOutlet UITextField *passConfirmField;
	@property (weak, nonatomic) IBOutlet UITextField *OrgNameField;

	// Buttons.
	@property (weak, nonatomic) IBOutlet UIButton *orgTypeButton;

	// PickerViews.
	@property (weak, nonatomic) IBOutlet UIPickerView *orgTypePicker;

	// CoreData.
	@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
	@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
	@property(strong, nonatomic) UserData *userData;

@end

@interface SOTextField : UITextField

	// TextFields.
	@property (nonatomic, readwrite, assign) IBOutlet UITextField *nextField;

@end
