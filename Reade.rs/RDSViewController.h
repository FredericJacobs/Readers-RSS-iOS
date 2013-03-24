//
//  RDSViewController.h
//  Reade.rs
//
//  Created by Frederic Jacobs on 6/2/13.
//  Copyright (c) 2013 Frederic Jacobs. All rights reserved.
//
#import "RDSWelcomeView.h"
#import <UIKit/UIKit.h>
#import "RDSUser.h"
#import "VPPDropDown.h"

@interface RDSViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, VPPDropDownDelegate>{
    RDSWelcomeView *welcomView;
	NSIndexPath *_ipToDeselect;
}

@property NSArray *subscriptions;
@property NSArray *headLines;
@property UITableView *tableView;
@property RDSUser *currentUser;
@property NSMutableArray *dropdowns;
@property (nonatomic, retain) UIRefreshControl *refreshControl;


@end
