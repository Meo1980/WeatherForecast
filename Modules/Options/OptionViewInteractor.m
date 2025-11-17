//
//  OptionViewInteractor.m
//  DuBaoThoiTiet
//
//  Created by Tran Thi Yen Linh on 9/4/25.
//

//#import <Foundation/Foundation.h>
#import "OptionViewInteractor.h"
#import "OptionTableViewUseCellularCell.h"

@implementation OptionViewInteractor
- (NSString *)getAppVersion {
  NSString* tmpstr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
  return [NSString stringWithFormat: NSLocalizedString(@"Version", @""), tmpstr];
}

- (NSString *)getAppName {
  return NSLocalizedString(@"AppName", @"");
}

- (NSInteger) numberOfSessions {
  return 1;
}

- (NSInteger) numberOfRow: (NSInteger) sessionId {
  return OptionsViewOptionTotalOption;
}

- (UITableViewCell*) cellForRowAtIndexPath: (NSIndexPath *)indexPath ofTable: (UITableView*) tableView {
  NSString* identifier = indexPath.row == OptionsViewOptionUseCellular ? CellularCellIdentifier : CellIdentifier;

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

  if (cell == nil) {
    cell = indexPath.row == OptionsViewOptionUseCellular ? [[OptionTableViewUseCellularCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] : [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  }
  
  cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
  if (indexPath.row == OptionsViewOptionUseCellular) {
    [((OptionTableViewUseCellularCell*)cell).switchOption setOn: [self isUseCellular]];
    ((OptionTableViewUseCellularCell*)cell).lblTitle.text = NSLocalizedString(@"UseCellular", @"");

    OptionViewInteractor* __weak weakSelf = self;
    ((OptionTableViewUseCellularCell*)cell).onSwitchChange = ^(BOOL isSwitchOn) {
      
      [weakSelf onChangeUseCellularSetting:isSwitchOn];
    };
  } else {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = NSLocalizedString(@"SymbolExplain", @"");
  }

  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}

- (BOOL) isUseCellular {
  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UsingGPRS"]) {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"UsingGPRS"];
  }
  return NO;
}

- (void) onChangeUseCellularSetting: (BOOL) isUseCellular {
  [[NSUserDefaults standardUserDefaults] setBool:isUseCellular forKey:@"UsingGPRS"];
}

@end
