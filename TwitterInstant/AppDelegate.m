//
//  AppDelegate.m
//  TwitterInstant
//
//  Created by Hong on 16/9/2.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "DetailViewController.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    
    MasterViewController *masterVc = [[MasterViewController alloc] init];
    DetailViewController *detailVc = [[DetailViewController alloc] init];
    
    UINavigationController *masterNavi = [[UINavigationController alloc] initWithRootViewController:masterVc];
    UINavigationController *detailNaiv = [[UINavigationController alloc] initWithRootViewController:detailVc];
    
    UISplitViewController *splitViewController = [[UISplitViewController alloc] init];
    splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    splitViewController.viewControllers = @[masterNavi, detailNaiv];
    
    self.window.rootViewController = splitViewController;
    [self.window makeKeyAndVisible];
    
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