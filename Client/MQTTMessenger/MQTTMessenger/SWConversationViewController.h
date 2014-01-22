//
//  SWConversationViewController.h
//  MQTTMessenger
//
//  Created by 王 松 on 14-1-16.
//  Copyright (c) 2014年 Song.Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HPGrowingTextView;

@interface SWConversationViewController : UIViewController
{
    CGFloat _keyboarHeight;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet HPGrowingTextView *messageTextView;

@property (strong, nonatomic) NSString *toUser;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
