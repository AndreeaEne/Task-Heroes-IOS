//
//  SingeProjectViewController.h
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 09/05/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleProjectViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *setProjectTitle;

@property (strong, nonatomic) NSString *projectID, *projectTitle, *organisationID;

@property (weak, nonatomic) IBOutlet UITableView *tasksTable;

@property (weak, nonatomic) IBOutlet UIImageView *wallImage;
@property (weak, nonatomic) IBOutlet UIButton *addNewTask;

- (void) getData;

@end
