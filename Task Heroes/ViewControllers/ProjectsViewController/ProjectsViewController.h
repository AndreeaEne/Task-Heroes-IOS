//
//  ProjectsViewController.h
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 31/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

	// Tables.
	@property (weak, nonatomic) IBOutlet UITableView *projectsTable;

	// Arrays.
	@property (strong, nonatomic) NSMutableArray *organisationID;
	@property (strong, nonatomic) NSMutableArray *projectID;
	@property (strong, nonatomic) NSMutableArray *project_name;
	@property (strong, nonatomic) NSMutableArray *organisation_name;

	// Button items.
	@property (strong, nonatomic) UIBarButtonItem *addTask;

@end






