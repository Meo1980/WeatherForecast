//
//  TouchButton.m
//  WeatherForecast
//
//  Created by Trần Thị Yến Linh on 8/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TouchButton.h"


@implementation TouchButton
@synthesize startTouchPt;
@synthesize endTouchPt;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	if ([touches count] == 1)
	{
		UITouch *touch = [[touches allObjects] objectAtIndex:0];
		startTouchPt = [touch locationInView:[self superview]];
	}	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	if ([touches count] == 1)
	{
		UITouch *touch = [[touches allObjects] objectAtIndex:0];
		endTouchPt = [touch locationInView:[self superview]];
	}
}

- (void)dealloc {
    [super dealloc];
}


@end
