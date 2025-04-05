//
//  DangerousWeaViewController.m
//  WeatherForecast
//
//  Created by Trần Thị Yến Linh on 8/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DangerousWeaViewController.h"
#import "CommonDefine.h"
#import "NetReachability.h"
#import "WeatherForecastAppDelegate.h"


@implementation DangerousWeaViewController
@synthesize segControl;
//@synthesize txvWarning;
@synthesize webWarning;
@synthesize naviItem;
@synthesize updateIndi;

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
	
	//txvWarning.inputView.backgroundColor = [UIColor clearColor];
//	txvWarning.editable = NO;
//	txvWarning.font = [UIFont fontWithName:@"American Typewriter" size:15];
//	txvWarning.textAlignment = UITextAlignmentLeft;
	
	UIBarButtonItem* refreshBut = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onRefresh:)];
	naviItem.rightBarButtonItem = refreshBut;
	[refreshBut release];
	
	arrWarnings = [[NSMutableArray alloc] init];
	for (int i = 0; i < segControl.numberOfSegments; i++)
	{
		[arrWarnings addObject:@"<center>Không lấy được thông tin.</center>"];
	}
	isUpdating = NO;
	
	updateIndi.hidesWhenStopped = YES;
	
	[self refresh];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
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
	NSLog(@"DangerousWeaViewController release");
	//self.txvWarning = nil;
	self.webWarning = nil;
	self.segControl = nil;
	naviItem.rightBarButtonItem = nil;
	self.naviItem = nil;
	self.updateIndi = nil;
	[arrWarnings release];
	
    [super dealloc];
}

- (IBAction) onWarningSegChange:(id)sender
{
	//txvWarning.text = [arrWarnings objectAtIndex:segControl.selectedSegmentIndex];
	NSString* htmlString = [NSString stringWithFormat:@"<html>%@<body style=\"background-color: transparent\">%@</body></html>", kHTMLHeader, [arrWarnings objectAtIndex:segControl.selectedSegmentIndex]];
	[webWarning loadHTMLString:htmlString baseURL:nil];
}

