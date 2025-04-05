//
//  TouchButton.h
//  WeatherForecast
//
//  Created by Trần Thị Yến Linh on 8/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TouchButton : UIButton 
{
	CGPoint		startTouchPt;
	CGPoint		endTouchPt;
}

@property (nonatomic) CGPoint		startTouchPt;
@property (nonatomic) CGPoint		endTouchPt;

@end
