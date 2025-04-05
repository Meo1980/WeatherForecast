//
//  WeatherTableViewCell.m
//  Weather Forecast
//
//  Created by Nguyen Quang Minh on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WeatherTableViewCell.h"


@implementation WeatherTableViewCell

//@synthesize lblDownloadStatus = _lblDownloadStatus;
@synthesize isGeneralWeather = _isGeneralWeather;
//@synthesize lbLowestTemp = _lbLowestTemp;
//@synthesize lbHighestTemp = _lbHighestTemp;
//@synthesize lbHumidity = _lbHumidity;
//@synthesize lbWind = _lbWind;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		// turn off selection use
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	
		_isGeneralWeather = NO;
		
// 		_lbLowestTemp = [[UILabel alloc] initWithFrame:CGRectZero];
//		_lbLowestTemp.font = [UIFont italicSystemFontOfSize: 12.0];
//		_lbLowestTemp.backgroundColor = [UIColor clearColor];
//		_lbLowestTemp.textColor = [UIColor grayColor];
//		_lbLowestTemp.textAlignment = UITextAlignmentRight;
//		[self.contentView addSubview:_lbLowestTemp];
//		[_lbLowestTemp release];
	}
    return self;
}

/*
- (id)initWithFrame:(CGRect)aRect reuseIdentifier:(NSString *)identifier
{
	if (self = [super initWithFrame:aRect reuseIdentifier:identifier])
	{
		// turn off selection use
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		_lblDownloadStatus = [[UILabel alloc] initWithFrame:CGRectZero];
		_lblDownloadStatus.font = [UIFont systemFontOfSize:10.0];
		_lblDownloadStatus.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_lblDownloadStatus];
		[_lblDownloadStatus release];		
	}
	return self;
}
*/

- (void)layoutSubviews
{	
	[super layoutSubviews];
	CGRect contentRect = [self.contentView bounds];
	self.textLabel.backgroundColor = [UIColor clearColor];
	
	if (_isGeneralWeather)
	{
		self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, 
										  contentRect.size.height/2 - self.imageView.frame.size.height/2, 
										  self.imageView.frame.size.width, 
										  self.imageView.frame.size.height);
		self.textLabel.frame = CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width + 5, 
										  0, 
										  contentRect.size.width - (self.imageView.frame.origin.x + self.imageView.frame.size.width + 5),
										  contentRect.size.height);
	}
	else 
	{
		self.imageView.frame = CGRectZero;
		self.textLabel.frame = CGRectMake(5, 5, contentRect.size.width/2 - 5, contentRect.size.height - 5);
		self.detailTextLabel.frame = CGRectMake(contentRect.size.width/2, 5, contentRect.size.width/2 - 5, contentRect.size.height - 5);
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc 
{
    [super dealloc];
}

- (void) setGeneralWeather:(BOOL)isGeneral
{
	_isGeneralWeather = isGeneral;
	self.textLabel.numberOfLines = 0;
	self.textLabel.font = [UIFont systemFontOfSize:14];
	self.textLabel.adjustsFontSizeToFitWidth = NO;
	//self.imageView.contentMode = UIViewContentModeCenter;
	
	if (!_isGeneralWeather)
	{
		self.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
		self.detailTextLabel.textAlignment = UITextAlignmentLeft;
	}
}

@end
