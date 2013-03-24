//
//  RDSAppDelegate.m
//  Reade.rs
//
//  Created by Frederic Jacobs on 6/2/13.
//  Copyright (c) 2013 Frederic Jacobs. All rights reserved.
//

#import "RDSAppDelegate.h"

#import "RDSArticleViewController.h"
#import "RDSViewController.h"

@interface RDSAppDelegate ()

@end

@implementation RDSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{     
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UINavigationController *navCenterController =[[UINavigationController alloc]initWithRootViewController:[[RDSViewController alloc] initWithNibName:@"RDSViewController_iPhone" bundle:nil]];
	
    _deckController =  [[IIViewDeckController alloc] initWithCenterViewController:navCenterController
                                                               leftViewController:nil
                                                              rightViewController:nil];
	
	self.deckController.panningMode = IIViewDeckFullViewPanning;
	
    self.window.rootViewController = _deckController;
    [self.window makeKeyAndVisible];
	
	[self reloadViewHierarchy];
	
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	
	[self reloadViewHierarchy];
		
	return NO;
}

- (void) reloadViewHierarchy {
    
	[self.window resignKeyWindow];
	
	UIViewController *navCenterController = [[UINavigationController alloc]initWithRootViewController:[[RDSViewController alloc] initWithNibName:@"RDSViewController_iPhone" bundle:nil]];
	
	UIViewController *rightVC = nil;
	
	if (([[NSUserDefaults standardUserDefaults]objectForKey:@"SID"])) {
		rightVC = [[RDSArticleViewController alloc]initWithNibName:nil bundle:nil];
		self.deckController.panningMode = IIViewDeckFullViewPanning;
		self.deckController.rightSize = 0;
	}
	
	_deckController =  [[IIViewDeckController alloc] initWithCenterViewController:navCenterController
                                                               leftViewController:nil
                                                              rightViewController:rightVC];
    
    self.window.rootViewController = self.deckController;
	
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // FBSample logic
    // if the app is going away, we close the session object
    [FBSession.activeSession close];
}
- (void)applicationDidBecomeActive:(UIApplication *)application	{
    // FBSample logic
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}




@end
