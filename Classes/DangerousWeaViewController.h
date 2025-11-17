//
//  DangerousWeaViewController.h
//  WeatherForecast
//
//  Created by Trần Thị Yến Linh on 8/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHTMLHeader	@"<head>\
	<title></title>\
	<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\n\
	<meta http-equiv=\"Content-Style-Type\" content=\"text/css\">\n\
	<meta name=\"viewport\" content=\"width=320\"/>\n\
	<style type=\"text/css\">\n\
	td.nodata {color: red;}\n\
	td.TitleNews_Special {color: #0066ff;}\n\
	td.nav_link {color: #0066ff;}\n\
	</style>\n\
	</head>"

@interface DangerousWeaViewController : UIViewController 
{
	UISegmentedControl* segControl;
	//UITextView*			txvWarning;
	UIWebView*				webWarning;
	UINavigationItem*	naviItem;
	NSMutableArray*		arrWarnings;
	UIActivityIndicatorView*	updateIndi;
	
	BOOL				isUpdating;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl* segControl;
//@property (nonatomic, retain) IBOutlet UITextView*		   txvWarning;
@property (nonatomic, retain) IBOutlet UIWebView*				webWarning;
@property (nonatomic, retain) IBOutlet UINavigationItem*	naviItem;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView*	updateIndi;

- (BOOL) getWeatherData;
- (void) refresh;
- (void) updateText;
- (BOOL) isInternetConnected;

- (IBAction) onWarningSegChange:(id)sender;


@end
