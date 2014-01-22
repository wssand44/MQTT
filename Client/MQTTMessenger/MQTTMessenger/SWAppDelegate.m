//
//  SWAppDelegate.m
//  MQTTMessenger
//
//  Created by 王 松 on 14-1-15.
//  Copyright (c) 2014年 Song.Wang. All rights reserved.
//

#import "SWAppDelegate.h"

#import "MQTTSession.h"

#import "Message+Parser.h"

#import "SWMasterViewController.h"

@interface SWAppDelegate ()

@property (nonatomic, strong) MQTTSession *session;

@end

@implementation SWAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    _currentUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"ClientId"];
    if (self.currentUser) {
        [self login];
    }
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self.session close];
    [self saveContext];
}

- (void)login
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"RootView"];
    SWMasterViewController *controller = (SWMasterViewController *)navigationController.topViewController;
    controller.managedObjectContext = self.managedObjectContext;
    self.window.rootViewController = navigationController;
    [self performSelectorInBackground:@selector(connectToServer) withObject:nil];
}

- (void)connectToServer
{
    _currentUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"ClientId"];
    if (_currentUser) {
        _session = [[MQTTSession alloc] initWithClientId:self.currentUser];
        [self.session setDelegate:self];
        [self.session connectToHost:kIP port:1883];
    }
}

- (void)subscribe:(NSString *)topic {
    [self.session subscribeTopic:topic];
}

- (void)sendMessage:(NSString *)msg toUser:(NSString *)toUser {
    
    NSDictionary *msgDict = @{@"to": toUser, @"from": self.currentUser, @"message": msg};
    
    NSData *pubData = [NSJSONSerialization dataWithJSONObject:msgDict options:NSJSONWritingPrettyPrinted error:nil];
    
    [self.session publishDataAtLeastOnce:pubData onTopic:kTopic];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
    Message *message = [[Message alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    message.to = toUser;
    message.from = self.currentUser;
    message.message = msg;
    message.timestamp = [NSDate date];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - MQtt Callback methods

- (void)session:(MQTTSession*)sender handleEvent:(MQTTSessionEvent)eventCode {
    switch (eventCode) {
        case MQTTSessionEventConnected:
            NSLog(@"connected");
            [self subscribe:kTopic];
            break;
        case MQTTSessionEventConnectionRefused:
            NSLog(@"connection refused");
            break;
        case MQTTSessionEventConnectionClosed:
            NSLog(@"connection closed");
            break;
        case MQTTSessionEventConnectionError:
            NSLog(@"connection error");
            NSLog(@"reconnecting...");
            // Forcing reconnection
            [self.session connectToHost:kIP port:1883];
            break;
        case MQTTSessionEventProtocolError:
            NSLog(@"protocol error");
            break;
    }
}

- (void)session:(MQTTSession*)sender
     newMessage:(NSData*)data
        onTopic:(NSString*)topic {
    NSLog(@"new message, %d bytes, topic=%@", [data length], topic);
    NSString *payloadString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data: %@ %@", payloadString, data);
    [Message parseMessage:data];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MQTTMessenger" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MQTTMessenger.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (SWAppDelegate *)shareInstance
{
    return (SWAppDelegate *)[UIApplication sharedApplication].delegate;
}


@end
