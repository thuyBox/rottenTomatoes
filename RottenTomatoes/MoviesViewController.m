//
//  MoviesViewController.m
//  RottenTomatoes
//
//  Created by Baeksan Oh on 2/7/15.
//  Copyright (c) 2015 cp. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"
#import "MovieDetailedViewController.h"
#import "UIImageView+AFNetworkingFadingIn.h"

@interface MoviesViewController () <UITableViewDelegate, UITableViewDataSource,  UISearchBarDelegate>

@property NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property UILabel *alertLabel;
@property NSArray *respondedMovies;
@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=679q52hb3yc4e7pz23zgphwe
    //http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=679q52hb3yc4e7pz23zgphwe&page_limit=10&page=1&q=test

    self.navigationItem.title = @"Movies";
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.moviesTableView.tableHeaderView = self.searchBar;
    self.searchBar.delegate = self;
    
    // Add refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.moviesTableView insertSubview:self.refreshControl atIndex:0];
    
    // Add custom cell
    UINib *movieCellNib = [UINib nibWithNibName:@"MovieTableViewCell" bundle:nil];
    [self.moviesTableView registerNib:movieCellNib forCellReuseIdentifier:@"MovieTableViewCell"];
    
    // Set delegate/datasource for tableview
    self.moviesTableView.delegate = self;
    self.moviesTableView.dataSource = self;
    self.moviesTableView.rowHeight = 179;
    
    // Create alert label
    [self createAlertLabel];
    
    
    // Initial request to fill the table view
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=679q52hb3yc4e7pz23zgphwe"];
    
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
            [self.moviesTableView reloadData];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
}

#pragma mark - UISearchBarDelegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setText:@""];
    [searchBar setShowsCancelButton:NO animated:YES];
    self.movies = self.respondedMovies;
    [self.moviesTableView reloadData];
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
    [self.moviesTableView reloadData];
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
    
    self.alertLabel.frame = CGRectMake(0, 62, self.moviesTableView.frame.size.width, 50);
}

- (void) addAlert {
    [self.view addSubview:self.alertLabel];
}

- (void) dismissAlert {
    [self.alertLabel removeFromSuperview];
}

- (void)onRefresh {
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=679q52hb3yc4e7pz23zgphwe"];
    [self dismissAlert];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            [self addAlert];
        } else {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.respondedMovies = responseDict[@"movies"];
            [self searchBar:self.searchBar
              textDidChange:self.searchBar.text];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = [self.moviesTableView dequeueReusableCellWithIdentifier:@"MovieTableViewCell" forIndexPath:indexPath];
    cell.frame = CGRectMake(0,0,self.moviesTableView.frame.size.width,cell.frame.size.height);
    
    NSDictionary *movie = self.movies[indexPath.row];
    NSLog(@"movie=%@",movie);
    cell.movieNameLabel.text = movie[@"title"];
    cell.movieTextView.text = movie[@"synopsis"];
    NSString *posterURLString = [movie[@"posters"][@"thumbnail"] stringByReplacingOccurrencesOfString:@"_tmb" withString:@"_ori"];
    //NSURL *url = [NSURL URLWithString:posterURLString];
    //[cell.posterView setImageWithURL:url];
    [cell.posterView setImageWithURL:posterURLString fadingInDuration:0.3];
    return cell;
}


# pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieDetailedViewController *detailedVC = [[MovieDetailedViewController alloc] init];
    NSDictionary *movie = self.movies[indexPath.row];
    NSLog(@"movie=%@",movie);
    detailedVC.movieName = movie[@"title"];
    detailedVC.movieDetails = movie[@"synopsis"];
    detailedVC.posterURLString = [movie[@"posters"][@"thumbnail"] stringByReplacingOccurrencesOfString:@"_tmb" withString:@"_ori"];
    [self.navigationController pushViewController:detailedVC animated:YES];
    [self.searchBar resignFirstResponder];
    [self.moviesTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
