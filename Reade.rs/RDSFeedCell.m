//
//  RDSFeedCell.m
//  Reade.rs
//
//  Created by Frederic Jacobs on 24/3/13.
//  Copyright (c) 2013 Frederic Jacobs. All rights reserved.
//

#import "RDSFeedCell.h"

@implementation RDSFeedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, feedCellRowHeight)];
		self.backgroundColor = [UIColor colorWithIntRed:0 green:51 blue:102 alpha:0.2];
		self.titleLabel.textAlignment = NSTextAlignmentCenter;
		self.titleLabel.backgroundColor = [UIColor colorWithIntRed:0 green:51 blue:102 alpha:0.2];
		[self.contentView addSubview:self.titleLabel];
		self.titleLabel.font = [UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:50];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
