//
//  RDSAppDelegate.h
//  Reade.rs
//
//  Created by Frederic Jacobs on 6/2/13.
//  Copyright (c) 2013 Frederic Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "IIViewDeckController.h"

@class RDSViewController;

@interface RDSAppDelegate : UIResponder <UIApplicationDelegate>{
    NSString *relinkUserId;
}

@property (strong, nonatomic) UIWindow *window;

@property (retain, nonatomic) IIViewDeckController *deckController;

- (void) reloadViewHierarchy ;

@end
