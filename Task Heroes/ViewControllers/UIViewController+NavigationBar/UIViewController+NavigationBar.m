//
//  UIViewController+NavigationBar.m
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 30/12/14.
//  Copyright (c) 2014 Andreea-Daniela Ene. All rights reserved.
//

#import "UIViewController+NavigationBar.h"
#import "SWRevealViewController.h"
#import "TableViewController.h"
#import "AppDelegate.h"

#define navigationHeight 44

@implementation UIViewController (NavigationBar)

- (void)setRevealButtonWithImage:(UIImage *)revealImage {
    
    CGSize imageSize = revealImage.size;
    
    CGFloat scale = imageSize.height / navigationHeight;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
//    if( scale > 1 ) {
        width /= scale;
        height /= scale;
//    }
    
    CGRect buttonFrame = CGRectMake(0, (navigationHeight - height) / 2, width, height);
    
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    button.tag = 1;
    
    [button setImage:revealImage forState:UIControlStateNormal];
    [button addTarget:self.revealViewController action:@selector(revealToggle:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    if( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [negativeSpacer setWidth:-15];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, barButton, nil];
    } else {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [negativeSpacer setWidth:-5];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, barButton, nil];
    }
    
}

- (void)setBackButtonWithImage:(UIImage *)image
                         title:(NSString *)title
                  swipeForBack:(BOOL)swipeForBack {
    
    CGSize imageSize = image.size;
    
    CGFloat scale = imageSize.height / navigationHeight;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if( scale > 1 ) {
        width /= scale;
        height /= scale;
    }
    
    CGRect buttonFrame = CGRectMake(0, (navigationHeight - height) / 2, width, height);
    if( title == nil || [title length] == 0 ) {
        buttonFrame.size.width = MAX(buttonFrame.size.width, 45);
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    button.tag = 1;
    
    if( title == nil || [title length] == 0 ) {
        [button setImage:image forState:UIControlStateNormal];
    } else {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    [button setShowsTouchWhenHighlighted:YES];
    [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    if( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [negativeSpacer setWidth:-15];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,backButton,nil];
        
        if( swipeForBack ) {
            self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
        } else {

        }
        
    } else {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [negativeSpacer setWidth:-5];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, backButton, nil];
    }
    
}

- (void)setBackButtonWithImage:(UIImage *)image
                         title:(NSString *)title
                  swipeForBack:(BOOL)swipeForBack
                      selector:(SEL)selector {
    
    CGSize imageSize = image.size;
    
    CGFloat scale = imageSize.height / navigationHeight;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if( scale > 1 ) {
        width /= scale;
        height /= scale;
    }
    
    CGRect buttonFrame = CGRectMake(0, (navigationHeight - height) / 2, width, height);
    if( title == nil || [title length] == 0 ) {
        buttonFrame.size.width = MAX(buttonFrame.size.width, 45);
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    button.tag = 1;
    
    if( title == nil || [title length] == 0 ) {
        [button setImage:image forState:UIControlStateNormal];
    } else {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    [button setShowsTouchWhenHighlighted:YES];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    if( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [negativeSpacer setWidth:-15];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,backButton,nil];
        
        if( swipeForBack ) {
            self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
        } else {
            
        }
        
    } else {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [negativeSpacer setWidth:-5];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, backButton, nil];
    }
    
}

- (void)setBackButtonWithImage:(UIImage *)image
                         title:(NSString *)title
                       xOffset:(CGFloat)xOffset
                  swipeForBack:(BOOL)swipeForBack {

    CGSize imageSize = image.size;
    
    CGFloat scale = imageSize.height / navigationHeight;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if( scale > 1 ) {
        width /= scale;
        height /= scale;
    }
    
    CGRect buttonFrame = CGRectMake(0, (navigationHeight - height) / 2, width, height);
    
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    button.tag = 1;
    
    if( title == nil || [title length] == 0 ) {
        [button setImage:image forState:UIControlStateNormal];
    } else {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    [button setShowsTouchWhenHighlighted:YES];
    [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    if( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [negativeSpacer setWidth: -15 + xOffset];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,backButton,nil];
        
        if( swipeForBack ) {
            self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
        } else {
            
        }
        
    } else {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [negativeSpacer setWidth: -5 + xOffset];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,backButton,nil];
    }
    
}

- (void)setBackButtonWithImage:(UIImage *)image title:(NSString *)title xOffset:(CGFloat)xOffset swipeForBack:(BOOL)swipeForBack selector:(SEL)selector {
 
    CGSize imageSize = image.size;
    
    CGFloat scale = imageSize.height / navigationHeight;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if( scale > 1 ) {
        width /= scale;
        height /= scale;
    }
    
    CGRect buttonFrame = CGRectMake(0, (navigationHeight - height) / 2, width, height);
    
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    button.tag = 1;
    
    if( title == nil || [title length] == 0 ) {
        [button setImage:image forState:UIControlStateNormal];
    } else {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    [button setShowsTouchWhenHighlighted:YES];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    if( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [negativeSpacer setWidth: -15 + xOffset];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,backButton,nil];
        
        if( swipeForBack ) {
            self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
        } else {
            
        }
        
    } else {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [negativeSpacer setWidth: -5 + xOffset];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,backButton,nil];
    }
    
}

