//
//  SingeProjectViewController.h
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 09/05/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingeProjectViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *projectTitle;
@property (strong, nonatomic) NSString *projectID;

- (void) getData;
@end
