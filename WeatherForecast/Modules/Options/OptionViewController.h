//
//  OptionViewController.h
//  WeatherForecast
//
//  Created by Trần Thị Yến Linh on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OptionViewController : UIViewController {}

@property (nonatomic, retain) IBOutlet UILabel*   lbAppName;
@property (nonatomic, retain) IBOutlet UILabel*   lbVersion;
@property (nonatomic, retain) IBOutlet UITableView*   tableOption;

@end
