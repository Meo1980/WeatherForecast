//
//  WeatherForecastAppDelegate.h
//  WeatherForecast
//
//  Created by Trần Thị Yến Linh on 7/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherForecastAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  BOOL isUsingGPRS;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic) BOOL			isUsingGPRS;

@end
