//
//  User.h
//  MQTTMessenger
//
//  Created by 王 松 on 14-1-17.
//  Copyright (c) 2014年 Song.Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * userId;

@end
