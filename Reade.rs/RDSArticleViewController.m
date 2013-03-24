//
//  RDSArticleViewController.m
//  Reade.rs
//
//  Created by Frederic Jacobs on 24/3/13.
//  Copyright (c) 2013 Frederic Jacobs. All rights reserved.
//

#import "RDSArticleViewController.h"
#import <Social/Social.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface RDSArticleViewController (){
	CGFloat startContentOffset;
	CGFloat lastContentOffset;
	BOOL hidden;
}
@end

@implementation RDSArticleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.view.backgroundColor = [UIColor redColor];
		self.textView = [[UITextView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
		self.textView.editable= FALSE;
		self.textView.delegate = self;
		[self.view addSubview:self.textView];
		self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, 320, 44)];
		[self.view addSubview:self.toolbar];
		
		UIBarButtonItem *liking = [[UIBarButtonItem alloc]initWithTitle:@"Like" style:UIBarButtonItemStyleBordered target:self action:@selector(likeArticle)];
		NSMutableArray *items = [NSMutableArray array];
		
		UIBarButtonItem *sharing = [[UIBarButtonItem alloc]initWithTitle:@"Share" style:UIBarButtonItemStyleBordered target:self action:@selector(shareArticle)];
	
		[items addObject:liking];
		[items addObject:sharing];
		
		self.toolbar.items = items;
		self.toolbar.translucent = YES;
		UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"Highlight" action:@selector(highlight:)];
		[[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:menuItem]];
		
    }
    return self;
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
	if (action == @selector(highlight:)) {
		if (self.textView.selectedRange.length > 0) {
			return YES;
		}
	}
	return NO;
}

- (void) highlight:(id)sender {
	
	NSMakeRange(self.textView.selectedRange.location, self.textView.selectedRange.length);
	
	NSMutableAttributedString *text = [self.textView.attributedText mutableCopy];
	
	[text replaceCharactersInRange:self.textView.selectedRange withAttributedString:[[NSAttributedString alloc] initWithString:[self.textView textInRange:self.textView.selectedTextRange] attributes:@{NSBackgroundColorAttributeName:[UIColor yellowColor]}]];
	self.textView.attributedText = text;
}

- (void) shareArticle{
	UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[[NSURL URLWithString:[self.element_dictionary objectForKey:@"link"]]] applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (void) likeArticle{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[rdsapihost stringByAppendingString:@"/likes"]]];
	request.HTTPMethod = @"POST";
	[request addValue:[NSString stringWithFormat:@"SID=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"SID"]] forHTTPHeaderField:@"Cookie"];
	NSDictionary *postID = @{@"postId": [self.element_dictionary objectForKey:@"id"]};
	request.HTTPBody = [NSJSONSerialization dataWithJSONObject:postID options:0 error:nil];
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = @"Posting";
	[[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		if (response.statusCode == 200) {
			[MBProgressHUD hideHUDForView:self.view animated:YES];
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Liked" message:@"Looks like it's the first time you like an article. This is a neat way of recommanding it to your friends." delegate:nil cancelButtonTitle:@"I get it" otherButtonTitles:nil, nil];
			[alertView show];
		}
		else{
			[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		}
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
	}]start];
}

- (void) hideToolBar{
	[UIView animateWithDuration:0.4 animations:^{
		self.toolbar.frame = CGRectOffset(self.toolbar.frame, 0, 44);
	} completion:^(BOOL finished) {
		
	}];
}

- (void) showToolBar{
	[UIView animateWithDuration:0.4 animations:^{
		self.toolbar.frame = CGRectOffset(self.toolbar.frame, 0, -44);
	} completion:^(BOOL finished) {
		
	}];
}

#pragma mark - The Magic!

-(void)expand
{
    if(hidden)
        return;
    
    hidden = YES;
    
    [self hideToolBar];
}

-(void)contract
{
    if(!hidden)
        return;
    
    hidden = NO;
    
    [self showToolBar];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    startContentOffset = lastContentOffset = scrollView.contentOffset.y;
    //NSLog(@"scrollViewWillBeginDragging: %f", scrollView.contentOffset.y);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat differenceFromStart = startContentOffset - currentOffset;
    CGFloat differenceFromLast = lastContentOffset - currentOffset;
    lastContentOffset = currentOffset;
    
    
    
    if((differenceFromStart) < 0)
    {
        // scroll up
        if(scrollView.isTracking && (abs(differenceFromLast)>1))
            [self expand];
    }
    else {
        if(scrollView.isTracking && (abs(differenceFromLast)>1))
            [self contract];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    [self contract];
    return YES;
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
