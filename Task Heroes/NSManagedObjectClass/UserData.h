//
//  UserData.h
//  
//
//  Created by Andreea-Daniela Ene on 01/06/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserData : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * id_user;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSNumber * points;
@property (nonatomic, retain) NSString * doneTasks;
@property (nonatomic, retain) NSString * undoneTasks;

@end
