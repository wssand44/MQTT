//
//  SWMessage+Parser.m
//  MQTTMessenger
//
//  Created by 王 松 on 14-1-15.
//  Copyright (c) 2014年 Song.Wang. All rights reserved.
//

#import "Message+Parser.h"

@implementation Message (Parser)

+ (Message *)parseMessage:(NSData *)json
{
    NSDictionary *dict = [NSJSONSerialization
                          JSONObjectWithData:json options:NSJSONReadingAllowFragments
                          error:nil];
    
    NSString *toUser = [dict objectForKey:@"to"];
    NSString *fromUser = [dict objectForKey:@"from"];
    if (![toUser isEqual:fromUser]) {
        NSManagedObjectContext *context = [SWAppDelegate shareInstance].managedObjectContext;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Message" inManagedObjectContext:context];
        Message *message = [[Message alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        
        message.to = toUser;
        message.from = fromUser;
        message.message = [dict objectForKey:@"message"];
        message.timestamp = [NSDate date];
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        return message;
    }
    return false;
}

@end
