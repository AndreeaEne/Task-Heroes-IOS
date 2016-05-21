//
//  SingeProjectViewController.h
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 09/05/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleProjectViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

	// Table.
	@property (weak, nonatomic) IBOutlet UITableView *tasksTable;

	// Title.
	@property (strong, nonatomic) IBOutlet UILabel *setProjectTitle;

	// Strings.
	@property (strong, nonatomic) NSString *projectID, *projectTitle, *organisationID;

	// Wallpaper.
	@property (weak, nonatomic) IBOutlet UIImageView *wallImage;

	// Button.
	@property (weak, nonatomic) IBOutlet UIButton *addNewTask;


	// Methods.
	- (void) getData;

@end
