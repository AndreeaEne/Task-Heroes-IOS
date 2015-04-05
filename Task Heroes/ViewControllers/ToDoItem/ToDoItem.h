//
//  ToDoItem.h
//  Task Heroes
//
//  Created by Andreea-Daniela Ene on 05/04/15.
//  Copyright (c) 2015 Andreea-Daniela Ene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject

@property NSString *itemName;
@property BOOL completed;
@property (readonly) NSDate *creationDate;

@end
