//
//  ChoosePhotoViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 06/04/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

#import "ChoosePhotoViewController.h"

@interface ChoosePhotoViewController ()


@end

@implementation ChoosePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
								initWithTitle:@"Done"
								style:UIBarButtonItemStyleBordered
								target:self
								action:nil];
	self.navigationController.navigationBar.topItem.backBarButtonItem=btnBack;
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@synthesize imageView,choosePhotoBtn, takePhotoBtn;

-(IBAction) getPhoto:(id) sender {
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
 
	if((UIButton *) sender == choosePhotoBtn) {
		picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	} else {
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
	[picker setAllowsEditing:YES];
	[self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissViewControllerAnimated:YES completion:nil];
	
	imageView.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
}
- (void) viewWillAppear:(BOOL)animated {
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStylePlain target:self action:@selector(Back)];
	self.navigationItem.leftBarButtonItem = backButton;
}

- (IBAction)Back
{
	[self dismissViewControllerAnimated:YES completion:nil]; // ios 6
}



@end
