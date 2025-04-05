//
//  WeatherForecastAppDelegate.m
//  WeatherForecast
//
//  Created by Trần Thị Yến Linh on 7/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "WeatherForecastAppDelegate.h"
#import "CommonWeaViewController.h"


@implementation WeatherForecastAppDelegate

@class CommonWeaViewController;

@synthesize window;
@synthesize tabBarController;
//@synthesize firstNavigationController;
@synthesize isUsingGPRS;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  // Override point for customization after application launch.
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    // load the content controller object for Phone-based devices
    [[NSBundle mainBundle] loadNibNamed:@"DetailWeaViewController" owner:self options:nil];
  }
  //	else
  //	{
  //		// load the content controller object for Pad-based devices
  //        [[NSBundle mainBundle] loadNibNamed:@"NameViewController" owner:self options:nil];
  //	}

  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UsingGPRS"]) {
    isUsingGPRS = [[NSUserDefaults standardUserDefaults] boolForKey:@"UsingGPRS"];
  }
  else {
    isUsingGPRS = NO;
  }

  NSArray* viewControllers = tabBarController.viewControllers;
  UIViewController* viewController = [viewControllers objectAtIndex:1];
  if ([viewController classForCoder] == [CommonWeaViewController class])
    ((CommonWeaViewController*)viewController).isLand = YES;
  viewController = [viewControllers objectAtIndex:2];
  if ([viewController classForCoder] == [CommonWeaViewController class])
    ((CommonWeaViewController*)viewController).isLand = NO;

  // Add the tab bar controller's view to the window and display.
  [window addSubview:tabBarController.view];
  [window makeKeyAndVisible];

  return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
   If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
   */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
  /*
   Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
   */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
}


- (void)applicationWillTerminate:(UIApplication *)application
{
  /*
   Called when the application is about to terminate.
   See also applicationDidEnterBackground:.
   */
  [[NSUserDefaults standardUserDefaults] setBool:isUsingGPRS forKey:@"UsingGPRS"];
  NSLog(@"gprs save");

}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
  /*
   Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
   */
}


- (void)dealloc
{
  //	[firstNavigationController release];
  [tabBarController release];
  [window release];
  [super dealloc];
}

@end

