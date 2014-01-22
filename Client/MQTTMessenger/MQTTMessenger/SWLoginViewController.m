//
//  SWLoginViewController.m
//  MQTTMessenger
//
//  Created by 王 松 on 14-1-16.
//  Copyright (c) 2014年 Song.Wang. All rights reserved.
//

#import "SWLoginViewController.h"

@interface SWLoginViewController ()

@end

@implementation SWLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.userNameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)login:(id)sender {
    if ([self.userNameTextField hasText]) {
        [[NSUserDefaults standardUserDefaults] setObject:self.userNameTextField.text forKey:@"ClientId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[SWAppDelegate shareInstance] login];
    }
}
@end
