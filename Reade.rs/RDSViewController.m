//
//  RDSViewController.m
//  Reade.rs
//
//  Created by Frederic Jacobs on 6/2/13.
//  Copyright (c) 2013 Frederic Jacobs. All rights reserved.
//

#import "RDSViewController.h"
#import "RDSNavigationBarView.h"
#import "RDSSettingsViewController.h"
#import "AFNetworking.h"
#import "RDSAppDelegate.h"
#import "RDSFeedCell.h"
#import "RDSArticleCell.h"
#import <FacebookSDK/FacebookSDK.h>
#import "RDSArticleViewController.h"
#import "DTCoreText.h"

@interface RDSViewController ()<FBLoginViewDelegate>

@end

@implementation RDSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.titleView = [[RDSNavigationBarView alloc] initWithFrame:CGRectMake(-5, 0, [[UIScreen mainScreen] bounds].size.width, 44)];
    
	[[NSUserDefaults standardUserDefaults]setValue:@"SID=s%3AFNDeGDoIPU7%2BGbnNRdl%2FCRSB.yv66k7LMESgXReAUUFdmQccWGONET1aVoSAl4pNywzc" forKey:@"SID"];
	
    if (!([[NSUserDefaults standardUserDefaults]objectForKey:@"SID"]) && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        welcomView = [[RDSWelcomeView alloc] initWithFrame:self.view.frame];
		FBLoginView *loginview = [[FBLoginView alloc] init];
		loginview.delegate = self;
        welcomView.loginView = loginview;
		[loginview sizeToFit];
		[self.view addSubview:welcomView];
    }else{
		
		self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, self.view.frame.size.height-44) style:UITableViewStylePlain];
		UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc]initWithCustomView:[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)]];
		
		UIButton *button = ((UIButton*)settingsButton.customView);
		[button setImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
		[button addTarget:self action:@selector(presentSettings) forControlEvents:UIControlEventTouchUpInside];
		
		settingsButton.customView.backgroundColor = [RDSStyleDefaults colorForNavigationBar];
		settingsButton.customView.frame = CGRectMake(0, 0, 25, 25);
		
		self.navigationItem.rightBarButtonItem = settingsButton;
		
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		self.refreshControl = [[UIRefreshControl alloc] init];
		[self.refreshControl addTarget:self action:@selector(updateData) forControlEvents:UIControlEventValueChanged];
		[self.tableView addSubview:self.refreshControl];
		[self.view addSubview:self.tableView];
		
		self.subscriptions = [NSMutableArray array];
		
		[self.refreshControl beginRefreshing];
		[self updateData];
	}
}

- (void) updateData {
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[rdsapihost stringByAppendingString:@"/subscriptions"]]];
	request.HTTPMethod = @"GET";
	[request addValue:[NSString stringWithFormat:@"SID=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"SID"]] forHTTPHeaderField:@"Cookie"];
	
	[[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		
		self.dropdowns = [NSMutableArray array];
		
		self.subscriptions = [JSON objectForKey:@"feeds"];
		
		//Adding subscriptions and dropdowns arrays
		
		self.headLines = [JSON objectForKey:@"headlines"];
		
		
		NSLog(@"Subscriptions : %@ Headlines : %@", self.subscriptions, self.headLines);
		
		NSMutableArray *elts = [NSMutableArray array];
		for (int i = 0; i < [self.headLines count]; i++) {
			VPPDropDownElement *e = [[VPPDropDownElement alloc] initWithTitle:[[self.headLines objectAtIndex:i] valueForKeyPath:@"article.title"] andObject:[[self.headLines objectAtIndex:i] objectForKey:@"article"]];
			[elts addObject:e];
		}
		
		VPPDropDown *dropDownCustom = [[VPPDropDown alloc] initWithTitle:@"Recommended"
																	type:VPPDropDownTypeCustom
															   tableView:self.tableView
															   indexPath:[NSIndexPath indexPathForRow:0 inSection:0]
																elements:elts
																delegate:self];
		[self.dropdowns addObject:dropDownCustom];
		
		for (int i = 0; i < [self.subscriptions count]; i++) {
			NSLog(@"Syncing feed : %@", [[self.subscriptions objectAtIndex:i]objectForKey:@"title"]);
			NSMutableArray *elts = [NSMutableArray array];
			for (int j = 0; j < [[[self.subscriptions objectAtIndex:i] objectForKey:@"articles"] count]; j++) {
				// just some mock elements
				
				VPPDropDownElement *e = [[VPPDropDownElement alloc] initWithTitle:[[[[self.subscriptions objectAtIndex:i] objectForKey:@"articles"] objectAtIndex:j] objectForKey:@"title"] andObject:[[[self.subscriptions objectAtIndex:i] objectForKey:@"articles"] objectAtIndex:j]];
				[elts addObject:e];
			}
			
			VPPDropDown *dropDownCustom = [[VPPDropDown alloc] initWithTitle:[[[self.subscriptions objectAtIndex:i] objectForKey:@"title"]stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"]
																		type:VPPDropDownTypeCustom
																   tableView:self.tableView
																   indexPath:[NSIndexPath indexPathForRow:0 inSection:i+1]
																	elements:elts
																	delegate:self];
			[self.dropdowns addObject:dropDownCustom];
		}
		
		[self.tableView reloadData];
		[self.refreshControl endRefreshing];
		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		NSLog(@"Fail");
		[self.refreshControl endRefreshing];
	}]start];
	
}


- (void) loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
	self.currentUser = [[RDSUser alloc] init];
	self.currentUser.last_name = user.last_name;
	self.currentUser.first_name = user.first_name;
	self.currentUser.email = [self urlEncodeUsingEncoding:NSUTF8StringEncoding string:[user objectForKey:@"email"]];
	self.currentUser.fbUserID = user.id;
}

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding string:(NSString*)string{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
																				 (CFStringRef)string,
																				 NULL,
																				 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
																				 CFStringConvertNSStringEncodingToEncoding(encoding)));
}


