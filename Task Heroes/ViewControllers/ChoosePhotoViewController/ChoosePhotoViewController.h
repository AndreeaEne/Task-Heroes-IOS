//
//  ChoosePhotoViewController.h
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 06/04/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoosePhotoViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

	// ImageViews.
	@property (weak, nonatomic) IBOutlet UIImageView *imageView;

	//Buttons.
	@property (nonatomic, retain) IBOutlet UIButton *choosePhotoBtn;
	@property (nonatomic, retain) IBOutlet UIButton *takePhotoBtn;


	// Methods.
	-(IBAction) getPhoto:(id) sender;

@end
