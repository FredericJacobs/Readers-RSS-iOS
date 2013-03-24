//
//  RDSNavigationBarView.m
//  Reade.rs
//
//  Created by Frederic Jacobs on 9/2/13.
//  Copyright (c) 2013 Frederic Jacobs. All rights reserved.
//

#import "RDSNavigationBarView.h"

@implementation RDSNavigationBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [RDSStyleDefaults colorForNavigationBar];
        
        UIView *backGroundView = [[UIView alloc]initWithFrame:self.frame];
        backGroundView.backgroundColor = [RDSStyleDefaults colorForNavigationBar];
        
        float verticalOffset = 8;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x, verticalOffset, self.frame.size.width, self.frame.size.height - verticalOffset)];
        
        titleLabel.text = kNameOfProject;
        titleLabel.backgroundColor = [RDSStyleDefaults colorForNavigationBar];
        titleLabel.font = [RDSStyleDefaults fontForNavigationBar];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [RDSStyleDefaults colorForNavigationBarText];
        
        [self addSubview:backGroundView];
        [self addSubview:titleLabel];
        
    }
    return self;
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
