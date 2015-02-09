//
//  DVDsViewController.m
//  RottenTomatoes
//
//  Created by Baeksan Oh on 2/8/15.
//  Copyright (c) 2015 cp. All rights reserved.
//

#import "DVDsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"
#import "MovieCollectionViewCell.h"
#import "MovieDetailedViewController.h"
#import "UIImageView+AFNetworkingFadingIn.h"

@interface DVDsViewController () <UICollectionViewDataSource, UICollectionViewDelegate,  UISearchBarDelegate>
@property NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property UILabel *alertLabel;
@property NSArray *respondedMovies;
@end

@implementation DVDsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"DVDs";
    self.view.backgroundColor = [UIColor whiteColor];
    self.moviesCollectionView.backgroundColor = [UIColor whiteColor];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.searchBar.delegate = self;
    [self.moviesCollectionView addSubview:self.searchBar];
    [self.moviesCollectionView setContentOffset:CGPointMake(0, 44)];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.moviesCollectionView insertSubview:self.refreshControl atIndex:0];
    
    [self.moviesCollectionView registerNib:[UINib nibWithNibName:@"MovieCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MovieCollectionViewCell"];
    
    self.moviesCollectionView.delegate = self;
    self.moviesCollectionView.dataSource = self;
    [self.moviesCollectionView insertSubview:self.refreshControl atIndex:0];
    
    [self createAlertLabel];
    
    // Initial request to fill the table view
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/new_releases.json?apikey=679q52hb3yc4e7pz23zgphwe"];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [SVProgressHUD show];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            [self addAlert];
        } else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.respondedMovies = responseDict[@"movies"];
            self.movies = responseDict[@"movies"];
            NSLog(@"response: %@", self.movies);
            [self.moviesCollectionView reloadData];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
}

/*- (void) viewWillAppear:(BOOL)animated{
    // to show search bar
    //[self.moviesCollectionView setContentOffset:CGPointMake(0, 0)];
}*/


#pragma mark - UISearchBarDelegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setText:@""];
    [searchBar setShowsCancelButton:NO animated:YES];
    self.movies = self.respondedMovies;
    [self.moviesCollectionView reloadData];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {

    NSString *searchRegex = [searchText stringByReplacingOccurrencesOfString:@"*" withString:@".*"];
    NSString *regex = [NSString stringWithFormat:@"%@.*", searchRegex];
    NSMutableArray *filteredMovies = [[NSMutableArray alloc] init];
    for (NSDictionary *movie in self.respondedMovies) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(title MATCHES[cd] %@)", regex];
        BOOL result = [predicate evaluateWithObject:movie];
        if (result) {
            [filteredMovies addObject:movie];
        }
    }
    
    self.movies = filteredMovies;
    [self.moviesCollectionView reloadData];
    [self.searchBar becomeFirstResponder]; //need this because reloadData will re-add the searchbar as well
}

# pragma mark UIRefreshControl

- (void) onRefresh {
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/new_releases.json?apikey=679q52hb3yc4e7pz23zgphwe"];
    
    [self dismissAlert];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            [self addAlert];
        } else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.respondedMovies = responseDict[@"movies"];
            if (self.searchBar.isFirstResponder || self.searchBar.text.length > 0) {
                [self searchBar:self.searchBar
                  textDidChange:self.searchBar.text];
            }
            //self.movies = responseDict[@"movies"];
            //NSLog(@"response: %@", self.movies);
            //[self.moviesCollectionView reloadData];
        }
        
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieCollectionViewCell *cell = [self.moviesCollectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionViewCell"  forIndexPath:indexPath];
    
    NSDictionary *movie = self.movies[indexPath.row];
    NSLog(@"movie=%@",movie);
    cell.movieNameLabel.text = movie[@"title"];
    NSString *posterURLString = [movie[@"posters"][@"thumbnail"] stringByReplacingOccurrencesOfString:@"_tmb" withString:@"_ori"];
    [cell.posterView setImageWithURL:posterURLString fadingInDuration:0.3];
    return cell;
}


- (void) createAlertLabel {
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"warning_24_ns.png"];
    
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] init];
    [myString appendAttributedString:attachmentString];
    [myString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"Network Error"]];
    self.alertLabel = [[UILabel alloc] init];
    self.alertLabel.attributedText = myString;
    self.alertLabel.font = [UIFont systemFontOfSize:14];
    self.alertLabel.textColor = [UIColor whiteColor];
    self.alertLabel.adjustsFontSizeToFitWidth = NO;
    self.alertLabel.backgroundColor = [UIColor grayColor];
    self.alertLabel.alpha = 1;
    self.alertLabel.textAlignment = NSTextAlignmentCenter;
    
    self.alertLabel.frame = CGRectMake(0, 62, self.moviesCollectionView.frame.size.width, 50);
}

- (void) addAlert {
    [self.view addSubview:self.alertLabel];
}

- (void) dismissAlert {
    [self.alertLabel removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MovieDetailedViewController *detailedVC = [[MovieDetailedViewController alloc] init];
    NSIndexPath *selectedIndex = self.moviesCollectionView.indexPathsForSelectedItems[0];
    NSDictionary *movie = self.movies[selectedIndex.row];
    NSLog(@"movie=%@",movie);
    
    detailedVC.movieName = movie[@"title"];
    detailedVC.movieDetails = movie[@"synopsis"];
    detailedVC.posterURLString = [movie[@"posters"][@"thumbnail"] stringByReplacingOccurrencesOfString:@"_tmb" withString:@"_ori"];
    [self.navigationController pushViewController:detailedVC animated:YES];
    [self.searchBar resignFirstResponder];
    [self.moviesCollectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
