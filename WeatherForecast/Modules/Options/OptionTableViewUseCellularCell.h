//
//  OptionTableViewUseCellularCell.h
//  WeatherForecast
//
//  Created by Tran Thi Yen Linh on 9/4/25.
//

#import <UIKit/UIKit.h>

@interface OptionTableViewUseCellularCell : UITableViewCell {}

@property (nonatomic, retain) IBOutlet UILabel*   lblTitle;
@property (nonatomic, retain) IBOutlet UISwitch*   switchOption;

@property (nonatomic, copy) void (^onSwitchChange)(BOOL isSwitchOn);

- (IBAction) onSwitchChange: (id) sender;

@end
