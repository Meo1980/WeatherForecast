//
//  WeatherForecastAppDelegate.h
//  WeatherForecast
//
//  Created by Trần Thị Yến Linh on 7/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherForecastAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
  UIWindow *window;
  UITabBarController *tabBarController;
  BOOL isUsingGPRS;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic) BOOL			isUsingGPRS;

@end
