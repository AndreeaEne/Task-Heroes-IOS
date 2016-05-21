//
//  MembersViewController.h
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 30/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"

@interface MembersViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

	// Tables.
	@property (weak, nonatomic) IBOutlet UITableView *membersTable;

	// CoreData.
	@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
	@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
	@property (strong, nonatomic) UserData *userData;

@end
