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
	@property(weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
	@property (weak, nonatomic) IBOutlet UITableView *tableView;
	@property (weak, nonatomic) IBOutlet UIBarButtonItem *quitButton;
	//@property (weak, nonatomic) IBOutlet UICollectionView *dashboardCollection;

	@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
	@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
	@property (nonatomic, strong) NSArray *imageArray;
	@property (weak, nonatomic) IBOutlet UILabel *taskSection;
	@property NSArray *dataTest;

	@property (weak, nonatomic) IBOutlet UIImageView *wallImage;

	@property (weak, nonatomic) IBOutlet UILabel *points;
	@property (weak, nonatomic) IBOutlet UILabel *tasks;

	//CoreData
	@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
	@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
	@property (strong, nonatomic) UserData *userData;

@end