- (void) refresh
{
	isUpdating = YES;
	[updateIndi startAnimating];
	//txvWarning.text = @"";
	[webWarning loadHTMLString:nil baseURL:nil];
	
	if ([self isInternetConnected])
	{
		[self performSelectorInBackground: @selector(getWeatherData) withObject: nil];
	}
	else 
	{
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
    UIAlertController* controller = [UIAlertController alertControllerWithTitle:nil message:<#(nullable NSString *)#> preferredStyle:<#(UIAlertControllerStyle)#>]
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Máy của bạn cần có kết nối Internet để tải được thông tin mới nhất từ máy chủ." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alertView show];
		[alertView release];
		[reachability release];
		return NO;
	}
	[reachability release];
	return YES;
}

- (NSString*) getWarningString:(NSScanner*) scanner
{
	NSString *retStr = @"";
	BOOL bScanned = YES;
	
	bScanned = [scanner scanUpToString:@"left_ver_box" intoString:NULL];
	bScanned = [scanner scanString:@"left_ver_box" intoString:NULL];
	if (bScanned)
	{
		bScanned = [scanner scanUpToString:@"<table" intoString:NULL];
		if (![scanner isAtEnd])
		{
		//	isCanGetData = YES;
			NSInteger scanLocation = [scanner scanLocation];
			bScanned = [scanner scanString:@"<table" intoString:NULL];
			
			NSInteger tableLocation = [scanner scanLocation];
			NSInteger endTableLocation = [scanner scanLocation];
			do 
			{
				[scanner scanUpToString:@"<table" intoString:NULL];
				[scanner scanString:@"<table" intoString:NULL];
				tableLocation = [scanner scanLocation];
				
				[scanner setScanLocation:endTableLocation];
				[scanner scanUpToString:@"</table>" intoString:NULL];
				[scanner scanString:@"</table>" intoString:NULL];
				if (![scanner isAtEnd])
				{
					endTableLocation = [scanner scanLocation];
				}
				[scanner setScanLocation:tableLocation];
			} while (tableLocation < endTableLocation);
			
			retStr = [[scanner string] substringWithRange:NSMakeRange(scanLocation, endTableLocation - scanLocation)];
			retStr = [retStr stringByReplacingOccurrencesOfString:@"class=\"nav_link_title bgr_bottomLineDetail\"" withString:@"style=\"color: white; background-color: #0066ff;\""];
		}
	}
	
	return retStr;
}

- (BOOL) parseWarning:(NSData*) weatherData	atIndex:(NSInteger)index
{
	BOOL isCanGetData = NO;
	
	NSString *detailWeatherPage;
	NSScanner *scanner;
	NSString *htmlWarning;
//	BOOL bScanned;
//	NSInteger scanLocation;
	
	if (weatherData)
	{
		detailWeatherPage = [[[NSString alloc] initWithData:weatherData encoding:NSUTF8StringEncoding] autorelease];
		scanner = [NSScanner scannerWithString:detailWeatherPage];
//		bScanned = YES;
		
		htmlWarning = [self getWarningString:scanner];
		if (![htmlWarning isEqualToString:@""])
		{
			isCanGetData = YES;
			[arrWarnings replaceObjectAtIndex:index withObject:retStr];
			}
		}
		// Lay ngay cap nhat thoi tiet
/*		bScanned = [scanner scanUpToString:@"nav_link_title bgr_bottomLineDetail" intoString:NULL];
		bScanned = [scanner scanString:@"nav_link_title bgr_bottomLineDetail" intoString:NULL];
		if (bScanned)
		{
			isCanGetData = YES;
			scanLocation = [scanner scanLocation];
			
			bScanned = [scanner scanUpToString:@"_ctl1__ctl1__ctl0_lbl_Nodata_TTNH" intoString:NULL];
			bScanned = [scanner scanString:@"_ctl1__ctl1__ctl0_lbl_Nodata_TTNH" intoString:NULL];
			if (!bScanned)
			{
//				if (index == 0)
//				{
//					NSString* tmpStr = @"Hiện nay (l&#250;c 17h30 ph&#250;t ng&#224;y 13/8) ở khu vực ph&#237;a đ&#244;ng nam của H&#224; Nội đang xuất hiện một đ&#225;m m&#226;y d&#244;ng dịch chuyển về ph&#237;a khu vực trung t&#226;m th&#224;nh phố H&#224; Nội.";
//				tmpStr = replaceSpecialString(tmpStr);
//				tmpStr = [self deleteHTMLFormatSlyte:tmpStr];
//				[arrWarnings replaceObjectAtIndex:index withObject:tmpStr];
//				}
//			}
//			else 
//			{
				NSString *tmpStr1 = @"";
				NSString *tmpStr2 = @"";

				[scanner setScanLocation:scanLocation];
				bScanned = [scanner scanUpToString:@"TitleNews_Special" intoString:NULL];
				bScanned = [scanner scanString:@"TitleNews_Special" intoString:NULL];
				if (bScanned)
				{
					scanLocation = [scanner scanLocation];
					bScanned = [scanner scanUpToString:@">" intoString:NULL];
					bScanned = [scanner scanString:@">" intoString:NULL];
					if (bScanned)
					{
						bScanned = [scanner scanUpToString:@"</td>" intoString:&tmpStr1];
						tmpStr1 = replaceSpecialString(tmpStr1);
						tmpStr1 = 
						//tmpStr1 = [self deleteHTMLFormatSlyte:tmpStr];
					}
				}
				else 
				{
					[scanner setScanLocation:scanLocation];
				}
				
				bScanned = [scanner scanUpToString:@"<DIV" intoString:NULL];
				bScanned = [scanner scanString:@"<DIV" intoString:NULL];
				if (bScanned)
				{
					scanLocation = [scanner scanLocation];
					bScanned = [scanner scanUpToString:@">" intoString:NULL];
					bScanned = [scanner scanString:@">" intoString:NULL];
					if (bScanned)
					{
						bScanned = [scanner scanUpToString:@"</DIV>" intoString:&tmpStr2];
						//tmpStr1 = replaceSpecialString(tmpStr1);
						//tmpStr1 = [self deleteHTMLFormatSlyte:tmpStr];
					}
				}
				else 
				{
				}
				
//				bScanned = [scanner scanUpToString:@"SummryNews" intoString:NULL];
//				bScanned = [scanner scanString:@"SummryNews" intoString:NULL];
//				if (bScanned)
//				{
//					scanLocation = [scanner scanLocation];
//					bScanned = [scanner scanUpToString:@">" intoString:NULL];
//					bScanned = [scanner scanString:@">" intoString:NULL];
//					if (bScanned)
//					{
//						bScanned = [scanner scanUpToString:@"</td>" intoString:&tmpStr1];
//						tmpStr1 = replaceSpecialString(tmpStr1);
//						tmpStr1 = [self deleteHTMLFormatSlyte:tmpStr1];
//					}
//				}
//				else 
//				{
//					[scanner setScanLocation:scanLocation];
//				}
//				bScanned = [scanner scanUpToString:@"ContentNews" intoString:NULL];
//				bScanned = [scanner scanString:@"ContentNews" intoString:NULL];
//				if (bScanned)
//				{
//					scanLocation = [scanner scanLocation];
//					bScanned = [scanner scanUpToString:@">" intoString:NULL];
//					bScanned = [scanner scanString:@">" intoString:NULL];
//					if (bScanned)
//					{
//						bScanned = [scanner scanUpToString:@"</td>" intoString:&tmpStr2];
//						tmpStr2 = replaceSpecialString(tmpStr2);
//						tmpStr2 = [self deleteHTMLFormatSlyte:tmpStr2];
//					}
//				}
				[arrWarnings replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%@\n\n%@", tmpStr1, tmpStr2]];
			}
		}*/
	}

	return isCanGetData;
}

