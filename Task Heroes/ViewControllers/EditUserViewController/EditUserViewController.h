//
//  EditUserViewController.h
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 15/04/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditUserViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *verifyPassword;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end
