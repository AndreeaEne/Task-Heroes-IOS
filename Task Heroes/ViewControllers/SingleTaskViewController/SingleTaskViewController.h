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

	@property (weak, nonatomic) IBOutlet UIPickerView *toSectionPicker;
	@property (weak, nonatomic) IBOutlet UIView *backButton;
	@property (weak, nonatomic) IBOutlet UIView *popUpView;
	@property (weak, nonatomic) IBOutlet UIButton *eraseButton;

	@property (weak, nonatomic) IBOutlet UIButton *iVolunteerButton;
	@property (weak, nonatomic) IBOutlet UILabel *addedOnText;
	@property (weak, nonatomic) IBOutlet UITextField *addTaskNameField;
	@property (weak, nonatomic) IBOutlet UILabel *addTaskNameLabel;
	@property (strong, nonatomic) NSString *taskName, *projectID, *taskID, *projectFrom, *projectTo, *points, *addedDate, *orgID;
	@property (nonatomic) bool changeTask;

	@property (weak, nonatomic) IBOutlet UIButton *moveToButton;
	@property (strong, nonatomic) IBOutlet UILabel *pointsField;
	@property (strong, nonatomic) IBOutlet UILabel *addedOn;
	@property (strong, nonatomic) IBOutlet UILabel *setTaskName;
	@property (weak, nonatomic) IBOutlet UILabel *pointsText;

	//CoreData
	@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
	@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
	@property (strong, nonatomic) UserData *userData;


	- (void)showInView:(UIView *)aView animated:(BOOL)animated;
@end
