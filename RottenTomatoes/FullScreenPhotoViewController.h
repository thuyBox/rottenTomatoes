//
//  FullScreenPhotoViewController.h
//  RottenTomatoes
//
//  Created by Baeksan Oh on 2/8/15.
//  Copyright (c) 2015 cp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullScreenPhotoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *posterView;
- (IBAction)closeButtonClicked:(id)sender;
@property UIImage *poster;
@end
