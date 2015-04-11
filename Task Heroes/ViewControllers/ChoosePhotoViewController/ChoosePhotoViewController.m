//
//  ChoosePhotoViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 06/04/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

#import "ChoosePhotoViewController.h"
#import "TableViewController.h"

@interface ChoosePhotoViewController ()

@end

@implementation ChoosePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	//imageView.image = [UIImage imageNamed:@"Default.jpg"];
    // Do any additional setup after loading the view.
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

@synthesize imageView,choosePhotoBtn,takePhotoBtn;

-(IBAction) getPhoto:(id) sender {
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
 
	if((UIButton *) sender == choosePhotoBtn) {
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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

- (IBAction)backButton:(id)sender {
	//TableViewController *mvid=[[TableViewController alloc]initWithNibName:@"TableViewController" bundle:nil];
	//mvid.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	//mvid.avatar.image = imageView.image; // this is how you do it
	TableViewController *secondViewController = [[TableViewController alloc] init];
	
	//secondViewController.avatar.image = imageView.image; // Set the exposed property
	//[secondViewController.avatar setImage:imageView.image];
	
	
	//TableViewController *mvid=[[TableViewController alloc]initWithNibName:@"TableViewController" bundle:nil];
	//NSLog(@"inainte de alocare: %@",secondViewController.avatar.image);
	//secondViewController.set
	//[secondViewController setNewImage:(imageView.image)];
	
//	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//	NSString *jpegFilePath = [NSString stringWithFormat:@"%@/Wplc.jpeg",docDir];
//	NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(imageView.image, 1.0f)];
//	[data2 writeToFile:jpegFilePath atomically:YES];
	
	NSData *imageData = UIImageJPEGRepresentation(imageView.image, 1.0f); //convert image into .png format.
	
	
	NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
	
	NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
	
	NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Default.jpg", imageView.image]]; //add our image to the path
	if (imageView.image != nil) {
		[fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
		//secondViewController.avatar.image=[UIImage imageNamed:@"Default.jpg"];
		//[secondViewController.avatar setNeedsDisplay];
		[self listFileAtPath:documentsDirectory];
		NSLog(@"image saved");
	}
//	mvid.avatar.image = imageView.image; // this is how you do it
//	NSLog(@"dupa alocare: %@",secondViewController.avatar.image);
//	NSLog(@"Exista imaginea: %@",imageView.image);
	[self dismissViewControllerAnimated:YES completion:nil];
	[secondViewController setNewImage:(secondViewController.avatar.image)];
	
	//---> DELETING <---///
//	NSFileManager *fileMgr = [[NSFileManager alloc] init];
//	NSError *error = nil;
//	NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error];
// if (error == nil) {
//	 for (NSString *path in directoryContents) {
//		 NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:path];
//		 BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
//		 if (!removeSuccess) {
//			 // Error handling
//			 NSLog(@"Eroare");
//		 }
//	 }
// } else {
//	 // Error handling
//	 NSLog(@"Eroare");
//	 
// }
}

// List all files in Directory
-(NSArray *)listFileAtPath:(NSString *)path
{
	//-----> LIST ALL FILES <-----//
	NSLog(@"LISTING ALL FILES FOUND");
	
	int count;
	
	NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
	for (count = 0; count < (int)[directoryContent count]; count++)
	{
		NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
	}
	return directoryContent;
	
	
}




//-(void)storeImageNSDefaults{
//	//here stored images in NSUserDefaultsy.
//	//where imageName is image named.
//	NSData* imgData=UIImagePNGRepresentation(imageView.image);
//	[[NSUserDefaults  standardUserDefaults] setObject:imgData forKey:@"image"];
//	[[NSUserDefaults  standardUserDefaults]synchronize];
//}




@end
