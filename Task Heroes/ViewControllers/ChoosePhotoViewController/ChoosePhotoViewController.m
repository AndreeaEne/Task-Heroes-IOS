//
//  ChoosePhotoViewController.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 06/04/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

/** This view updates the photo of the user. **/

#import "ChoosePhotoViewController.h"
#import "TableViewController.h"

@interface ChoosePhotoViewController ()

@end

@implementation ChoosePhotoViewController

- (void)viewDidLoad {
	NSLog(@"ChoosePhotoViewController loaded.");
	[super viewDidLoad];
	[self setNewImage];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@synthesize imageView,choosePhotoBtn,takePhotoBtn;

// Take the photo from the library.
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

// Take the image from Default.jpg.
- (void) setNewImage {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"Default.jpg"];
	NSData *imgData = [NSData dataWithContentsOfFile:getImagePath];
	imageView.image = [[UIImage alloc] initWithData:imgData];
}

// Go back and dismiss the view.
- (IBAction)backButton:(id)sender {
	// Convert image into .png format.
	NSData *imageData = UIImageJPEGRepresentation(imageView.image, 1.0f);
	
	// Create instance of NSFileManager.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Create an array and store result of our search for the documents directory in it.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	// Create NSString object, that holds our exact path to the documents directory.
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// Add our image to the path.
	NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Default.jpg"]];
	if (imageView.image != nil) {
		// Save the path.
		[fileManager createFileAtPath:fullPath contents:imageData attributes:nil];
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}


/* Delete an image
 
NSFileManager *fileMgr = [[NSFileManager alloc] init];
NSError *error = nil;
NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error];
if (error == nil) {
	 for (NSString *path in directoryContents) {
		 NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:path];
		 BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
		 if (!removeSuccess) {
			 // Error handling
			 NSLog(@"Eroare");
		 }
	 }
 } else {
	 // Error handling
	 NSLog(@"Eroare");

 }
}
*/


/* List all files in Directory
 
-(NSArray *)listFileAtPath:(NSString *)path
{
	NSLog(@"LISTING ALL FILES FOUND");

	int count;

	NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
	for (count = 0; count < (int)[directoryContent count]; count++)
	{
		NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
	}
	return directoryContent;
}
*/


/* Stored images in NSUser
 
-(void)storeImageNSDefaults{
	NSData* imgData=UIImagePNGRepresentation(imageView.image);
	[[NSUserDefaults  standardUserDefaults] setObject:imgData forKey:@"image"];
	[[NSUserDefaults  standardUserDefaults]synchronize];
}

*/
@end
