/*
 *  CommonDefine.m
 *  WeatherForecast
 *
 *  Created by Trần Thị Yến Linh on 7/31/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */


const NSString* WeatherAreas[] = 
{
	@"Phía Tây Bắc Bộ",
	@"Phía Đông Bắc Bộ",
	@"Thanh Hóa - Thừa Thiên Huế",
	@"Đà Nẵng đến Bình Thuận",
	@"Tây Nguyên",
	@"Nam Bộ", 
	@"Hà Nội"
};

const NSInteger kWeatherAreasCount = sizeof(WeatherAreas) / sizeof(WeatherAreas[0]);

const NSString* SeaWeatherAreas[] = 
{
	@"Bắc Vịnh Bắc Bộ",
	@"Nam Vịnh Bắc Bộ",
	@"Quảng Trị đến Quảng Ngãi",
	@"Bình Định đến Ninh Thuận",
	@"Bình Thuận đến Cà Mau",
	@"Cà Mau đến Kiên Giang",
	@"Bắc Biển Đông",
	@"Vùng Giữa Biển Đông",
	@"Vùng Nam Biển Đông",
	@"Vịnh Thái Lan"
};

const NSInteger kSeaWeatherAreasCount = sizeof(SeaWeatherAreas) / sizeof(SeaWeatherAreas[0]);

const NSString* TayBacBoTowns [] = 
{
	@"Điện Biên",
	@"Hòa Bình",
	@"Lai Châu",
	@"Lào Cai",
	@"Sơn La",
	@"Yên Bái"
};

const NSInteger kTayBacBoTownsCount = sizeof(TayBacBoTowns) / sizeof(TayBacBoTowns[0]);

const NSString* DongBacBoTowns [] = 
{
	@"Bắc Cạn",
	@"Bắc Giang",
	@"Bắc Ninh",
	@"Cao Bằng",
	@"Hà Giang",
	@"Hà Tây (cũ)",
	@"Hải Dương",
	@"Hải Phòng",
	@"Hưng Yên",
	@"Lạng Sơn",
	@"Nam Định",
	@"Ninh Bình",
	@"Phủ Lý",
	@"Quảng Ninh",
	@"Thái Bình",
	@"Thái Nguyên",
	@"Tuyên Quang",
	@"T.P Hà Nội",
	@"Việt Trì",
	@"Vĩnh Phúc"
};

const NSInteger kDongBacBoTownsCount = sizeof(DongBacBoTowns) / sizeof(DongBacBoTowns[0]);

const NSString* ThanhHoaHueTowns [] = 
{
	@"Hà Tĩnh",
	@"Quảng Bình",
	@"Quảng Trị",
	@"Thanh Hóa",
	@"Thừa Thiên Huế",
	@"Vinh"
};

const NSInteger kThanhHoaHueTownsCount = sizeof(ThanhHoaHueTowns) / sizeof(ThanhHoaHueTowns[0]);

const NSString* DaNangBinhThuanTowns [] = 
{
	@"Bình Định",
	@"Bình Thuận",
	@"Đà Nẵng",
	@"Nha Trang",
	@"Ninh Thuận",
	@"Phú Yên",
	@"Quảng Nam",
	@"Quảng Ngãi"
};

const NSInteger kDaNangBinhThuanTownsCount = sizeof(DaNangBinhThuanTowns) / sizeof(DaNangBinhThuanTowns[0]);

const NSString* TayNguyenTowns [] = 
{
	@"Đà Lạt",
	@"Đắk Lắk",
	@"Đắk Nông",
	@"Kon Tum",
	@"Pleiku"
};

const NSInteger kTayNguyenTownsCount = sizeof(TayNguyenTowns) / sizeof(TayNguyenTowns[0]);

const NSString* NamBoTowns [] = 
{
	@"An Giang",
	@"Bạc Liêu",
	@"Bến Tre",
	@"Bình Dương",
	@"Bình Phước",
	@"Cà Mau",
	@"Cần Thơ",
	@"Đồng Nai",
	@"Đồng Tháp",
	@"Hậu Giang",
	@"Kiên Giang",
	@"Long An",
	@"Sóc Trăng",
	@"Tây Ninh",
	@"Tiền Giang",
	@"T.P Hồ Chí Minh",
	@"Vĩnh Long",
	@"Vũng Tàu"
};

const NSInteger kNamBoTownsCount = sizeof(NamBoTowns) / sizeof(NamBoTowns[0]);

#define kNbsp				@"&nbsp;"
#define kLt					@"&lt;"
#define kGt					@"&gt;"
#define kAmp				@"&amp;"
#define kQuot				@"&quot;"
#define kApos				@"&apos;"
#define kCent               @"&cent;"
#define kPound              @"&pound;"
#define kYen                @"&yen;"
#define kEuro               @"&euro;"
#define kSec                @"&sect;"
#define kCopyR              @"&copy;"
#define kRegTM              @"&reg;"
#define kTrade              @"&trade;"

NSString* replaceSpecialString(NSString* inStr)
{
	NSString *retStr = @"";
	
	if (![inStr isEqualToString:@""])
	{
		retStr = [inStr stringByReplacingOccurrencesOfString:kNbsp withString:@" "];
		retStr = [retStr stringByReplacingOccurrencesOfString:kLt withString:@"<"];
		retStr = [retStr stringByReplacingOccurrencesOfString:kGt withString:@">"];
		retStr = [retStr stringByReplacingOccurrencesOfString:kAmp withString:@"&"];
		retStr = [retStr stringByReplacingOccurrencesOfString:kQuot	withString:@"\""];
		retStr = [retStr stringByReplacingOccurrencesOfString:kApos	withString:@"\'"];
		retStr = [retStr stringByReplacingOccurrencesOfString:kCent	withString:@"¢"];
		retStr = [retStr stringByReplacingOccurrencesOfString:kPound	withString:@"£"];
		retStr = [retStr stringByReplacingOccurrencesOfString:kYen	withString:@"¥"];
		retStr = [retStr stringByReplacingOccurrencesOfString:kEuro	withString:@"€"];
		retStr = [retStr stringByReplacingOccurrencesOfString:kSec	withString:@"§"];
		retStr = [retStr stringByReplacingOccurrencesOfString:kCopyR	withString:@"©"];
		retStr = [retStr stringByReplacingOccurrencesOfString:kRegTM	withString:@"®"];
		retStr = [retStr stringByReplacingOccurrencesOfString:kTrade	withString:@"™"];
        
		retStr = [retStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
		retStr = [retStr stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
		retStr = [retStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
		retStr = [retStr stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
		retStr = [retStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		NSRange	startRange;
		NSString* subStr;
		NSString* tmpStr = retStr;
		startRange = [tmpStr rangeOfString:@"&#"];
		while (startRange.length != 0) 
		{
			tmpStr = [tmpStr substringFromIndex:startRange.location + startRange.length];
			if ([tmpStr characterAtIndex:3] == ';')
			{
				subStr = [tmpStr substringWithRange:NSMakeRange(0, 3)];
				retStr = [retStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"&#%@;", subStr] withString:[NSString stringWithFormat:@"%C", [subStr intValue]]];
			}
			startRange = [tmpStr rangeOfString:@"&#"];
		}
	}
	
	return retStr;
}
