//
//  DetailWeaViewController.m
//  WeatherForecast
//
//  Created by Trần Thị Yến Linh on 7/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DetailWeaViewController.h"
#import "CommonDefine.h"
#import "NetReachability.h"
#import "TouchButton.h"
#import "SelectAreaViewController.h"
#import "WeatherForecastAppDelegate.h"


@implementation DetailWeaViewController
//@synthesize weatherAreaName;
//@synthesize curWeatherInfo;
//@synthesize day1WeatherInfo;
//@synthesize day2WeatherInfo;
//@synthesize day3WeatherInfo;
@synthesize arrAreas;
@synthesize arrWeatherInfos;
@synthesize strUpdateArea;
@synthesize	lbCurCity;
@synthesize	lbCurUpdateTime;
@synthesize	vwCurWeather;
@synthesize	lbCurWeather;
@synthesize	ivwCurWeather;
@synthesize	lbCurTemperature;
@synthesize	lbCurHumidity;
@synthesize	lbCurWind;
@synthesize	vwThreeDaysWeather;
@synthesize	lbFirstDay;
@synthesize	lbFirstWeather;
@synthesize	ivwFirstWeather;
@synthesize	lbFirstTemperature;
@synthesize	lbSecondDay;
@synthesize	lbSecondWeather;
@synthesize	ivwSecondWeather;
@synthesize	lbSecondTemperature;
@synthesize	lbThirdDay;
@synthesize	lbThirdWeather;
@synthesize	ivwThirdWeather;
@synthesize	lbThirdTemperature;
@synthesize updateIndi;
//@synthesize vwAreaPicking;
//@synthesize pvwArea;
@synthesize pageControl;

#pragma mark -
#pragma mark View lifecycle


/*- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		curWeatherInfo = [[NSMutableDictionary alloc] init];
		day1WeatherInfo = [[NSMutableDictionary alloc] init];
		day2WeatherInfo = [[NSMutableDictionary alloc] init];
		day3WeatherInfo = [[NSMutableDictionary alloc] init];
		weatherAreaName = @"";
		
		isUpdating = NO;
		isSelectArea = NO;
		updateIndi.hidesWhenStopped = YES;
	}
	
	return self;
}*/

- (void) clearUI
{
	lbCurCity.text = @"";
	lbCurUpdateTime.text = @"";
	lbCurWeather.text = @"";
	ivwCurWeather.image = nil;
	lbCurTemperature.text = @"";
	lbCurHumidity.text = @"";
	lbCurWind.text = @"";
	
	lbFirstDay.text = @"";
	lbFirstWeather.text = @"";
	lbFirstTemperature.text = @"";
	ivwFirstWeather.image = nil;
	
	lbSecondDay.text = @"";
	lbSecondWeather.text = @"";
	lbSecondTemperature.text = @"";
	ivwSecondWeather.image = nil;
	
	lbThirdDay.text = @"";
	lbThirdWeather.text = @"";
	lbThirdTemperature.text = @"";
	ivwThirdWeather.image = nil;
}

- (void) getSaveDataForArea:(NSString*) areaName
{
	NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
	if ([userDefault objectForKey:areaName])
	{
		[arrWeatherInfos replaceObjectAtIndex:[arrAreas indexOfObject:areaName] withObject:[userDefault objectForKey:areaName]];
	}
}

- (void)viewDidLoad 
{
    [super viewDidLoad];

	UIBarButtonItem* refreshBut = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onRefresh:)];
	self.navigationItem.rightBarButtonItem = refreshBut;
	[refreshBut release];
	
	UIBarButtonItem* selectBut = [[UIBarButtonItem alloc] initWithTitle:@"Chọn tỉnh" style:UIBarButtonItemStyleDone target:self action:@selector(onSelectArea:)];
	self.navigationItem.leftBarButtonItem = selectBut;
	[selectBut release];
	
	//isUpdating = NO;
	curUpdating = -1; // No update
	curUpdateAll = -1;
	updateIndi.hidesWhenStopped = YES;
	pageControl.currentPage = 0;
	[self clearUI];

	arrAreas = [[NSMutableArray alloc] init];
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FavouriteCities"])
	{
		[arrAreas addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"FavouriteCities"]];
	}
	else 
	{
		[arrAreas addObjectsFromArray:[NSArray arrayWithObjects:@"T.P Hà Nội", @"T.P Hồ Chí Minh", nil]];
	}
	self.navigationItem.title = [arrAreas objectAtIndex:pageControl.currentPage];
	pageControl.numberOfPages = [arrAreas count];
	strUpdateArea = nil;
	arrUpdateQueue = [[NSMutableArray alloc] init];
	[arrUpdateQueue addObjectsFromArray:arrAreas];
	
	arrWeatherInfos = [[NSMutableArray alloc] init];
	for (NSString* area in arrAreas)
	{
//		if ([[NSUserDefaults standardUserDefaults] objectForKey:area])
//		{
//			[arrWeatherInfos addObject:[[NSUserDefaults standardUserDefaults] objectForKey:area]];
//		}
//		else 
//		{
			[arrWeatherInfos addObject:[NSNull null]];
//		}
	}
	
	[self refresh];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddNewArea:) name:@"NewAreaAdd" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeleteArea:) name:@"AreaDelete" object:nil];
}



- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
//	[self refresh];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/




#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc 
{
	NSLog(@"DetailWeaViewController release");
	self.arrAreas = nil;
	self.arrWeatherInfos = nil;
	
	self.lbCurCity = nil;
	self.lbCurUpdateTime = nil;
	
	self.vwCurWeather = nil;
	self.lbCurWeather = nil;
	self.ivwCurWeather = nil;
	self.lbCurTemperature = nil;
	self.lbCurHumidity = nil;
	self.lbCurWind = nil;
	
	self.vwThreeDaysWeather = nil;
	self.lbFirstDay = nil;
	self.lbFirstWeather = nil;
	self.ivwFirstWeather = nil;
	self.lbFirstTemperature = nil;
	self.lbSecondDay = nil;
	self.lbSecondWeather = nil;
	self.ivwSecondWeather = nil;
	self.lbSecondTemperature = nil;
	self.lbThirdDay = nil;
	self.lbThirdWeather = nil;
	self.ivwThirdWeather = nil;
	self.lbThirdTemperature = nil;
	self.updateIndi = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];

    [super dealloc];
}

- (NSInteger) isAreaInQueue: (NSString*) area
{
	for (int i = 0; i < [arrUpdateQueue count]; i++) 
	{
		if ([area isEqualToString:[arrUpdateQueue objectAtIndex:i]]) 
		{
			return i;
		}
	}
	
	return -1;
}

- (void) refresh
{
	if ([arrUpdateQueue count] > 0)
	{
		self.strUpdateArea = [arrUpdateQueue objectAtIndex:0];
		curUpdating = [arrAreas indexOfObject:strUpdateArea];
		[arrUpdateQueue removeObjectAtIndex:0];
		//BOOL isCurrentPage = [strUpdateArea isEqualToString:[arrAreas objectAtIndex:pageControl.currentPage]];
		BOOL isCurrentPage = (curUpdating == pageControl.currentPage) ? YES : NO;
		if (isCurrentPage)
		{
			if (![updateIndi isAnimating])	// Display updating symbol
				[updateIndi startAnimating];
		}

		if ([self isInternetConnected])
		{
			[self performSelectorInBackground: @selector(getWeatherData) withObject: nil];
		}
		else 
		{
			if ((NSNull*)[arrWeatherInfos objectAtIndex:curUpdating] == [NSNull null])
			{
				[self getSaveDataForArea:strUpdateArea];
				if (isCurrentPage)
				{
					[updateIndi stopAnimating];
					[self updateText];
				}
			}
			self.strUpdateArea = nil;
			curUpdating = -1;
		}
	}
}

- (void) onRefresh: (id)sender
{
	NSInteger idx = [self isAreaInQueue:[arrAreas objectAtIndex:pageControl.currentPage]];
	if (idx != -1)
	{
		[arrUpdateQueue removeObjectAtIndex:idx];
	}
	[arrUpdateQueue insertObject:[arrAreas objectAtIndex:pageControl.currentPage] atIndex:0];
	
	if (!strUpdateArea)
	{
		[self refresh];
	}
}

- (IBAction) onChangePage: (id) sender
{
	TouchButton* touchBut = (TouchButton*)sender;
	CGPoint startPt = touchBut.startTouchPt;
	CGPoint endPt = touchBut.endTouchPt;
	
	if (endPt.x + 30 < startPt.x)	// Advance page
	{
		if (pageControl.currentPage < ([arrAreas count] - 1))
		{
			self.navigationItem.title = @"";
			pageControl.currentPage = pageControl.currentPage + 1;
			[UIView beginAnimations:@"ChangePageAnimationID" context:nil];
			[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:NO];
			[UIView setAnimationDuration:0.5];
			[UIView setAnimationDelegate:self];
			[UIView commitAnimations];
		}
	}
	
	if (startPt.x + 30 < endPt.x)	// Back page
	{
		if (pageControl.currentPage > 0)
		{
			self.navigationItem.title = @"";
			pageControl.currentPage = pageControl.currentPage - 1;
			[UIView beginAnimations:@"ChangePageAnimationID" context:nil];
			[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:NO];
			[UIView setAnimationDuration:0.5];
			[UIView setAnimationDelegate:self];
			[UIView commitAnimations];
		}
	}
}

