//
//  TableViewController.h
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 20/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"

@interface TableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

	// TableViews.
	@property (weak, nonatomic) IBOutlet UITableView *TableViewContent;

	// Images.
	@property (weak, nonatomic) IBOutlet UIImageView *avatar;

	// CoreData.
	@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
	@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
	@property (strong, nonatomic) UserData *userData;

	// Methods.
	- (void) setNewImage: (UIImage*) setimage;

@end