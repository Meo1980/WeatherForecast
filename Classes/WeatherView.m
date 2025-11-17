//
//  WeatherView.m
//  WeatherForecast
//
//  Created by Trần Thị Yến Linh on 8/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WeatherView.h"


@implementation WeatherView
@synthesize isLand;
@synthesize ivwWeather;
@synthesize lbName;
@synthesize lbWeather;
@synthesize lbDetail1;
@synthesize lbDetail2;
@synthesize lbDetailText1;
@synthesize lbDetailText2;


- (id)initWithFrame:(CGRect)frame		// (320, 170)
{
    if ((self = [super initWithFrame:frame])) 
	{	
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		isLand = NO;
		
		lbName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
		lbName.backgroundColor = [UIColor colorWithRed:0.0 green:102.0/255.0 blue:1.0 alpha:1.0];
		lbName.font = [UIFont boldSystemFontOfSize:16];
		lbName.textColor = [UIColor whiteColor];
		[self addSubview:lbName];
		[lbName release];
		
		ivwWeather = [[UIImageView alloc] initWithFrame:CGRectMake(5, 30, 90, 90)];
		ivwWeather.contentMode = UIViewContentModeCenter;
		[self addSubview:ivwWeather];
		[ivwWeather release];
		
//		lbWeather = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 215, 35)];
		lbWeather = [[UITextView alloc] initWithFrame:CGRectMake(100, 30, 215, 35)];
		lbWeather.backgroundColor = [UIColor clearColor];
		lbWeather.font = [UIFont fontWithName:@"American Typewriter" size:14];
		lbWeather.editable = NO;
		[self addSubview:lbWeather];
		[lbWeather release];
		
		//lbDetail1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 70, 215, 50)];
		lbDetail1 = [[UITextView alloc] initWithFrame:CGRectMake(100, 70, 215, 50)];
		lbDetail1.backgroundColor = [UIColor clearColor];
		lbDetail1.font = [UIFont fontWithName:@"American Typewriter" size:14];
		//lbDetail1.numberOfLines = 0;
		lbDetail1.editable = NO;
		[self addSubview:lbDetail1];
		[lbDetail1 release];
		
		//lbDetail2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 120, 310, 50)];
		lbDetail2 = [[UITextView alloc] initWithFrame:CGRectMake(5, 120, 310, 50)];
		lbDetail2.backgroundColor = [UIColor clearColor];
		lbDetail2.font = [UIFont fontWithName:@"American Typewriter" size:14];
		//lbDetail2.numberOfLines = 0;
		lbDetail2.editable = NO;
		[self addSubview:lbDetail2];
		[lbDetail2 release];
    }
    return self;
}

- (void) setLandorSea: (BOOL) land
{
	isLand = land;
	if (isLand)
	{
		ivwWeather.frame = CGRectMake(15, 35, 55, 45);
		lbWeather.frame = CGRectMake(0, 80, 320, 85);
		//lbDetail1.frame = CGRectMake(80, 35, 135, 21);		// Show "Nhiet do thap nhat"
		lbDetail1.frame = CGRectMake(70, 29, 155, 35);		// Show "Nhiet do thap nhat"
		lbDetail1.text = @"Nhiệt độ thấp nhất:";
		//lbDetail2.frame = CGRectMake(80, 55, 135, 21);		// Show "Nhiet do cao nhat"
		lbDetail2.frame = CGRectMake(70, 49, 155, 35);		// Show "Nhiet do cao nhat"
		lbDetail2.text = @"Nhiệt độ cao nhất:";
		
		lbDetailText1 = [[UILabel alloc] initWithFrame:CGRectMake(220, 35, 100, 21)];
		lbDetailText1.backgroundColor = [UIColor clearColor];
		lbDetailText1.font = [UIFont fontWithName:@"American Typewriter" size:14];
		lbDetailText1.textColor = [UIColor blueColor];
		lbDetailText1.numberOfLines = 0;
		[self addSubview:lbDetailText1];
		[lbDetailText1 release];
		
		lbDetailText2 = [[UILabel alloc] initWithFrame:CGRectMake(220, 55, 100, 21)];
		lbDetailText2.backgroundColor = [UIColor clearColor];
		lbDetailText2.font = [UIFont fontWithName:@"American Typewriter" size:14];
		lbDetailText2.textColor = [UIColor redColor];
		lbDetailText2.numberOfLines = 0;
		[self addSubview:lbDetailText2];
		[lbDetailText2 release];
	}
	else 
	{
		ivwWeather.frame = CGRectMake(5, 30, 90, 90);
//		lbWeather.frame = CGRectMake(100, 25, 215, 50);
//		lbDetail1.frame = CGRectMake(100, 75, 215, 50);		// Show "Tam nhin xa"
//		lbDetail2.frame = CGRectMake(5, 125, 310, 50);		// Show "Cap gio"
		lbWeather.frame = CGRectMake(90, 25, 230, 50);
		lbDetail1.frame = CGRectMake(90, 75, 230, 50);		// Show "Tam nhin xa"
		lbDetail2.frame = CGRectMake(0, 125, 320, 50);		// Show "Cap gio"
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc 
{
	NSLog(@"WeatherView release");
	self.ivwWeather = nil;
	self.lbName = nil;
	self.lbWeather = nil;
	self.lbDetail1 = nil;
	self.lbDetail2 = nil;
	if (isLand)
	{
		self.lbDetailText1 = nil;
		self.lbDetailText2 = nil;
	}
	
    [super dealloc];
}


@end
