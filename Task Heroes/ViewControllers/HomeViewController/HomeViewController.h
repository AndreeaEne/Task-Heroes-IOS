//
//  HomeViewController.h
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 17/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface HomeViewController : UIViewController

	@property (weak, nonatomic) IBOutlet UITextField *emailField;
	@property (weak, nonatomic) IBOutlet UITextField *passField;
	@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end