-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
	
	//[welcomView animateDisspearence];
	
	NSString *parameterString = @"?output=json";
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[[[rdsapihost stringByAppendingString:@"/users/register"] stringByAppendingFormat:@"%@",parameterString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	
	request.HTTPBody = [[NSString stringWithFormat:@"lastName=%@&firstName=%@&email=%@&fbUserId=%@", self.currentUser.last_name, self.currentUser.first_name, self.currentUser.email, self.currentUser.fbUserID]dataUsingEncoding:NSUTF8StringEncoding];
	
	request.HTTPMethod = @"POST";
	
	RDSAppDelegate *delegate = (RDSAppDelegate*)[[UIApplication sharedApplication]delegate];
	
	[[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		[[NSUserDefaults standardUserDefaults] setValue:[[response allHeaderFields] objectForKey:@"Set-Cookie"] forKey:@"SID"];

		
		NSLog(@"User logged in, headers : %@",[response allHeaderFields]);
		[delegate reloadViewHierarchy];
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		NSLog(@"Fail:%i, err ", response.statusCode);
		
		//[delegate reloadViewHierarchy];
	}]start];
	
}

- (void) presentSettings{
    [self presentViewController:[[RDSSettingsViewController alloc]init] animated:YES completion:nil];
}

#pragma mark TableViewDelegateMethods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return [_subscriptions count]+1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	int rows = [VPPDropDown tableView:tableView numberOfExpandedRowsInSection:section];
	return 1+rows;
}


#pragma mark DropDown


#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return [VPPDropDown tableView:tableView heightForRowAtIndexPath:indexPath];
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    // Configure the cell...
    cell.textLabel.text = nil;
	
    if ([VPPDropDown tableView:tableView dropdownsContainIndexPath:indexPath]) {
        return [VPPDropDown tableView:tableView cellForRowAtIndexPath:indexPath];
    }
	
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([VPPDropDown tableView:tableView dropdownsContainIndexPath:indexPath]) {
        [VPPDropDown tableView:tableView didSelectRowAtIndexPath:indexPath];
        return;
    }
}


#pragma mark - VPPDropDownDelegate

- (void) dropDown:(VPPDropDown *)dropDown elementSelected:(VPPDropDownElement *)element atGlobalIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	RDSAppDelegate *delegate = (RDSAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	RDSArticleViewController *articleVC = (RDSArticleViewController*)delegate.deckController.rightController;
	
	NSDictionary *builderOptions = @{
								  DTDefaultFontFamily: @"Avenir",
	      DTDefaultFontSize:@16,
		  DTUseiOS6Attributes: @YES,
		  };
	
	articleVC.textView.attributedText = [[NSAttributedString alloc] initWithHTMLData:[[element.object objectForKey:@"description"] dataUsingEncoding:NSUTF8StringEncoding]options:builderOptions documentAttributes:nil ];
	
	[articleVC.textView setContentOffset:CGPointMake(0, 0) animated:YES];
	
	articleVC.element_dictionary = element.object;
	
	[delegate.deckController openRightViewAnimated:YES];
	
}
- (UITableViewCell *) dropDown:(VPPDropDown *)dropDown rootCellAtGlobalIndexPath:(NSIndexPath *)globalIndexPath {
	RDSFeedCell *cell = [[RDSFeedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"whatever"];
	cell.titleLabel.text = dropDown.title;
    return cell;
}
- (UITableViewCell *) dropDown:(VPPDropDown *)dropDown cellForElement:(VPPDropDownElement *)element atGlobalIndexPath:(NSIndexPath *)globalIndexPath {
    static NSString *cellIdentifier = @"CustomDropDownCell";
	
    RDSArticleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[RDSArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"whatever2"];
    }
    
    cell.textLabel.text = nil;
	cell.titleLabel.text = element.title;
    
    return cell;
}


- (CGFloat) dropDown:(VPPDropDown *)dropDown heightForElement:(VPPDropDownElement *)element atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
		return feedCellRowHeight;
	}
	else{
		return articleCellRowHeight;
	}
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_ipToDeselect != nil) {
        [self.tableView deselectRowAtIndexPath:_ipToDeselect animated:YES];
        _ipToDeselect = nil;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
	
    if (welcomView) {
        [welcomView animateAppearence];
    }
}

@end