- (void) animationDidStop: (NSString*) animationID
{
	if ([animationID isEqualToString:@"ChangePageAnimationID"])
	{
		self.navigationItem.title = [arrAreas objectAtIndex:pageControl.currentPage];
		[self clearUI];
		if ((NSNull*)[arrWeatherInfos objectAtIndex:pageControl.currentPage] == [NSNull null])
		{
			if (![updateIndi isAnimating])	// Display updating symbol
				[updateIndi startAnimating];
			NSInteger idx = [self isAreaInQueue:[arrAreas objectAtIndex:pageControl.currentPage]];
			if (idx != -1)
			{
				[arrUpdateQueue removeObjectAtIndex:idx];
			}
			[arrUpdateQueue insertObject:[arrAreas objectAtIndex:pageControl.currentPage] atIndex:0];
			
			if (!strUpdateArea)
			{
				[self refresh];
			}
		}
		else 
		{
			[self updateText];
			if (curUpdating == pageControl.currentPage)
			{
				if (![updateIndi isAnimating])	// Display updating symbol
					[updateIndi startAnimating];
			}
		}
	}
}

- (void) onSelectArea:(id)sender
{	
	SelectAreaViewController* controller = [[SelectAreaViewController alloc] initWithNibName:@"SelectAreaViewController" bundle:nil];
	controller.arrFavourite = arrAreas;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}


#pragma mark Notification Handle
- (void) onAddNewArea:(NSNotification*) notification
{
	NSString* newArea = (NSString*)[notification object];
	
	[arrWeatherInfos addObject:[NSNull null]];
	pageControl.numberOfPages = [arrAreas count];
	
	[arrUpdateQueue addObject:newArea];
	if (!strUpdateArea)
	{
		[self refresh];
	}
}

- (void) onDeleteArea:(NSNotification*) notification
{
	NSInteger deleteIdx = [(NSNumber*)[notification object] intValue];
	
	[arrWeatherInfos removeObjectAtIndex:deleteIdx];
	pageControl.numberOfPages = [arrAreas count];
	if ((deleteIdx == pageControl.currentPage) || (deleteIdx == [arrAreas count]))
	{
		[self updateText];
	}
}

#pragma mark Data Request and Processing
- (BOOL) isInternetConnected
{
	WeatherForecastAppDelegate* delegate = (WeatherForecastAppDelegate*)[UIApplication sharedApplication].delegate;

	NetReachability* reachability = [[NetReachability alloc] initWithDefaultRoute:NO];
	if(![reachability isReachable] || (!delegate.isUsingGPRS && [reachability isUsingCell])) 
	{
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Máy của bạn cần có kết nối Internet để tải được thông tin mới nhất từ máy chủ." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alertView show];
		[alertView release];
		[reachability release];
		return NO;
	}
	[reachability release];
	return YES;
}

