//
//  MovieTableViewCell.h
//  RottenTomatoes
//
//  Created by Baeksan Oh on 2/7/15.
//  Copyright (c) 2015 cp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *posterView;
@property (strong, nonatomic) IBOutlet UILabel *movieNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *movieTextView;

@end
