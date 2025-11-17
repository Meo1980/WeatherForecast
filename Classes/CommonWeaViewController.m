//
//  CommonWeaViewController.m
//  WeatherForecast
//
//  Created by Trần Thị Yến Linh on 8/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CommonWeaViewController.h"
#import "WeatherView.h"
#import "CommonDefine.h"
#import "NetReachability.h"
#import "WeatherForecastAppDelegate.h"


@implementation CommonWeaViewController
@synthesize lbUpdateTime;
@synthesize svwWeather;
@synthesize naviItem;
@synthesize updateIndi;
@synthesize isLand;


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	
	UIBarButtonItem* refreshBut = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onRefresh:)];
	naviItem.rightBarButtonItem = refreshBut;
	[refreshBut release];
	
	WeatherList = [[NSMutableArray alloc] init];

	weatherViewList = [[NSMutableArray alloc] init];
	WeatherView*	tmpView;
	if (isLand)
	{
		svwWeather.contentSize = CGSizeMake(320, 170*kWeatherAreasCount);
		naviItem.title = @"Thời tiết đất liền 24h";
		
		for (int i = 0; i < kWeatherAreasCount; i++)
		{
			tmpView = [[WeatherView alloc] initWithFrame:CGRectMake(0, 170*i, 320, 170)];
			tmpView.lbName.text = [NSString stringWithFormat:@"  %@", WeatherAreas[i]];
			tmpView.lbWeather.text = kNoInformation;
			tmpView.isLand = isLand;
			[svwWeather addSubview:tmpView];
			[weatherViewList addObject:tmpView];
			[tmpView release];
		}
	}
	else 
	{
		svwWeather.contentSize = CGSizeMake(320, 175*kSeaWeatherAreasCount);
		naviItem.title = @"Thời tiết biển 24h";
		
		for (int i = 0; i < kSeaWeatherAreasCount; i++)
		{
			tmpView = [[WeatherView alloc] initWithFrame:CGRectMake(0, 175*i, 320, 170)];
			tmpView.lbName.text = [NSString stringWithFormat:@"  %@", SeaWeatherAreas[i]];
			tmpView.lbWeather.text = kNoInformation;
			tmpView.isLand = isLand;
			[svwWeather addSubview:tmpView];
			[weatherViewList addObject:tmpView];
			[tmpView release];
		}
	}	
	
	isUpdating = NO;
	updateIndi.hidesWhenStopped = YES;
	[self refresh];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	NSLog(@"CommonWeaViewController release");
	self.lbUpdateTime = nil;
	self.svwWeather = nil;
	naviItem.rightBarButtonItem = nil;
	self.naviItem = nil;
	self.updateIndi = nil;
	
	if (weatherViewList)
	{
		[weatherViewList release];
	}
	if (WeatherList)
	{
		[WeatherList release];
	}
	
    [super dealloc];
}

- (void) refresh
{
	isUpdating = YES;
	[updateIndi startAnimating];
	self.lbUpdateTime.text = @"";
	[WeatherList removeAllObjects];
	for (WeatherView *tmpView in weatherViewList)
	{
		tmpView.lbWeather.text = @"";
		tmpView.ivwWeather.image = nil;
		if (isLand)
		{
			tmpView.lbDetailText1.text = @"";
			tmpView.lbDetailText2.text = @"";
		}
		else 
		{
			tmpView.lbDetail1.text = @"";
			tmpView.lbDetail2.text = @"";
		}
	}
	
	if ([self isInternetConnected])
	{
		[self performSelectorInBackground: @selector(getWeatherData) withObject: nil];
	}
	else 
	{
		[self getSavedData];
		[self updateText];
	}
}

