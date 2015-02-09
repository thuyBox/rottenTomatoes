//
//  AppDelegate.m
//  RottenTomatoes
//
//  Created by Baeksan Oh on 2/7/15.
//  Copyright (c) 2015 cp. All rights reserved.
//

#import "AppDelegate.h"
#import "MoviesViewController.h"
#import "DVDsViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
enum ListType : NSUInteger {
    RTNowPlayingListType = 0,
    RTDVDsListType = 1
};

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    
    UIImage *nowPlayingImage = [UIImage imageNamed:@"video-camera-7.png"];
    MoviesViewController *moviesvc = [[MoviesViewController alloc] init];
    UINavigationController *moviesNavigationController = [[UINavigationController alloc] initWithRootViewController:moviesvc];
    moviesNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Now Playing" image:nowPlayingImage tag:0];
    
    UIImage *dvdsImage = [UIImage imageNamed:@"recorder-7.png"];
    DVDsViewController *dvdssvc = [[DVDsViewController alloc] init];
    UINavigationController *dvdsNavigationController = [[UINavigationController alloc] initWithRootViewController:dvdssvc];
    dvdsNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"DVDs" image:dvdsImage tag:1];
    
    NSArray* controllers = [NSArray arrayWithObjects:moviesNavigationController, dvdsNavigationController, nil];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = controllers;
    
    self.window.rootViewController = tabBarController;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