- (BOOL) parseMostDangerous:(NSData*) weatherData
{
	BOOL isCanGetData = NO;
	
	NSString *detailWeatherPage;
	NSScanner *scanner;
	BOOL bScanned;
	NSInteger scanLocation;
	
	if (weatherData)
	{
		detailWeatherPage = [[[NSString alloc] initWithData:weatherData encoding:NSUTF8StringEncoding] autorelease];
		scanner = [NSScanner scannerWithString:detailWeatherPage];
		bScanned = YES;
	}
	
	return isCanGetData;
}

- (BOOL) getWeatherData
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	BOOL isCanGetData = NO;
	
	NSDictionary *linkDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DBTT" ofType:@"plist"]];
	
	NSString *link = [linkDict objectForKey:@"NguyHiem-BaoATND"];
	link = [NSString stringWithFormat:@"%@%@/Default.aspx", kRootLink, link];
	NSURL *linkURL = [NSURL URLWithString:link];
	NSMutableURLRequest *weatherLinkRequest = [NSMutableURLRequest requestWithURL:linkURL];
	[weatherLinkRequest setHTTPMethod:@"GET"];
	NSData* weatherData = [NSURLConnection sendSynchronousRequest:weatherLinkRequest returningResponse:NULL error:NULL];
	isCanGetData = [self parseWarning:weatherData atIndex:0];
	
	if (isCanGetData)
	{
		link = [linkDict objectForKey:@"NguyHiem-KKL"];
		link = [NSString stringWithFormat:@"%@%@/Default.aspx", kRootLink, link];
		linkURL = [NSURL URLWithString:link];
		weatherLinkRequest = [NSMutableURLRequest requestWithURL:linkURL];
		[weatherLinkRequest setHTTPMethod:@"GET"];
		weatherData = [NSURLConnection sendSynchronousRequest:weatherLinkRequest returningResponse:NULL error:NULL];
		isCanGetData = [self parseWarning:weatherData atIndex:1];
	}

	if (isCanGetData)
	{
		link = [linkDict objectForKey:@"NguyHiem-NN"];
		link = [NSString stringWithFormat:@"%@%@/Default.aspx", kRootLink, link];
		linkURL = [NSURL URLWithString:link];
		weatherLinkRequest = [NSMutableURLRequest requestWithURL:linkURL];
		[weatherLinkRequest setHTTPMethod:@"GET"];
		weatherData = [NSURLConnection sendSynchronousRequest:weatherLinkRequest returningResponse:NULL error:NULL];
		isCanGetData = [self parseWarning:weatherData atIndex:2];
	}
	
	if (isCanGetData)
	{
		link = [linkDict objectForKey:@"NguyHiem-KH"];
		link = [NSString stringWithFormat:@"%@%@/Default.aspx", kRootLink, link];
		linkURL = [NSURL URLWithString:link];
		weatherLinkRequest = [NSMutableURLRequest requestWithURL:linkURL];
		[weatherLinkRequest setHTTPMethod:@"GET"];
		weatherData = [NSURLConnection sendSynchronousRequest:weatherLinkRequest returningResponse:NULL error:NULL];
		isCanGetData = [self parseWarning:weatherData atIndex:3];	
	}
	
	if (isCanGetData)
	{
		link = [linkDict objectForKey:@"NguyHiem"];
		link = [NSString stringWithFormat:@"%@%@/Default.aspx", kRootLink, link];
		linkURL = [NSURL URLWithString:link];
		weatherLinkRequest = [NSMutableURLRequest requestWithURL:linkURL];
		[weatherLinkRequest setHTTPMethod:@"GET"];
		weatherData = [NSURLConnection sendSynchronousRequest:weatherLinkRequest returningResponse:NULL error:NULL];
		isCanGetData = [self parseMostDangerous:weatherData];	
	}
	
	if (!isCanGetData)
	{
		[self performSelectorOnMainThread:@selector(getDataFail) withObject:nil waitUntilDone: NO];
	}
	else 
	{
		[self performSelectorOnMainThread:@selector(updateText) withObject:nil waitUntilDone: NO];
	}
	[pool release];
	return isCanGetData;
}

- (void) getDataFail
{
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Lỗi xảy ra khi truy vấn thông tin từ máy chủ. Chương trình không lấy được bất kì thông tin cảnh báo nào." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alertView show];
	[alertView release];
	
	[self updateText];
}

- (void) updateText
{
	[updateIndi stopAnimating];
	isUpdating = NO;
	//txvWarning.text = [arrWarnings objectAtIndex:segControl.selectedSegmentIndex];
	NSString* htmlString = [NSString stringWithFormat:@"<html>%@<body>%@</body style=\"background-color: transparent\"></html>", kHTMLHeader, [arrWarnings objectAtIndex:segControl.selectedSegmentIndex]];
	[webWarning loadHTMLString:htmlString baseURL:nil];
}

@end
