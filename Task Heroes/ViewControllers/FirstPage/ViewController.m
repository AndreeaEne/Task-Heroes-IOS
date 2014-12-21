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
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [super viewDidLoad];
    // nslog afiseaza in consola
    NSLog(@"App - view did load");
    
}

-(void) viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showAlert:(id)sender {
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