- (void)setLeftBarButtonItemWithImage:(UIImage *)image
                                title:(NSString *)title {
    

    CGSize imageSize = image.size;
    
    CGFloat scale = imageSize.height / navigationHeight;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if( scale > 1 ) {
        width /= scale;
        height /= scale;
    }
    
    CGRect buttonFrame = CGRectMake(0, (navigationHeight - height) / 2, width, height);
    
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    button.tag = 1;
    
    if( title == nil || [title length] == 0 ) {
        [button setImage:image forState:UIControlStateNormal];
    } else {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
    }

    [button setShowsTouchWhenHighlighted:YES];

    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    if( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [negativeSpacer setWidth:-15];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,barButton,nil];
    } else {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [negativeSpacer setWidth:-5];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,barButton,nil];
    }
    
}

- (void)setRightBarButtonItemWithImage:(UIImage *)image
                                title:(NSString *)title {
    
    
    CGSize imageSize = image.size;
    
    CGFloat scale = imageSize.height / navigationHeight;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if( scale > 1 ) {
        width /= scale;
        height /= scale;
    }
    
    CGRect buttonFrame = CGRectMake(0, (navigationHeight - height) / 2, width, height);
    
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    button.tag = 1;
    
    if( title == nil || [title length] == 0 ) {
        [button setImage:image forState:UIControlStateNormal];
    } else {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    [button setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    if( [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 ) {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:barButton,nil];
    } else {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [negativeSpacer setWidth:-10];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,barButton,nil];
    }
    
}

- (void)setRightBarButtonItemWithImage:(UIImage *)image
                                 title:(NSString *)title
                              selector:(SEL)selector {
    
    
    CGSize imageSize = image.size;
    
    CGFloat scale = imageSize.height / navigationHeight;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if( scale > 1 ) {
        width /= scale;
        height /= scale;
    }
    
    CGRect buttonFrame = CGRectMake(0, (navigationHeight - height) / 2, width, height);
    
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    button.tag = 1;
    
    if( title == nil || [title length] == 0 ) {
        [button setImage:image forState:UIControlStateNormal];
    } else {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    [button setShowsTouchWhenHighlighted:YES];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    if( [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 ) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [negativeSpacer setWidth:5];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,barButton,nil];
    } else {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [negativeSpacer setWidth:-5];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,barButton,nil];
    }
    
}


