//
//  RDSSettingsViewController.m
//  Reade.rs
//
//  Created by Frederic Jacobs on 9/2/13.
//  Copyright (c) 2013 Frederic Jacobs. All rights reserved.
//

#import "RDSSettingsViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "RDSAppDelegate.h"

@interface RDSSettingsViewController ()

@end

@implementation RDSSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        logout = [[FBLoginView alloc]init];
		logout.frame = CGRectOffset(logout.frame, 100, 100);
		logout.delegate = self;
		[self.view addSubview:logout];
    }
    return self;
}

- (void) loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
	[self dismissViewControllerAnimated:YES completion:nil];
	[[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SID"];
    RDSAppDelegate *delegate = (RDSAppDelegate*) [[UIApplication sharedApplication]delegate];
    [delegate reloadViewHierarchy];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
