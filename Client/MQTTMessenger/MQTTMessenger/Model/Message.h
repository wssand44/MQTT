//
//  Message.h
//  MQTTMessenger
//
//  Created by 王 松 on 14-1-17.
//  Copyright (c) 2014年 Song.Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Message : NSManagedObject

@property (nonatomic, retain) NSString * from;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * to;

@end
