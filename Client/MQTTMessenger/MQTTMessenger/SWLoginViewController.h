//
//  SWLoginViewController.h
//  MQTTMessenger
//
//  Created by 王 松 on 14-1-16.
//  Copyright (c) 2014年 Song.Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

- (IBAction)login:(id)sender;

@end