- (NSDictionary*) getCurrentWeather:(NSScanner*) scanner	startAt:(NSInteger*)startLoc
{
	NSMutableDictionary* curWeatherInfo = nil;
	BOOL bScanned = YES;
	NSString *tmpStr;
	NSInteger	location = *startLoc;
	
	// Lay ten tinh co thoi tiet hien tai
	bScanned = [scanner scanUpToString:@"_ctl1__ctl0__ctl0_lbl_Thoitiettai" intoString:NULL];
	bScanned = [scanner scanString:@"_ctl1__ctl0__ctl0_lbl_Thoitiettai" intoString:NULL];
	if (bScanned)
	{
		curWeatherInfo = [NSMutableDictionary dictionary];
		
		bScanned = [scanner scanUpToString:@"</span>" intoString:NULL];
		if (bScanned)
		{
			bScanned = [scanner scanString:@"</span>" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"</td>" intoString:&tmpStr];
				if (!bScanned)
				{
					tmpStr = @"";
				}
				tmpStr = replaceSpecialString(tmpStr);
				[curWeatherInfo setObject:tmpStr forKey:kCurWeatherCityKey];
			}
		}
		
		location = [scanner scanLocation];
		bScanned = [scanner scanUpToString:@"_ctl1__ctl0__ctl0_pnl_img" intoString:NULL];
		bScanned = [scanner scanString:@"_ctl1__ctl0__ctl0_pnl_img" intoString:NULL];
		if (bScanned)	// Co thoi tiet hien tai
		{
			// Lay anh thoi tiet hien tai cua tinh
			location = [scanner scanLocation];
			bScanned = [scanner scanUpToString:@"WeatherSymbol/2008/8/22/" intoString:NULL];
			bScanned = [scanner scanString:@"WeatherSymbol/2008/8/22/" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"\"" intoString:&tmpStr];
				if (!bScanned)
				{
					tmpStr = @"";
				}
				tmpStr = replaceSpecialString(tmpStr);
				tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
				tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@")" withString:@""];
				[curWeatherInfo setObject:tmpStr forKey:kWeatherImageKey];
			}
			else 
			{
				NSLog(@"WeatherSymbolLink not found");
				[scanner setScanLocation:location];
			}
			// Lay thoi diem cap nhat thoi tiet
			location = [scanner scanLocation];
			bScanned = [scanner scanUpToString:@"_ctl1__ctl0__ctl0_lbl_DuBaoThoiTietCapNhatLuc" intoString:NULL];
			bScanned = [scanner scanString:@"_ctl1__ctl0__ctl0_lbl_DuBaoThoiTietCapNhatLuc" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"</span>" intoString:NULL];
				bScanned = [scanner scanString:@"</span>" intoString:NULL];
				if (bScanned)
				{
					bScanned = [scanner scanUpToString:@"</span>" intoString:&tmpStr];
					if (!bScanned)
					{
						tmpStr = @"";
					}
					tmpStr = replaceSpecialString(tmpStr);
					[curWeatherInfo setObject:tmpStr forKey:kUpdateTimeKey];
				}
			}
			else 
			{
				NSLog(@"Current Weather update time not found");
				[scanner setScanLocation:location];
			}
			// Lay nhiet do hien thoi
			location = [scanner scanLocation];
			bScanned = [scanner scanUpToString:@"_ctl1__ctl0__ctl0_lbl_HTNhietdo" intoString:NULL];
			bScanned = [scanner scanString:@"_ctl1__ctl0__ctl0_lbl_HTNhietdo" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"<strong>" intoString:NULL];
				bScanned = [scanner scanString:@"<strong>" intoString:NULL];
				if (bScanned)
				{
					bScanned = [scanner scanUpToString:@"<sup>" intoString:&tmpStr];
					if (!bScanned)
					{
						tmpStr = @"";
					}
					tmpStr = replaceSpecialString(tmpStr);
					[curWeatherInfo setObject:tmpStr forKey:kCurTemperatureKey];
				}
			}
			else 
			{
				NSLog(@"_ctl1__ctl0__ctl0_lbl_HTNhietdo not found");
				[scanner setScanLocation:location];
			}
			// Lay thoi tiet hien thoi
			location = [scanner scanLocation];
			bScanned = [scanner scanUpToString:@"_ctl1__ctl0__ctl0_lbl_Weather_Text" intoString:NULL];
			bScanned = [scanner scanString:@"_ctl1__ctl0__ctl0_lbl_Weather_Text" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"<strong>" intoString:NULL];
				bScanned = [scanner scanString:@"<strong>" intoString:NULL];
				if (bScanned)
				{
					bScanned = [scanner scanUpToString:@"</strong>" intoString:&tmpStr];
					if (!bScanned)
					{
						tmpStr = @"";
					}
					tmpStr = replaceSpecialString(tmpStr);
					[curWeatherInfo setObject:tmpStr forKey:kWeatherKey];
				}
			}
			else 
			{
				NSLog(@"_ctl1__ctl0__ctl0_lbl_Weather_Text not found");
				[scanner setScanLocation:location];
			}
			// Lay do am hien thoi
			location = [scanner scanLocation];
			bScanned = [scanner scanUpToString:@"_ctl1__ctl0__ctl0_lblHT_Doam" intoString:NULL];
			bScanned = [scanner scanString:@"_ctl1__ctl0__ctl0_lblHT_Doam" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"<strong>" intoString:NULL];
				bScanned = [scanner scanString:@"<strong>" intoString:NULL];
				if (bScanned)
				{
					bScanned = [scanner scanUpToString:@"</strong>" intoString:&tmpStr];
					if (!bScanned)
					{
						tmpStr = @"";
					}
					tmpStr = replaceSpecialString(tmpStr);
					[curWeatherInfo setObject:tmpStr forKey:kCurHumidityKey];
				}
			}
			else 
			{
				NSLog(@"_ctl1__ctl0__ctl0_lblHT_Doam not found");
				[scanner setScanLocation:location];
			}
			// Lay huong gio hien thoi
			location = [scanner scanLocation];
			bScanned = [scanner scanUpToString:@"_ctl1__ctl0__ctl0_lblHT_Gio" intoString:NULL];
			bScanned = [scanner scanString:@"_ctl1__ctl0__ctl0_lblHT_Gio" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"<strong>" intoString:NULL];
				bScanned = [scanner scanString:@"<strong>" intoString:NULL];
				if (bScanned)
				{
					bScanned = [scanner scanUpToString:@"</strong>" intoString:&tmpStr];
					if (!bScanned)
					{
						tmpStr = @"";
					}
					tmpStr = replaceSpecialString(tmpStr);
					[curWeatherInfo setObject:tmpStr forKey:kCurWindKey];
				}
			}
			else 
			{
				NSLog(@"_ctl1__ctl0__ctl0_lblHT_Gio not found");
				[scanner setScanLocation:location];
			}
		}
		else	// Khong co thoi tiet hien tai, reset de lay thoi tiet 3 ngay
		{
			[scanner setScanLocation:location];
		}
	}
	else 
	{
		NSLog(@"<span id=\"_ctl1__ctl0__ctl0_lbl_Thoitiettai\"> not found");
		[scanner setScanLocation:location];
	}
	*startLoc = location;
	
	return curWeatherInfo;
}

