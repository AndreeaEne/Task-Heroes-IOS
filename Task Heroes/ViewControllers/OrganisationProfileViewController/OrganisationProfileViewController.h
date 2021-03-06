//
//  OrganisationProfileViewController.h
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 31/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"

@interface OrganisationProfileViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

	// Tables.
	@property (weak, nonatomic) IBOutlet UITableView *orgTable;

	// Button items.
	@property (strong, nonatomic) UIBarButtonItem *addOrg;

	// CoreData.
	@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
	@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
	@property (strong, nonatomic) UserData *userData;

@end
