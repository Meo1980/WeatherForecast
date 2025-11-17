//
//  UITableViewCell+OptionTableViewUseCellularCell.m
//  DuBaoThoiTiet
//
//  Created by Tran Thi Yen Linh on 9/4/25.
//

#import "OptionTableViewUseCellularCell.h"

@implementation OptionTableViewUseCellularCell
@synthesize lblTitle;
@synthesize switchOption;
@synthesize onSwitchChange;

- (IBAction) onSwitchChange: (id) sender {
  self.onSwitchChange(switchOption.isOn);
}

@end
