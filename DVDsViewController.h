//
//  DVDsViewController.h
//  RottenTomatoes
//
//  Created by Baeksan Oh on 2/8/15.
//  Copyright (c) 2015 cp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVDsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UICollectionView *moviesCollectionView;
@property (strong, nonatomic) UISearchBar *searchBar;
@end
