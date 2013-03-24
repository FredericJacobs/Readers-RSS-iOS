//
//  RDSArticleViewController.h
//  Reade.rs
//
//  Created by Frederic Jacobs on 24/3/13.
//  Copyright (c) 2013 Frederic Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDSArticleViewController : UIViewController <UIScrollViewDelegate, UITextViewDelegate>

@property (nonatomic, retain) UITextView *textView;
@property (copy) NSDictionary *element_dictionary;
@property (nonatomic, retain) UIToolbar *toolbar;

@end
