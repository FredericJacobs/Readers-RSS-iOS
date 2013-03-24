//
//  RDSArticleCell.m
//  Reade.rs
//
//  Created by Frederic Jacobs on 24/3/13.
//  Copyright (c) 2013 Frederic Jacobs. All rights reserved.
//

#import "RDSArticleCell.h"

@implementation RDSArticleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, articleCellRowHeight)];
		self.backgroundColor = [UIColor blueColor];
		self.titleLabel.textAlignment = NSTextAlignmentCenter;
		self.titleLabel.backgroundColor = [UIColor whiteColor];
		[self.contentView addSubview:self.titleLabel];
		self.titleLabel.font = [UIFont fontWithName:@"YanoneKaffeesatz-Light" size:20];
		self.titleLabel.numberOfLines = 2;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
