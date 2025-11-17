//
//  CommonWeaViewController.h
//  WeatherForecast
//
//  Created by Trần Thị Yến Linh on 8/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherView;


@interface CommonWeaViewController : UIViewController 
{
	UILabel*			lbUpdateTime;
	UIScrollView*		svwWeather;
	UINavigationItem*	naviItem;
	UIActivityIndicatorView*	updateIndi;
	
	BOOL				isUpdating;
	
	BOOL				isLand;
	NSMutableArray*		WeatherList;
	NSMutableArray*		weatherViewList;
}

@property (nonatomic, retain) IBOutlet UILabel* lbUpdateTime;
@property (nonatomic, retain) IBOutlet UIScrollView*	svwWeather;
@property (nonatomic, retain) IBOutlet UINavigationItem*	naviItem;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView*	updateIndi;
@property (nonatomic) BOOL isLand;

- (BOOL) getWeatherData;
- (void) refresh;
- (void) updateText;
- (BOOL) isInternetConnected;
- (void) getSavedData;


@end