- (void) onRefresh: (id)sender
{
	if (!isUpdating)
	{
		[self refresh];
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

- (void) parseLandWeatherData:(NSScanner*) scanner	atLocation:(NSInteger)scanLocation
{
	BOOL bScanned = YES;
	NSString *tmpStr;
	NSMutableDictionary* tmpDict;
	NSInteger	startLocation = scanLocation;
	
	for (int i = 0; i < kWeatherAreasCount; i++)
	{
		if ([scanner isAtEnd])
			[scanner setScanLocation:startLocation];
				
		bScanned = [scanner scanUpToString:WeatherAreas[i] intoString:NULL];
		bScanned = [scanner scanString:WeatherAreas[i] intoString:NULL];
		if (bScanned)
		{
			tmpDict = [[NSMutableDictionary alloc] init];
			bScanned = [scanner scanUpToString:@"WeatherSymbol/2008/8/22/" intoString:NULL];
			bScanned = [scanner scanString:@"WeatherSymbol/2008/8/22/" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"\"" intoString:&tmpStr];
				tmpStr = replaceSpecialString(tmpStr);
				tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
				tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@")" withString:@""];
				[tmpDict setObject:tmpStr forKey:kWeatherImageKey];
			}
			bScanned = [scanner scanUpToString:@"class=\"thoitiet_vung\">" intoString:NULL];
			bScanned = [scanner scanString:@"class=\"thoitiet_vung\">" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"</span>" intoString:&tmpStr];
				tmpStr = replaceSpecialString(tmpStr);
				[tmpDict setObject:tmpStr forKey:kWeatherKey];
			}
			bScanned = [scanner scanUpToString:@"Nhiệt độ thấp nhất từ" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"<strong>" intoString:NULL];
				bScanned = [scanner scanString:@"<strong>" intoString:NULL];
				if (bScanned)
				{
					bScanned = [scanner scanUpToString:@"<sup>" intoString:&tmpStr];
					tmpStr = replaceSpecialString(tmpStr);
					[tmpDict setObject:tmpStr forKey:kLowestTempKey];
				}
			}
			bScanned = [scanner scanUpToString:@"Nhiệt độ cao nhất từ" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"<strong>" intoString:NULL];
				bScanned = [scanner scanString:@"<strong>" intoString:NULL];
				if (bScanned)
				{
					bScanned = [scanner scanUpToString:@"<sup>" intoString:&tmpStr];
					tmpStr = replaceSpecialString(tmpStr);
					[tmpDict setObject:tmpStr forKey:kHighestTempKey];
				}
			}
			
			startLocation = [scanner scanLocation];
			[WeatherList addObject:tmpDict];
			[tmpDict release];
		}
		else 
		{
			[WeatherList addObject:[NSNull null]];
		}
	}
}

- (void) parseSeaWeatherData:(NSScanner*) scanner	atLocation:(NSInteger)scanLocation
{
	BOOL bScanned = YES;
	NSString *tmpStr;
	NSMutableDictionary* tmpDict;
	NSInteger	startLocation = scanLocation;

	for (int i = 0; i < kSeaWeatherAreasCount; i++)
	{
		if ([scanner isAtEnd])
			[scanner setScanLocation:startLocation];
		
		bScanned = [scanner scanUpToString:SeaWeatherAreas[i] intoString:NULL];
		bScanned = [scanner scanString:SeaWeatherAreas[i] intoString:NULL];
		if (bScanned)
		{
			tmpDict = [[NSMutableDictionary alloc] init];
			bScanned = [scanner scanUpToString:@"<img src=\"" intoString:NULL];
			bScanned = [scanner scanString:@"<img src=\"" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"\"" intoString:&tmpStr];
				tmpStr = replaceSpecialString(tmpStr);
				NSURL *imgUrl = [NSURL URLWithString:tmpStr];
				NSData *data = [NSData dataWithContentsOfURL:imgUrl];
				//UIImage* weaImg = [[UIImage alloc] initWithData:data];
				//[tmpDict setObject:weaImg forKey:kWeatherImageKey];
				[tmpDict setObject:data forKey:kWeatherImageKey];
				//[weaImg release];
			}
			bScanned = [scanner scanUpToString:@"class=\"thoitiet_vung\">" intoString:NULL];
			bScanned = [scanner scanString:@"class=\"thoitiet_vung\">" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"</span>" intoString:&tmpStr];
				tmpStr = replaceSpecialString(tmpStr);
				[tmpDict setObject:tmpStr forKey:kWeatherKey];
			}
			bScanned = [scanner scanUpToString:@"Tầm nhìn xa" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"</span>" intoString:NULL];
				bScanned = [scanner scanString:@"</span>" intoString:NULL];
				if (bScanned)
				{
					bScanned = [scanner scanUpToString:@"</span>" intoString:&tmpStr];
					tmpStr = replaceSpecialString(tmpStr);
					[tmpDict setObject:tmpStr forKey:kSeeingRangeKey];
				}
			}
			bScanned = [scanner scanUpToString:@"class=\"thoitiet_vung\">" intoString:NULL];
			bScanned = [scanner scanString:@"class=\"thoitiet_vung\">" intoString:NULL];
			if (bScanned)
			{
				bScanned = [scanner scanUpToString:@"</span>" intoString:&tmpStr];
				tmpStr = replaceSpecialString(tmpStr);
				[tmpDict setObject:tmpStr forKey:kWindSpeedKey];
			}
			
			startLocation = [scanner scanLocation];
			[WeatherList addObject:tmpDict];
			[tmpDict release];
		}
		else 
		{
			[WeatherList addObject:[NSNull null]];
		}
	}
}

- (BOOL) getWeatherData
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	BOOL isCanGetData = NO;
	
