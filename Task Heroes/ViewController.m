//
//  ViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 16/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

@interface ViewController ()

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    [super viewDidLoad];
    // nslog afiseaza in consola
    NSLog(@"App - view did load");
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showAlert:(id)sender {
    NSLog(@"did touch button");
    _label.text = @"Andreea chiar invata";
    _label.textColor = [UIColor purpleColor];
    _label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    _label.textAlignment = NSTextAlignmentCenter;
    
    [self performSegueWithIdentifier:@"firstViewToSecondView" sender:self];

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
//    if ([segue.identifier isEqualToString:@"firstViewToSecondView"])
//    {
//        NSLog(@"Set project id");
//    }
    
    if ( [segue.destinationViewController isKindOfClass:[DetailViewController class]])
    {
        NSLog(@"set project id");
        DetailViewController *detailViewController = (DetailViewController *) segue.destinationViewController;
        detailViewController.projectID = 100;
    }
    
    
}


@end
