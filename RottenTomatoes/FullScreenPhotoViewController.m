//
//  FullScreenPhotoViewController.m
//  RottenTomatoes
//
//  Created by Baeksan Oh on 2/8/15.
//  Copyright (c) 2015 cp. All rights reserved.
//

#import "FullScreenPhotoViewController.h"

@interface FullScreenPhotoViewController () <UIScrollViewDelegate>

@end

@implementation FullScreenPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.scrollView.delegate = self;
    self.posterView.image = self.poster;
    self.scrollView.contentSize = self.posterView.image.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // This method is called as the user scrolls
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    // This method is called right as the user lifts their finger
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // This method is called when the scrollview finally stops scrolling.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.posterView;
}

- (IBAction)closeButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
