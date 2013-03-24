//
//  WelcomView.m
//  Reade.rs
//
//  Created by Frederic Jacobs on 9/2/13.
//  Copyright (c) 2013 Frederic Jacobs. All rights reserved.
//

#import "RDSWelcomeView.h"

@implementation RDSWelcomeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIColor *colorForText = [UIColor colorWithIntRed:69 green:64 blue:64 alpha:1];
        
        welcomeLabel = [[UILabel alloc] initWithFrame:([[UIScreen mainScreen] bounds].size.height == 480)?CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width, 45):CGRectMake(0, 45, [[UIScreen mainScreen] bounds].size.width, 45)];
        
        welcomeLabel.text = @"Welcome !";
        welcomeLabel.textColor = colorForText;
        welcomeLabel.textAlignment = NSTextAlignmentCenter;
        welcomeLabel.backgroundColor = [UIColor whiteColor];
        welcomeLabel.font = [UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:53];
        
        letsGetStarted = [[UILabel alloc]initWithFrame:([[UIScreen mainScreen] bounds].size.height == 480)?CGRectMake(0, 80, [[UIScreen mainScreen]bounds].size.width, 40):CGRectMake(0, 125,[[UIScreen mainScreen]bounds].size.width, 40)];
        letsGetStarted.text = @"Let's get started";
        letsGetStarted.textColor = colorForText;
        letsGetStarted.backgroundColor = [UIColor whiteColor];
        letsGetStarted.textAlignment = NSTextAlignmentCenter;
        letsGetStarted.font = [UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:32];
        
        welcomeLabel.alpha = 0;
        letsGetStarted.alpha = 0;
		
        [self addSubview:welcomeLabel];
        [self addSubview:letsGetStarted];
		
    }
    return self;
}

- (void) animateAppearence {
	
	self.loginView.alpha = 0;
	self.loginView.frame = CGRectOffset(self.loginView.frame, 90, 260);
	[self addSubview:self.loginView];
	
    [UIView animateWithDuration:0.3 animations:^{
        welcomeLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            letsGetStarted.alpha = 1;
        } completion:^(BOOL finished) {
			[UIView animateWithDuration:0.3 animations:^{
				NSLog(@"Login View : %@", self.loginView);
				self.loginView.alpha = 1;
			}];
		}];
	}];
}

- (void) animateDisspearence {
	[UIView animateWithDuration:0.4 animations:^{
        welcomeLabel.alpha = 0;
		letsGetStarted.alpha = 0;
		self.loginView.alpha = 0;
		
	} completion:^(BOOL finished) {
		[self removeFromSuperview];
	}];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
