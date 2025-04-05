//
//  OptionViewController.m
//  WeatherForecast
//
//  Created by Trần Thị Yến Linh on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OptionViewController.h"
#import "WeatherForecastAppDelegate.h"
#import "SymbolTableViewController.h"
#import "AboutUsViewController.h"

@implementation OptionViewController


#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
	if (section == 1)
		return 2;
	
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section    // fixed font style. use custom view (UILabel) if you want something different
{
	NSString *title = @"";
	if (section == 0)
		title = @"Thiết đặt";
	
	return title;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"OptionCell";
	NSInteger section = indexPath.section;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:13];
		cell.textLabel.textColor = [UIColor blueColor];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		if (section == 0)
		{
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
			UISwitch* switchGPRS = [[UISwitch alloc] initWithFrame:CGRectMake(cell.bounds.size.width - 124, 8, 94, 27)];
			[switchGPRS addTarget:self action:@selector(onSwitchGPRS:) forControlEvents:UIControlEventValueChanged];
			WeatherForecastAppDelegate* delegate = (WeatherForecastAppDelegate*)[UIApplication sharedApplication].delegate;
			switchGPRS.on = delegate.isUsingGPRS;
			[cell.contentView addSubview:switchGPRS];
		}
    }
    
    // Configure the cell...
	if (section == 0)
	{
		cell.textLabel.text = @"Không có Wifi, dùng 3G/GPRS";
	}
	else 
	{
		if (indexPath.row == 0)
		{
			cell.textLabel.text = @"Giải thích các biểu tượng thời tiết";
		}
		else 
		{
			cell.textLabel.text = @"Thông tin liên hệ";
		}
	}
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	NSInteger section = indexPath.section;
	
	if (section == 1)
	{
		if (indexPath.row == 0)
		{
		SymbolTableViewController* controller = [[SymbolTableViewController alloc] initWithNibName:@"SymbolTableViewController" bundle:nil];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
		}
		else 
		{
			AboutUsViewController* controller = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
		}
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	else 
	{
		[tableView deselectRowAtIndexPath:indexPath animated:NO];
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void) onSwitchGPRS: (id) sender
{
	WeatherForecastAppDelegate* delegate = (WeatherForecastAppDelegate*)[UIApplication sharedApplication].delegate;
	delegate.isUsingGPRS = !delegate.isUsingGPRS;
}


@end

