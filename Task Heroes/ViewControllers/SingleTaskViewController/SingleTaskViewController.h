//
//  SingleTaskViewController.h
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 23/05/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "UserData.h"

@interface SingleTaskViewController : UIViewController

	// Text Pickers.
	@property (weak, nonatomic) IBOutlet UIPickerView *toSectionPicker;

	// Views.
	@property (weak, nonatomic) IBOutlet UIView *backButton;
	@property (weak, nonatomic) IBOutlet UIView *popUpView;

	// Buttons.
	@property (weak, nonatomic) IBOutlet UIButton *eraseButton;
	@property (weak, nonatomic) IBOutlet UIButton *iVolunteerButton;
	@property (weak, nonatomic) IBOutlet UIButton *moveToButton;

	// Labels.
	@property (weak,   nonatomic) IBOutlet UILabel *addedOnText;
	@property (weak,   nonatomic) IBOutlet UILabel *addTaskNameLabel;
	@property (weak,   nonatomic) IBOutlet UILabel *pointsText;
	@property (strong, nonatomic) IBOutlet UILabel *pointsField;
	@property (strong, nonatomic) IBOutlet UILabel *addedOn;
	@property (strong, nonatomic) IBOutlet UILabel *setTaskName;

	// Text Fields.
	@property (weak,   nonatomic) IBOutlet UITextField *addTaskNameField;
	@property (strong, nonatomic) NSString *taskName, *projectID, *taskID, *projectFrom,
												*projectTo, *points, *addedDate, *orgID;


	// CoreData.
	@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
	@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
	@property (strong, nonatomic) UserData *userData;

	// Variables.
	@property (nonatomic) bool changeTask;


	// Methods.
	- (void)showInView:(UIView *)aView animated:(BOOL)animated;

@end
