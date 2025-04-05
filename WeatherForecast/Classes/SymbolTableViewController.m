//
//  SymbolTableViewController.m
//  WeatherForecast
//
//  Created by Trần Thị Yến Linh on 8/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SymbolTableViewController.h"


@implementation SymbolTableViewController


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad 
{
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.title = @"Biểu tượng thời tiết";
}


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
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
    return 17;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section    // fixed font style. use custom view (UILabel) if you want something different
//{
//	return @"Biểu tượng thời tiết";
//}
//
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SymbolCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.imageView.contentMode = UIViewContentModeCenter;
		cell.textLabel.font = [UIFont fontWithName:@"American Typewriter" size:14];
    }
    
    // Configure the cell...
	int row = indexPath.row;
	
	switch (row) 
	{
		case 0:
			cell.imageView.image = [UIImage imageNamed:@"260.gif"];
			cell.textLabel.text = @"Nhiều mây, không mưa";
			break;
			
		case 1:
			cell.imageView.image = [UIImage imageNamed:@"110.gif"];
			cell.textLabel.text = @"Có mưa vừa, mưa to";
			break;
			
		case 2:
			cell.imageView.image = [UIImage imageNamed:@"40.gif"];
			cell.textLabel.text = @"Có mưa rào và dông";
			break;
			
		case 3:
			cell.imageView.image = [UIImage imageNamed:@"110.gif"];
			cell.textLabel.text = @"Có mưa";
			break;
			
		case 4:
			cell.imageView.image = [UIImage imageNamed:@"90.gif"];
			cell.textLabel.text = @"Mưa rào nhẹ";
			break;
			
		case 5:
			cell.imageView.image = [UIImage imageNamed:@"340.gif"];
			cell.textLabel.text = @"Ít mây, trời nắng";
			break;
			
		case 6:
			cell.imageView.image = [UIImage imageNamed:@"300.gif"];
			cell.textLabel.text = @"Mây thay đổi, trời nắng";
			break;
			
		case 7:
			cell.imageView.image = [UIImage imageNamed:@"390.gif"];
			cell.textLabel.text = @"Có lúc có mưa";
			break;
			
		case 8:
			cell.imageView.image = [UIImage imageNamed:@"110.gif"];
			cell.textLabel.text = @"Có mưa rào";
			break;
			
		case 9:
			cell.imageView.image = [UIImage imageNamed:@"6_lge.gif"];
			cell.textLabel.text = @"Có sương mù";
			break;
			
		case 10:
			cell.imageView.image = [UIImage imageNamed:@"90.gif"];
			cell.textLabel.text = @"Có mưa phùn";
			break;
			
		case 11:
			cell.imageView.image = [UIImage imageNamed:@"315.gif"];
			cell.textLabel.text = @"Trời rét";
			break;
			
		case 12:
			cell.imageView.image = [UIImage imageNamed:@"320.gif"];
			cell.textLabel.text = @"Trời nắng";
			break;
			
		case 13:
			cell.imageView.image = [UIImage imageNamed:@"310.gif"];
			cell.textLabel.text = @"Đêm không mưa";
			break;
			
		case 14:
			cell.imageView.image = [UIImage imageNamed:@"330.gif"];
			cell.textLabel.text = @"Đêm có mây";
			break;
			
		case 15:
			cell.imageView.image = [UIImage imageNamed:@"270.gif"];
			cell.textLabel.text = @"Đêm nhiều mây";
			break;
			
		case 16:
			cell.imageView.image = [UIImage imageNamed:@"450.gif"];
			cell.textLabel.text = @"Đêm có mưa rào";
			break;
			
		default:
			break;
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
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
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


@end

