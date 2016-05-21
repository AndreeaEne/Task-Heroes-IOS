//
//  UIViewController+NavigationBar.h
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 30/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface UIViewController (NavigationBar)

	- (void)setRevealButtonWithImage:(UIImage *)revealImage;

	- (void)setBackButtonWithImage:(UIImage *)image
							title:(NSString *)title
					swipeForBack:(BOOL)swipeForBack;

	- (void)setBackButtonWithImage:(UIImage *)image
							title:(NSString *)title
					swipeForBack:(BOOL)swipeForBack
						selector:(SEL)selector;

	- (void)setBackButtonWithImage:(UIImage *)image
							title:(NSString *)title
						   xOffset:(CGFloat)xOffset
					swipeForBack:(BOOL)swipeForBack;

	- (void)setBackButtonWithImage:(UIImage *)image
							title:(NSString *)title
						   xOffset:(CGFloat)xOffset
					swipeForBack:(BOOL)swipeForBack
							selector:(SEL)selector;

	- (void)setLeftBarButtonItemWithImage:(UIImage *)image
                                title:(NSString *)title;

	- (void)setRightBarButtonItemWithImage:(UIImage *)image
                                title:(NSString *)title;

	- (void)setRightBarButtonItemWithImage:(UIImage *)image
                                 title:(NSString *)title
                              selector:(SEL)selector;

	- (UIButton *)setRightBarButtonItemWithImage:(UIImage *)image
                               selectedImage:(UIImage *)selectedImage
                                       title:(NSString *)title
                                    selector:(SEL)selector;

	- (void)setRightBarButtonItemsWithImageNamesAndTitles:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

	- (void)setRightBarButtonWith:(UIBarButtonSystemItem)barButtonSystemItem;
	- (void)setRightBarButtonWithTitle:(NSString *)title
                          andStyle:(UIBarButtonItemStyle)style;


	- (void)initializeNavigationBarSimpleWithImage:(UIImage *)navigationImage;

	- (void)setTitleArrangement;

	- (void)goBack;
	- (void)goHome;

	- (void)setPanGestureRecognizer;
	- (void)removePanGestureRecognizer;
	- (void)addOrRemovePanGesture;
	- (void)setNavigationWithNavigationBarHidden:(BOOL)navigationBarHidden andStatusBarStyle:(UIStatusBarStyle)statusBarStyle;

	- (void)setScreenTitleWithFontsAndTexts:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

@end