- (NSArray*) getThreeDayWeather:(NSScanner*) scanner	startAt:(NSInteger)startLoc
{
	NSMutableDictionary* day1WeatherInfo = nil;
	NSMutableDictionary* day2WeatherInfo = nil;
	NSMutableDictionary* day3WeatherInfo = nil;
	BOOL bScanned = YES;
	NSString *tmpStr;
	NSInteger	location = startLoc;
	
	// Lay thoi tiet 3 ngay
	bScanned = [scanner scanUpToString:@"_ctl1__ctl0__ctl0_dl_Thoitietthanhpho__ctl0_lbl_Thoigian" intoString:NULL];
	bScanned = [scanner scanString:@"_ctl1__ctl0__ctl0_dl_Thoitietthanhpho__ctl0_lbl_Thoigian" intoString:NULL];
	if (bScanned)
	{
		day1WeatherInfo = [NSMutableDictionary dictionary];
		day2WeatherInfo = [NSMutableDictionary dictionary];
		day3WeatherInfo = [NSMutableDictionary dictionary];
		
		// Get time of day1
		bScanned = [scanner scanUpToString:@"<td" intoString:NULL];
		if (bScanned)
		{
			bScanned = [scanner scanUpToString:@">" intoString:NULL];
			bScanned = [scanner scanString:@">" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"<!--" intoString:&tmpStr];
				if (!bScanned)
				{
					tmpStr = @"";
				}
				tmpStr = replaceSpecialString(tmpStr);
				[day1WeatherInfo setObject:tmpStr forKey:kUpdateTimeKey];
			}
		}
		// Get time of day2
		bScanned = [scanner scanUpToString:@"<td" intoString:NULL];
		if (bScanned)
		{
			bScanned = [scanner scanUpToString:@">" intoString:NULL];
			bScanned = [scanner scanString:@">" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"<!--" intoString:&tmpStr];
				if (!bScanned)
				{
					tmpStr = @"";
				}
				tmpStr = replaceSpecialString(tmpStr);
				[day2WeatherInfo setObject:tmpStr forKey:kUpdateTimeKey];
			}
		}
		// Get time of day 3
		bScanned = [scanner scanUpToString:@"<td" intoString:NULL];
		if (bScanned)
		{
			bScanned = [scanner scanUpToString:@">" intoString:NULL];
			bScanned = [scanner scanString:@">" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"<!--" intoString:&tmpStr];
				if (!bScanned)
				{
					tmpStr = @"";
				}
				tmpStr = replaceSpecialString(tmpStr);
				[day3WeatherInfo setObject:tmpStr forKey:kUpdateTimeKey];
			}
		}
		// Get symbol and weather for day 1
		location = [scanner scanLocation];
		bScanned = [scanner scanUpToString:@"WeatherSymbol/2008/8/22/" intoString:NULL];
		bScanned = [scanner scanString:@"WeatherSymbol/2008/8/22/" intoString:NULL];
		if (bScanned)
		{
			bScanned = [scanner scanUpToString:@"\"" intoString:&tmpStr];
			if (!bScanned)
			{
				tmpStr = @"";
			}
			tmpStr = replaceSpecialString(tmpStr);
			tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
			tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@")" withString:@""];
			[day1WeatherInfo setObject:tmpStr forKey:kWeatherImageKey];
			
			bScanned = [scanner scanUpToString:@"_ctl1__ctl0__ctl0_dl_Thoitietthanhpho__ctl0_pnlText_24" intoString:NULL];
			bScanned = [scanner scanString:@"_ctl1__ctl0__ctl0_dl_Thoitietthanhpho__ctl0_pnlText_24" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"<td>" intoString:NULL];
				bScanned = [scanner scanString:@"<td>" intoString:NULL];
				if (bScanned)
				{
					bScanned = [scanner scanUpToString:@"</td>" intoString:&tmpStr];
					if (!bScanned)
					{
						tmpStr = @"";
					}
					tmpStr = replaceSpecialString(tmpStr);
					[day1WeatherInfo setObject:tmpStr forKey:kWeatherKey];
				}
			}
		}
		else 
		{
			[scanner setScanLocation:location];
		}
		// Get symbol and weather for day 2
		location = [scanner scanLocation];
		bScanned = [scanner scanUpToString:@"WeatherSymbol/2008/8/22/" intoString:NULL];
		bScanned = [scanner scanString:@"WeatherSymbol/2008/8/22/" intoString:NULL];
		if (bScanned)
		{
			bScanned = [scanner scanUpToString:@"\"" intoString:&tmpStr];
			if (!bScanned)
			{
				tmpStr = @"";
			}
			tmpStr = replaceSpecialString(tmpStr);
			tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
			tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@")" withString:@""];
			[day2WeatherInfo setObject:tmpStr forKey:kWeatherImageKey];
			
			bScanned = [scanner scanUpToString:@"_ctl1__ctl0__ctl0_dl_Thoitietthanhpho__ctl0_pnlText_48" intoString:NULL];
			bScanned = [scanner scanString:@"_ctl1__ctl0__ctl0_dl_Thoitietthanhpho__ctl0_pnlText_48" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"<td>" intoString:NULL];
				bScanned = [scanner scanString:@"<td>" intoString:NULL];
				if (bScanned)
				{
					bScanned = [scanner scanUpToString:@"</td>" intoString:&tmpStr];
					if (!bScanned)
					{
						tmpStr = @"";
					}
					tmpStr = replaceSpecialString(tmpStr);
					[day2WeatherInfo setObject:tmpStr forKey:kWeatherKey];
				}
			}
		}
		else 
		{
			[scanner setScanLocation:location];
		}
		// Get symbol and weather for day 3
		location = [scanner scanLocation];
		bScanned = [scanner scanUpToString:@"WeatherSymbol/2008/8/22/" intoString:NULL];
		bScanned = [scanner scanString:@"WeatherSymbol/2008/8/22/" intoString:NULL];
		if (bScanned)
		{
			bScanned = [scanner scanUpToString:@"\"" intoString:&tmpStr];
			if (!bScanned)
			{
				tmpStr = @"";
			}
			tmpStr = replaceSpecialString(tmpStr);
			tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
			tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@")" withString:@""];
			[day3WeatherInfo setObject:tmpStr forKey:kWeatherImageKey];
			
			bScanned = [scanner scanUpToString:@"_ctl1__ctl0__ctl0_dl_Thoitietthanhpho__ctl0_pnlText_72" intoString:NULL];
			bScanned = [scanner scanString:@"_ctl1__ctl0__ctl0_dl_Thoitietthanhpho__ctl0_pnlText_72" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"<td>" intoString:NULL];
				bScanned = [scanner scanString:@"<td>" intoString:NULL];
				if (bScanned)
				{
					bScanned = [scanner scanUpToString:@"</td>" intoString:&tmpStr];
					if (!bScanned)
					{
						tmpStr = @"";
					}
					tmpStr = replaceSpecialString(tmpStr);
					[day3WeatherInfo setObject:tmpStr forKey:kWeatherKey];
				}
			}
		}
		else 
		{
			[scanner setScanLocation:location];
		}
		// Get nhiet do thap nhat cua 3 ngay
		location = [scanner scanLocation];
		bScanned = [scanner scanUpToString:@"_ctl1__ctl0__ctl0_dl_Thoitietthanhpho__ctl0_lbl_NhietdothapnhatCity" intoString:NULL];
		bScanned = [scanner scanString:@"_ctl1__ctl0__ctl0_dl_Thoitietthanhpho__ctl0_lbl_NhietdothapnhatCity" intoString:NULL];
		if (bScanned)
		{
			bScanned = [scanner scanUpToString:@"<strong>" intoString:NULL];
			bScanned = [scanner scanString:@"<strong>" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"</strong>" intoString:&tmpStr];
				if (!bScanned)
				{
					tmpStr = @"";
				}
				tmpStr = replaceSpecialString(tmpStr);
				[day1WeatherInfo setObject:tmpStr forKey:kLowestTempKey];
			}
			bScanned = [scanner scanUpToString:@"<strong>" intoString:NULL];
			bScanned = [scanner scanString:@"<strong>" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"</strong>" intoString:&tmpStr];
				if (!bScanned)
				{
					tmpStr = @"";
				}
				tmpStr = replaceSpecialString(tmpStr);
				[day2WeatherInfo setObject:tmpStr forKey:kLowestTempKey];
			}
			bScanned = [scanner scanUpToString:@"<strong>" intoString:NULL];
			bScanned = [scanner scanString:@"<strong>" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"</strong>" intoString:&tmpStr];
				if (!bScanned)
				{
					tmpStr = @"";
				}
				tmpStr = replaceSpecialString(tmpStr);
				[day3WeatherInfo setObject:tmpStr forKey:kLowestTempKey];
			}
		}
		else 
		{
			[scanner setScanLocation:location];
		}
		// Get nhiet do cao nhat cua 3 ngay
		bScanned = [scanner scanUpToString:@"_ctl1__ctl0__ctl0_dl_Thoitietthanhpho__ctl0_lbl_NhietdocaonhatCity" intoString:NULL];
		bScanned = [scanner scanString:@"_ctl1__ctl0__ctl0_dl_Thoitietthanhpho__ctl0_lbl_NhietdocaonhatCity" intoString:NULL];
		if (bScanned)
		{
			bScanned = [scanner scanUpToString:@"<strong>" intoString:NULL];
			bScanned = [scanner scanString:@"<strong>" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"</strong>" intoString:&tmpStr];
				if (!bScanned)
				{
					tmpStr = @"";
				}
				tmpStr = replaceSpecialString(tmpStr);
				[day1WeatherInfo setObject:tmpStr forKey:kHighestTempKey];
			}
			bScanned = [scanner scanUpToString:@"<strong>" intoString:NULL];
			bScanned = [scanner scanString:@"<strong>" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"</strong>" intoString:&tmpStr];
				if (!bScanned)
				{
					tmpStr = @"";
				}
				tmpStr = replaceSpecialString(tmpStr);
				[day2WeatherInfo setObject:tmpStr forKey:kHighestTempKey];
			}
			bScanned = [scanner scanUpToString:@"<strong>" intoString:NULL];
			bScanned = [scanner scanString:@"<strong>" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"</strong>" intoString:&tmpStr];
				if (!bScanned)
				{
					tmpStr = @"";
				}
				tmpStr = replaceSpecialString(tmpStr);
				[day3WeatherInfo setObject:tmpStr forKey:kHighestTempKey];
			}
		}
	}
	else 
	{
		NSLog(@"Not have time, stop getting thoi tiet 3 ngay");
	}

	return [NSArray arrayWithObjects:day1WeatherInfo, day2WeatherInfo, day3WeatherInfo, nil];
}

