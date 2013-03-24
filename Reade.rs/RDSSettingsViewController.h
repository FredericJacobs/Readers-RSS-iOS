//
//  RDSSettingsViewController.h
//  Reade.rs
//
//  Created by Frederic Jacobs on 9/2/13.
//  Copyright (c) 2013 Frederic Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface RDSSettingsViewController : UIViewController<FBLoginViewDelegate>{
	FBLoginView *logout;
}

@end
