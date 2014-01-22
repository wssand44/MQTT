//
//  SWAppDelegate.h
//  MQTTMessenger
//
//  Created by 王 松 on 14-1-15.
//  Copyright (c) 2014年 Song.Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTopic @"MQTTMessenger"

#define kIP @"172.20.50.25"

@interface SWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (readonly, strong, nonatomic) NSString *currentUser;

- (void)saveContext;

- (NSURL *)applicationDocumentsDirectory;

- (void)login;

- (void)connectToServer;

- (void)sendMessage:(NSString *)message toUser:(NSString *)toUser;

+ (SWAppDelegate *)shareInstance;

@end
