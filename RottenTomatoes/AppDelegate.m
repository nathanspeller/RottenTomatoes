//
//  AppDelegate.m
//  RottenTomatoes
//
//  Created by Nathan Speller on 3/13/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "AppDelegate.h"
#import "MoviesViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    MoviesViewController *boxOfficeViewController = [[MoviesViewController alloc] init];
    boxOfficeViewController.title = @"Box Office";
    boxOfficeViewController.boxOfficeSource = YES;
    MoviesViewController *dvdViewController = [[MoviesViewController alloc] init];
    dvdViewController.title = @"DVD";
    dvdViewController.boxOfficeSource = NO;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:boxOfficeViewController];
    UINavigationController *secondNavigationController = [[UINavigationController alloc] initWithRootViewController:dvdViewController];
    
    tabBarController.viewControllers = @[navigationController, secondNavigationController];
    tabBarController.tabBar.barTintColor = [UIColor colorWithRed:0.06 green:0.06 blue:0.06 alpha:1.0];
    tabBarController.tabBar.tintColor = [UIColor colorWithRed:1.000 green:0.800 blue:0.400 alpha:1.000];
    
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