- (BOOL) getWeatherData
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	BOOL isCanGetData = NO;
	
	NSDictionary *linkDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DBTT" ofType:@"plist"]];
	NSString *link = [linkDict objectForKey:strUpdateArea];
	if (link)
	{
		link = [NSString stringWithFormat:@"%@%@/Default.aspx", kRootLink, link];
		NSURL *linkURL = [NSURL URLWithString:link];
		NSMutableURLRequest *weatherLinkRequest = [NSMutableURLRequest requestWithURL:linkURL];
		[weatherLinkRequest setHTTPMethod:@"GET"];
		
		NSData* weatherData = [NSURLConnection sendSynchronousRequest:weatherLinkRequest returningResponse:NULL error:NULL];
		
		if (weatherData)
		{
			NSString *detailWeatherPage = [[[NSString alloc] initWithData:weatherData encoding:NSUTF8StringEncoding] autorelease];
			NSScanner *scanner = [NSScanner scannerWithString:detailWeatherPage];
			NSInteger	location = 0;
			
			NSDictionary* curWeatherInfo = [self getCurrentWeather:scanner startAt:&location];
			NSArray* threeDayInfos;
			if (curWeatherInfo)
			{
				isCanGetData = YES;
				threeDayInfos = [self getThreeDayWeather:scanner startAt:location];
			}
			
			if (isCanGetData)
			{
				[arrWeatherInfos replaceObjectAtIndex:curUpdating withObject:[NSArray arrayWithObjects:curWeatherInfo, [threeDayInfos objectAtIndex:0], [threeDayInfos objectAtIndex:1], [threeDayInfos objectAtIndex:2], nil]];
				[[NSUserDefaults standardUserDefaults] setObject:[arrWeatherInfos objectAtIndex:curUpdating] forKey:[arrAreas objectAtIndex:curUpdating]];
			}
		}
		else 
		{
			NSLog(@"Error: send Synchronous Request failed");
		}
	}
	
		if (isCanGetData)
		{
			[self performSelectorOnMainThread:@selector(getDataSuccess) withObject:nil waitUntilDone: NO];
		}
		else 
		{
			[self performSelectorOnMainThread:@selector(getDataFail) withObject:nil waitUntilDone: NO];
		}
	
	[pool release];
	return isCanGetData;
}

