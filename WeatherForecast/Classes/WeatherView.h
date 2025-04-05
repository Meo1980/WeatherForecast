//
//  WeatherView.h
//  WeatherForecast
//
//  Created by Trần Thị Yến Linh on 8/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WeatherView : UIView 
{
	BOOL isLand;
	
	UIImageView*	ivwWeather;
	UILabel*		lbName;
	//UILabel*		lbWeather;
	UITextView*		lbWeather;
	//UILabel*		lbDetail1;
	UITextView*		lbDetail1;
	//UILabel*		lbDetail2;
	UITextView*		lbDetail2;
	UILabel*		lbDetailText1;
	UILabel*		lbDetailText2;
}

@property (nonatomic, setter=setLandorSea:) BOOL isLand;

@property (nonatomic, retain) UIImageView*	ivwWeather;
@property (nonatomic, retain) UILabel*		lbName;
@property (nonatomic, retain) UITextView*		lbWeather;
@property (nonatomic, retain) UITextView*		lbDetail1;
@property (nonatomic, retain) UITextView*		lbDetail2;
@property (nonatomic, retain) UILabel*		lbDetailText1;
@property (nonatomic, retain) UILabel*		lbDetailText2;


@end
