//
//  SingleTaskViewController.h
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 23/05/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleTaskViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIPickerView *toSectionPicker;
@property (weak, nonatomic) IBOutlet UIView *backButton;
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIButton *eraseButton;

@property (strong, nonatomic) NSString *taskName, *projectID, *taskID, *projectFrom, *projectTo, *points, *addedDate;

@property (strong, nonatomic) IBOutlet UILabel *pointsField;
@property (strong, nonatomic) IBOutlet UILabel *addedOn;
@property (strong, nonatomic) IBOutlet UILabel *setTaskName;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;
//task aka task name + project_ID + org aka orgID -> /add/backlog
@end