//	if ([self isInternetConnected])
//	{
	NSDictionary *linkDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DBTT" ofType:@"plist"]];
	NSString *link = [linkDict objectForKey:(isLand ? @"DatLien" : @"Bien")];
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
			BOOL bScanned = YES;
			NSString *tmpStr;
			
			// Lay ngay cap nhat thoi tiet
			bScanned = [scanner scanUpToString:@"SubTitleNews_Special" intoString:NULL];
			bScanned = [scanner scanString:@"SubTitleNews_Special" intoString:NULL];
			if (bScanned)
			{
				isCanGetData = YES;
				
				bScanned = [scanner scanUpToString:@">" intoString:NULL];
				bScanned = [scanner scanString:@">" intoString:NULL];
				if (bScanned)
				{
					bScanned = [scanner scanUpToString:@"</td>" intoString:&tmpStr];
					tmpStr = replaceSpecialString(tmpStr);
					[WeatherList addObject:tmpStr];
				}
				
				if (isLand)
				{
					[self parseLandWeatherData:scanner atLocation:[scanner scanLocation]];
				}
				else 
				{
					[self parseSeaWeatherData:scanner atLocation:[scanner scanLocation]];
				}
			}
		}
		else 
		{
			NSLog(@"Error: send Synchronous Request failed");
		}
	}
	
	if (!isCanGetData)
	{
//		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Lỗi xảy ra khi truy vấn thông tin từ máy chủ. Chương trình sẽ hiển thị dữ liệu thời tiết của lần truy cập gần nhất." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//		[alertView show];
//		[alertView release];
		[self performSelectorOnMainThread:@selector(getDataFail) withObject:nil waitUntilDone: NO];
	}
	else 
	{
		[self performSelectorOnMainThread:@selector(updateText) withObject:nil waitUntilDone: NO];
	}
	
	[pool release];
	return isCanGetData;
}

- (void) getSavedData
{
	NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
	if (isLand)
	{
		if ([userDefault objectForKey:@"Đất Liền"])
		{
			[WeatherList addObjectsFromArray:[userDefault objectForKey:@"Đất Liền"]];
		}
	}
	else 
	{
		if ([userDefault objectForKey:@"Biển"])
		{
			[WeatherList addObjectsFromArray:[userDefault objectForKey:@"Biển"]];
		}
	}
}

- (void) getDataFail
{
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Lỗi xảy ra khi truy vấn thông tin từ máy chủ. Chương trình sẽ hiển thị dữ liệu thời tiết của lần truy cập gần nhất." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alertView show];
	[alertView release];
	
	[self getSavedData];
	[self updateText];
}

- (void) updateText
{
	[updateIndi stopAnimating];
	isUpdating = NO;

	if (WeatherList && ([WeatherList count] > 0))
	{
		if (isLand)
		{
			[[NSUserDefaults standardUserDefaults] setObject:WeatherList forKey:@"Đất Liền"];
		}
		else 
		{
			[[NSUserDefaults standardUserDefaults] setObject:WeatherList forKey:@"Biển"];
		}

		self.lbUpdateTime.text = [WeatherList objectAtIndex:0];
		NSDictionary* tmpDict;
		WeatherView*  tmpView;
		for (int i = 1; i < [WeatherList count]; i ++)
		{
			tmpDict = [WeatherList objectAtIndex:i];
			tmpView = [weatherViewList objectAtIndex:i - 1];
			if (tmpDict && ((NSNull*)tmpDict != [NSNull null]))
			{
				tmpView.lbWeather.text = [tmpDict objectForKey:kWeatherKey];
				if (isLand)
				{
					tmpView.ivwWeather.image = [UIImage imageNamed:[tmpDict objectForKey:kWeatherImageKey]];
					tmpView.lbDetailText1.text = [NSString stringWithFormat:@"%@%cC", [tmpDict objectForKey:kLowestTempKey], kTempSymbol];
					tmpView.lbDetailText2.text = [NSString stringWithFormat:@"%@%cC", [tmpDict objectForKey:kHighestTempKey], kTempSymbol];
				}
				else 
				{
					//tmpView.ivwWeather.image = (UIImage*)[tmpDict objectForKey:kWeatherImageKey];
					tmpView.ivwWeather.image = [UIImage imageWithData: [tmpDict objectForKey:kWeatherImageKey]];
					tmpView.lbDetail1.text = [NSString stringWithFormat:@"Tầm nhìn xa: %@", [tmpDict objectForKey:kSeeingRangeKey]];
					tmpView.lbDetail2.text = [tmpDict objectForKey:kWindSpeedKey];
				}
			}
		}
	}
	else 
	{
		self.lbUpdateTime.text = kNoInformation;
	}

}



@end
