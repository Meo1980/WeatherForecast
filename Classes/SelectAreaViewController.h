//
//  SelectAreaViewController.h
//  WeatherForecast
//
//  Created by Trần Thị Yến Linh on 8/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SelectAreaViewController : UIViewController 
{
	UIView*			vwAreaPicking;
	UITableView*	tvwFavourite;
	UIPickerView*	pvwArea;
	
	NSMutableArray*	arrFavourite;
}
@property (nonatomic, retain) IBOutlet UIView*			vwAreaPicking;
@property (nonatomic, retain) IBOutlet UITableView*		tvwFavourite;
@property (nonatomic, retain) IBOutlet UIPickerView*	pvwArea;

@property (nonatomic, retain) NSMutableArray*	arrFavourite;

//- (IBAction) onDoneSelectArea: (id)sender;
- (IBAction) onAddArea: (id)sender;

@end
