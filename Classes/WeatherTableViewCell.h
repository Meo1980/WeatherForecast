//
//  StatusTableViewCell.h
//  9999Truyen
//
//  Created by Nguyen Quang Minh on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WeatherTableViewCell : UITableViewCell 
{
//	UILabel* _lblDownloadStatus;
	BOOL	_isGeneralWeather;
	
//	UILabel* _lbLowestTemp;
//	UILabel* _lbLowestTempText;
//	UILabel* _lbHighestTemp;
//	UILabel* _lbHighestTempText;
//	
//	UILabel* _lbHumidity;
//	UILabel* _lbHumidityText;
//	UILabel* _lbWind;
//	UILabel* _lbWindText;
}

@property (nonatomic, setter = setGeneralWeather) BOOL isGeneralWeather;
//@property (nonatomic, retain) UILabel lbLowestTemp;
//@property (nonatomic, retain) UILabel lbHighestTemp;
//@property (nonatomic, retain) UILabel lbHumidity;
//@property (nonatomic, retain) UILabel lbWind;

@end