- (UIButton *)setRightBarButtonItemWithImage:(UIImage *)image
                         selectedImage:(UIImage *)selectedImage
                                 title:(NSString *)title
                              selector:(SEL)selector {
    
    
    CGSize imageSize = image.size;
    CGSize selectedImageSize = selectedImage.size;
    
    if( selectedImageSize.width > imageSize.width ) {
        imageSize = selectedImageSize;
    }
    
    CGFloat scale = imageSize.height / navigationHeight;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if( scale > 1 ) {
        width /= scale;
        height /= scale;
    }
    
    CGRect buttonFrame = CGRectMake(0, (navigationHeight - height) / 2, width, height);
    
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    button.tag = 1;
    
    if( title == nil || [title length] == 0 ) {
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:selectedImage forState:UIControlStateSelected];
    } else {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:selectedImage forState:UIControlStateSelected];
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    [button setShowsTouchWhenHighlighted:YES];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    if( [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 ) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [negativeSpacer setWidth:5];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,barButton,nil];
    } else {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [negativeSpacer setWidth:-5];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,barButton,nil];
    }
    
    return button;
    
}

- (void)setRightBarButtonItemsWithImageNamesAndTitles:(id)firstObject, ... {
    va_list args;
    va_start(args, firstObject);
    
    id arg = nil;
    while ((arg = va_arg(args,id))) {
        
    }
    
    va_end(args);
}


- (void)setRightBarButtonWith:(UIBarButtonSystemItem)barButtonSystemItem {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:barButtonSystemItem target:self action:nil];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightButton, nil];
}

- (void)setRightBarButtonWithTitle:(NSString *)title
                          andStyle:(UIBarButtonItemStyle)style {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:title style:style target:self action:nil];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightButton, nil];
}

- (void)initializeNavigationBarSimpleWithImage:(UIImage *)navigationImage {
    UIImage *image = [navigationImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 44, 0)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;

}

- (void)setTitleArrangement {
//    [[UIBarButtonItem appearance] setTitlePositionAdjustment:UIOffsetMake(-0.5, 0.0) forBarMetrics:UIBarMetricsDefault];

}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goHome {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setPanGestureRecognizer {
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)removePanGestureRecognizer {
    [self.view removeGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)addOrRemovePanGesture {
    [self setPanGestureRecognizer];
}

- (void)setNavigationWithNavigationBarHidden:(BOOL)navigationBarHidden andStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    [self.navigationController setNavigationBarHidden:navigationBarHidden];
        
    if( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ) {
        [[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle];
    }
}

- (void)setScreenTitleWithFontsAndTexts:(id)firstObject, ... {
    
    id eachObject;
    va_list argumentList;
    if (firstObject)
    {
        
        NSMutableArray *argumentsArray = [NSMutableArray new];
        [argumentsArray addObject:firstObject];
        va_start(argumentList, firstObject);          // scan for arguments after firstObject.
        while ((eachObject = va_arg(argumentList, id))) // get rest of the objects until nil is found
        {
            [argumentsArray addObject:eachObject];
            // do something with each object
        }
        va_end(argumentList);
        
        if( [argumentsArray count] > 0 && [argumentsArray count] % 2 == 0 ) {
            
            NSMutableAttributedString *titleAttributedText = [NSMutableAttributedString new];
            UILabel *titleLabel = [UILabel new];
            
            for( int i=0; i<[argumentsArray count]; i+=2 ) {
                
                UIFont *font = [argumentsArray objectAtIndex:i];
                NSString *text = [argumentsArray objectAtIndex:i+1];
                
                NSDictionary *fontDict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
                NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:text attributes:fontDict];
                [aAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:50/255.0f green:50/255.0f blue:50/255.0f alpha:1.0] range:(NSMakeRange(0, [text length]))];
                
                [titleAttributedText appendAttributedString:aAttrString];
                
            }
            
            titleLabel.attributedText = titleAttributedText;
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            [titleLabel sizeToFit];
            [self.navigationItem setTitleView:titleLabel];
            
        }
        
    }
    
}

@end
