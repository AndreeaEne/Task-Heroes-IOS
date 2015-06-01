//
//  HomeViewController.h
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 17/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "UserData.h"


@interface HomeViewController : UIViewController

	@property (weak, nonatomic) IBOutlet UITextField *emailField;
	@property (weak, nonatomic) IBOutlet UITextField *passField;
	@property (weak, nonatomic) IBOutlet UIButton *loginButton;


	//CoreData
	@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
	@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

	@property(strong, nonatomic) UserData *userData;

@end


