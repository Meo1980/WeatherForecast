/*
 *  CommonDefine.h
 *  WeatherForecast
 *
 *  Created by Trần Thị Yến Linh on 7/31/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */


extern NSString* WeatherAreas[]; 
extern NSInteger kWeatherAreasCount;
extern NSString* SeaWeatherAreas[];
extern NSInteger kSeaWeatherAreasCount;
extern NSString* TayBacBoTowns []; 
extern NSInteger kTayBacBoTownsCount;
extern NSString* DongBacBoTowns []; 
extern NSInteger kDongBacBoTownsCount;
extern NSString* ThanhHoaHueTowns []; 
extern NSInteger kThanhHoaHueTownsCount;
extern NSString* DaNangBinhThuanTowns [];
extern NSInteger kDaNangBinhThuanTownsCount;
extern NSString* TayNguyenTowns [];
extern NSInteger kTayNguyenTownsCount;
extern NSString* NamBoTowns [];
extern NSInteger kNamBoTownsCount;

#define kRootLink			@"http://www.khituongvietnam.gov.vn/web/vi-VN/"
//#define kEndLink	@"Default.aspx"

#define kCurWeatherCityKey		@"CurWeatherCityKey"
#define kCurTemperatureKey		@"CurTemperatureKey"
#define kCurHumidityKey			@"CurHumidityKey"
#define kCurWindKey				@"CurWindKey"

#define kWeatherImageKey		@"WeatherImageKey"
#define kWeatherKey				@"WeatherKey"
#define kHighestTempKey			@"HighestTempKey"
#define kLowestTempKey			@"LowestTempKey"
#define kUpdateTimeKey			@"UpdateTimeKey"
#define kSeeingRangeKey			@"SeeingRangeKey"
#define kWindSpeedKey			@"WindSpeedKey"

#define kNoInformation			@"Không có thông tin"

#define kTempSymbol				161


NSString* replaceSpecialString(NSString* inStr);

