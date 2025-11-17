//
//  OptionViewController.m
//  WeatherForecast
//
//  Created by Trần Thị Yến Linh on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OptionViewController.h"
#import "OptionViewInteractor.h"

@implementation OptionViewController {
  OptionViewInteractor* interactor;
}
@synthesize lbAppName;
@synthesize lbVersion;
@synthesize tableOption;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    interactor = [[OptionViewInteractor alloc] init];
  }

  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  lbAppName.text = [interactor getAppName];
  lbVersion.text = [interactor getAppVersion];

  [tableOption registerNib:[UINib nibWithNibName:@"OptionTableViewUseCellularCell" bundle:nil] forCellReuseIdentifier:CellularCellIdentifier];

  
}

- (void)dealloc {
  self.lbVersion = nil;
  interactor = nil;
  [super dealloc];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [interactor numberOfSessions];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [interactor numberOfRow:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  return [interactor cellForRowAtIndexPath:indexPath ofTable:tableView];
}

@end

