//
//  MoviesViewController.h
//  RottenTomatoes
//
//  Created by Baeksan Oh on 2/7/15.
//  Copyright (c) 2015 cp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviesViewController : UIViewController
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *moviesTableView;
//@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
//@property (strong, nonatomic) UITableView *moviesTableView;
//@property (strong, nonatomic) UISegmentedControl *segmentedControl;
//@property UICollectionView *moviesCollectionView;
@end
