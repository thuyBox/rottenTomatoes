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
#import "FullScreenPhotoViewController.h"

@interface MovieDetailedViewController () <UIGestureRecognizerDelegate>

@end

@implementation MovieDetailedViewController
UITapGestureRecognizer *tap;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.movieName;
    self.navigationController.view.backgroundColor = self.view.backgroundColor;
    self.movieDetailsTextView.text = self.movieDetails;
    self.movieNameLabel.text = self.movieName;
    
    NSString *posterLowResURLString = [self.posterURLString stringByReplacingOccurrencesOfString:@"_ori" withString:@"_tmb"];
    [self.posterView setImageWithURL:[NSURL URLWithString:posterLowResURLString]];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"View did appear");
    [self.posterView setImageWithURL:self.posterURLString fadingInDuration:0.3];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
{
    CGPoint touchLocation = [touch locationInView:self.view];
    return CGRectContainsPoint(self.posterView.frame, touchLocation);
}

- (void) imageTapped {
    FullScreenPhotoViewController *fullScreenVC = [[FullScreenPhotoViewController alloc] init];
    fullScreenVC.poster = self.posterView.image;
    [self presentViewController:fullScreenVC animated:YES completion:nil];
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
