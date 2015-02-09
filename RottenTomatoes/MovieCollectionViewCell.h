//
//  MovieCollectionViewCell.h
//  RottenTomatoes
//
//  Created by Baeksan Oh on 2/8/15.
//  Copyright (c) 2015 cp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *posterView;
@property (strong, nonatomic) IBOutlet UILabel *movieNameLabel;

@end
