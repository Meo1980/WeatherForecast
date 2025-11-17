//
//  CurWeaViewController.h
//  WeatherForecast
//
//  Created by Trần Thị Yến Linh on 7/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailWeaViewController;

@interface CurWeaViewController : UIViewController 
{
	UITableView*		tblWeather;
	UISegmentedControl*	segControl;
	
	NSMutableArray*		arrRecentView;
	DetailWeaViewController* controller;
}

@property (nonatomic, retain) IBOutlet UITableView* tblWeather;
@property (nonatomic, retain) IBOutlet UISegmentedControl*	segControl;

- (IBAction) onSegmentChange: (id)sender;


@end
