//
//  MovieDetailedViewController.h
//  RottenTomatoes
//
//  Created by Baeksan Oh on 2/8/15.
//  Copyright (c) 2015 cp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailedViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *movieNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *movieDetailsTextView;
@property (strong, nonatomic) IBOutlet UIImageView *posterView;
@property (strong, nonatomic) NSString *posterURLString;
@property (strong, nonatomic) NSString *movieName;
@property (strong, nonatomic) NSString *movieDetails;
@end
