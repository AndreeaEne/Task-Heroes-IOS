//
//  WelcomeViewController.h
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 06/04/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"

@interface WelcomeViewController : UIViewController

	@property (weak, nonatomic) IBOutlet UIButton *startButton;
	@property (strong, nonatomic) NSString *orgName, *orgType, *user, *pass;

	//CoreData
	@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
	@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
	@property (strong, nonatomic) UserData *userData;

@end
