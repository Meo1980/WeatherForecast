//
//  DetailWeaViewController.h
//  WeatherForecast
//
//  Created by Trần Thị Yến Linh on 7/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


//@interface DetailWeaViewController : UITableViewController 
@interface DetailWeaViewController : UIViewController 
{
//	NSString*	weatherAreaName;
//	
//	NSMutableDictionary*	curWeatherInfo;
//	NSMutableDictionary*	day1WeatherInfo;
//	NSMutableDictionary*	day2WeatherInfo;
//	NSMutableDictionary*	day3WeatherInfo;
	
	UILabel*			lbCurCity;
	UILabel*			lbCurUpdateTime;
	
	UIView*				vwCurWeather;
	UILabel*			lbCurWeather;
	UIImageView*		ivwCurWeather;
	UILabel*			lbCurTemperature;
	UILabel*			lbCurHumidity;
	UILabel*			lbCurWind;
	
	UIView*				vwThreeDaysWeather;
	UILabel*			lbFirstDay;
	UILabel*			lbFirstWeather;
	UIImageView*		ivwFirstWeather;
	UILabel*			lbFirstTemperature;
	UILabel*			lbSecondDay;
	UILabel*			lbSecondWeather;
	UIImageView*		ivwSecondWeather;
	UILabel*			lbSecondTemperature;
	UILabel*			lbThirdDay;
	UILabel*			lbThirdWeather;
	UIImageView*		ivwThirdWeather;
	UILabel*			lbThirdTemperature;
	
	UIActivityIndicatorView*	updateIndi;
//	UIView*				vwAreaPicking;
//	UIPickerView*		pvwArea;
	
	UIPageControl*		pageControl;
	
	NSMutableArray*		arrAreas;
	NSMutableArray*		arrWeatherInfos;
	NSMutableArray*		arrUpdateQueue;
	NSString*			strUpdateArea;
	
//	BOOL				isUpdating;
	NSInteger			curUpdating;
	NSInteger			curUpdateAll;
}

//@property (nonatomic, retain) NSString* weatherAreaName;
//@property (nonatomic, retain) NSMutableDictionary* curWeatherInfo;
//@property (nonatomic, retain) NSMutableDictionary* day1WeatherInfo;
//@property (nonatomic, retain) NSMutableDictionary* day2WeatherInfo;
//@property (nonatomic, retain) NSMutableDictionary* day3WeatherInfo;
@property (nonatomic, retain) NSMutableArray* arrAreas;
@property (nonatomic, retain) NSMutableArray* arrWeatherInfos;
@property (nonatomic, retain) NSString*		strUpdateArea;

@property (nonatomic, retain) IBOutlet UILabel*			lbCurCity;
@property (nonatomic, retain) IBOutlet UILabel*			lbCurUpdateTime;
@property (nonatomic, retain) IBOutlet UIView*			vwCurWeather;
@property (nonatomic, retain) IBOutlet UILabel*			lbCurWeather;
@property (nonatomic, retain) IBOutlet UIImageView*		ivwCurWeather;
@property (nonatomic, retain) IBOutlet UILabel*			lbCurTemperature;
@property (nonatomic, retain) IBOutlet UILabel*			lbCurHumidity;
@property (nonatomic, retain) IBOutlet UILabel*			lbCurWind;
@property (nonatomic, retain) IBOutlet UIView*			vwThreeDaysWeather;
@property (nonatomic, retain) IBOutlet UILabel*			lbFirstDay;
@property (nonatomic, retain) IBOutlet UILabel*			lbFirstWeather;
@property (nonatomic, retain) IBOutlet UIImageView*		ivwFirstWeather;
@property (nonatomic, retain) IBOutlet UILabel*			lbFirstTemperature;
@property (nonatomic, retain) IBOutlet UILabel*			lbSecondDay;
@property (nonatomic, retain) IBOutlet UILabel*			lbSecondWeather;
@property (nonatomic, retain) IBOutlet UIImageView*		ivwSecondWeather;
@property (nonatomic, retain) IBOutlet UILabel*			lbSecondTemperature;
@property (nonatomic, retain) IBOutlet UILabel*			lbThirdDay;
@property (nonatomic, retain) IBOutlet UILabel*			lbThirdWeather;
@property (nonatomic, retain) IBOutlet UIImageView*		ivwThirdWeather;
@property (nonatomic, retain) IBOutlet UILabel*			lbThirdTemperature;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView*	updateIndi;
//@property (nonatomic, retain) IBOutlet UIView*			vwAreaPicking;
//@property (nonatomic, retain) IBOutlet UIPickerView*	pvwArea;
@property (nonatomic, retain) IBOutlet UIPageControl*	pageControl;

- (BOOL) getWeatherData;
- (void) refresh;
- (void) updateText;
- (BOOL) isInternetConnected;

//- (IBAction) onDoneSelectArea: (id)sender;
- (IBAction) onChangePage: (id) sender;


@end
