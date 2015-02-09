//
//  MovieDetailedViewController.m
//  RottenTomatoes
//
//  Created by Baeksan Oh on 2/8/15.
//  Copyright (c) 2015 cp. All rights reserved.
//

#import "MovieDetailedViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+AFNetworkingFadingIn.h"

@interface MovieDetailedViewController ()

@end

@implementation MovieDetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.movieName;
    self.navigationController.view.backgroundColor = self.view.backgroundColor;
    self.movieDetailsTextView.text = self.movieDetails;
    self.movieNameLabel.text = self.movieName;
    
    NSString *posterLowResURLString = [self.posterURLString stringByReplacingOccurrencesOfString:@"_ori" withString:@"_tmb"];
    [self.posterView setImageWithURL:[NSURL URLWithString:posterLowResURLString]];
}

- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"View did appear");
    [self.posterView setImageWithURL:self.posterURLString fadingInDuration:0.3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
