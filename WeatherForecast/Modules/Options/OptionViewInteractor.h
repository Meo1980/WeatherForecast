//
//  Header.h
//  WeatherForecast
//
//  Created by Tran Thi Yen Linh on 9/4/25.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OptionsViewOption) {
  OptionsViewOptionUseCellular,
  OptionsViewOptionSymbolExplain,
  OptionsViewOptionTotalOption,
};

static NSString* CellularCellIdentifier = @"OptionTableViewUseCellularCell";
static NSString* CellIdentifier = @"OptionTableViewCell";

@interface OptionViewInteractor: NSObject {}

- (NSString*) getAppVersion;
- (NSString*) getAppName;

- (NSInteger) numberOfSessions;
- (NSInteger) numberOfRow: (NSInteger) sessionId;
- (UITableViewCell*) cellForRowAtIndexPath: (NSIndexPath *)indexPath ofTable: (UITableView*) tableView;
- (BOOL) isUseCellular;
- (void) onChangeUseCellularSetting: (BOOL) isUseCellular;

@end
