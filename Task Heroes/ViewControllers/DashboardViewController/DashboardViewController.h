//
//  DashboardViewController.h
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 22/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "UserData.h"

@interface DashboardViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> { }

	// Bar button items.
	@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
	@property (weak, nonatomic) IBOutlet UIBarButtonItem *quitButton;

	// Tables.
	@property (weak, nonatomic) IBOutlet UITableView *tableView;
	@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
	@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


	// Arrays.
	@property (nonatomic, strong) NSArray *imageArray;
	@property NSArray *dataTest;

	// Image views.
	@property (weak, nonatomic) IBOutlet UIImageView *wallImage;

	// Labels.
	@property (weak, nonatomic) IBOutlet UILabel *points;
	@property (weak, nonatomic) IBOutlet UILabel *tasks;
	@property (weak, nonatomic) IBOutlet UILabel *taskSection;

	// CoreData.
	@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
	@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
	@property (strong, nonatomic) UserData *userData;

@end