- (void) updateText
{
	self.navigationItem.title = [arrAreas objectAtIndex:pageControl.currentPage];
	if ([updateIndi isAnimating])
	{
		[updateIndi stopAnimating];
	}
	
	NSArray*	  weatherArr = [arrWeatherInfos objectAtIndex:pageControl.currentPage];
	if (((NSNull*)weatherArr != [NSNull null]) && ([weatherArr count] > 0))
	{
		NSDictionary* curWeatherInfo = [weatherArr objectAtIndex:0];
		NSDictionary* day1WeatherInfo;
		NSDictionary* day2WeatherInfo;
		NSDictionary* day3WeatherInfo;
		if ([weatherArr count] == 4)
		{
			day1WeatherInfo = [weatherArr objectAtIndex:1];
			day2WeatherInfo = [weatherArr objectAtIndex:2];
			day3WeatherInfo = [weatherArr objectAtIndex:3];
		}
		
		if (curWeatherInfo)
		{
			if ([curWeatherInfo objectForKey:kCurWeatherCityKey])
			{
				lbCurCity.text = [NSString stringWithFormat:@"Thời tiết %@ hiện tại", [curWeatherInfo objectForKey:kCurWeatherCityKey]];
			}
			if ([curWeatherInfo objectForKey:kUpdateTimeKey])
			{
				lbCurUpdateTime.text = [NSString stringWithFormat:@"Cập nhật lúc: %@", [curWeatherInfo objectForKey:kUpdateTimeKey]];
				lbCurWeather.text = [curWeatherInfo objectForKey:kWeatherKey];
				ivwCurWeather.image = [UIImage imageNamed:[curWeatherInfo objectForKey:kWeatherImageKey]];
				lbCurTemperature.text = [NSString stringWithFormat:@"%@%cC", [curWeatherInfo objectForKey:kCurTemperatureKey], kTempSymbol];
				lbCurHumidity.text = [curWeatherInfo objectForKey:kCurHumidityKey];
				lbCurWind.text = [curWeatherInfo objectForKey:kCurWindKey];
			}
			else 
			{
				lbCurUpdateTime.text = kNoInformation;
			}
		}
		else 
		{
			lbCurUpdateTime.text = kNoInformation;
		}
		
		if (day1WeatherInfo && [day1WeatherInfo objectForKey:kUpdateTimeKey])
		{
			lbFirstDay.text = [day1WeatherInfo objectForKey:kUpdateTimeKey];
			lbFirstWeather.text = [day1WeatherInfo objectForKey:kWeatherKey];
			ivwFirstWeather.image = [UIImage imageNamed:[day1WeatherInfo objectForKey:kWeatherImageKey]];
			lbFirstTemperature.text = [NSString stringWithFormat:@"%@%cC/%@%cC", 
									   [day1WeatherInfo objectForKey:kLowestTempKey], kTempSymbol,
									   [day1WeatherInfo objectForKey:kHighestTempKey], kTempSymbol];
		}
		else 
		{
			lbFirstWeather.text = kNoInformation;
		}
		
		if (day2WeatherInfo && [day2WeatherInfo objectForKey:kUpdateTimeKey])
		{
			lbSecondDay.text = [day2WeatherInfo objectForKey:kUpdateTimeKey];
			lbSecondWeather.text = [day2WeatherInfo objectForKey:kWeatherKey];
			ivwSecondWeather.image = [UIImage imageNamed:[day2WeatherInfo objectForKey:kWeatherImageKey]];
			lbSecondTemperature.text = [NSString stringWithFormat:@"%@%cC/%@%cC", 
										[day2WeatherInfo objectForKey:kLowestTempKey], kTempSymbol,
										[day2WeatherInfo objectForKey:kHighestTempKey], kTempSymbol];
		}
		else 
		{
			lbSecondWeather.text = kNoInformation;
		}
		
		if (day3WeatherInfo && [day3WeatherInfo objectForKey:kUpdateTimeKey])
		{
			lbThirdDay.text = [day3WeatherInfo objectForKey:kUpdateTimeKey];
			lbThirdWeather.text = [day3WeatherInfo objectForKey:kWeatherKey];
			ivwThirdWeather.image = [UIImage imageNamed:[day3WeatherInfo objectForKey:kWeatherImageKey]];
			lbThirdTemperature.text = [NSString stringWithFormat:@"%@%cC/%@%cC", 
									   [day3WeatherInfo objectForKey:kLowestTempKey], kTempSymbol,
									   [day3WeatherInfo objectForKey:kHighestTempKey], kTempSymbol];
		}
		else 
		{
			lbThirdWeather.text = kNoInformation;
		}
	}
	else 
	{
		lbCurUpdateTime.text = kNoInformation;
		lbFirstWeather.text = kNoInformation;
		lbSecondWeather.text = kNoInformation;
		lbThirdWeather.text = kNoInformation;
	}
}

- (void) getDataSuccess
{
	if (curUpdating == pageControl.currentPage)
	{
		[self updateText];
	}
	
	if ([arrUpdateQueue count] > 0)
	{
		[self refresh];
	}
	else 
	{
		self.strUpdateArea = nil;
		curUpdating = -1;
	}
}

- (void) getDataFail
{
	if ((NSNull*)[arrWeatherInfos objectAtIndex:curUpdating] == [NSNull null])
	{
		[self getSaveDataForArea:strUpdateArea];
	}
		
	if (curUpdating == pageControl.currentPage)
	{
		[self updateText];
	}
	
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Lỗi xảy ra khi đang truy vấn thông tin từ máy chủ. Chương trình không cập nhật được thông tin mới nhất." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alertView show];
	[alertView release];
	
	self.strUpdateArea = nil;
	curUpdating = -1;
}


@end

