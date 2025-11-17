//
//  CurWeaViewController.m
//  WeatherForecast
//
//  Created by Trần Thị Yến Linh on 7/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "CurWeaViewController.h"
#import "CommonDefine.h"
#import "DetailWeaViewController.h"


@implementation CurWeaViewController
@synthesize tblWeather;
@synthesize segControl;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	tblWeather.rowHeight = 35;
	
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ThoiTietMoiXem"])
	{
		arrRecentView = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ThoiTietMoiXem"] mutableCopy];
	}
	else 
	{
		arrRecentView = [[NSMutableArray alloc] init];
	}
	controller = [[DetailWeaViewController alloc] initWithNibName:@"DetailWeaViewController" bundle:nil];
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CurViewCity"])
	{
		//DetailWeaViewController* controller = [[DetailWeaViewController alloc] initWithNibName:@"DetailWeaViewController" bundle:nil];
		controller.weatherAreaName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurViewCity"];
		[self.navigationController pushViewController:controller animated:YES];
		[controller refresh];
	}
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
//- (void) viewWillAppear:(BOOL)animated
//{
//	[super viewWillAppear:animated];
//	[tblWeather reloadData];
//}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"CurViewCity"];
}

- (void) viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[[NSUserDefaults standardUserDefaults] setObject:arrRecentView forKey:@"ThoiTietMoiXem"];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.tblWeather = nil;
	self.segControl = nil;
}


- (void)dealloc 
{
	NSLog(@"CurWeatherViewController release");
	[controller release];
	self.tblWeather = nil;
	self.segControl = nil;
	[arrRecentView release];
    [super dealloc];
}

- (IBAction) onSegmentChange: (id)sender
{
	[tblWeather reloadData];
}

#pragma mark UITableView Delegate and DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	if (segControl.selectedSegmentIndex == 1)
	{
		return 1;
	}
	
	return kWeatherAreasCount - 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int rows; 
	if (segControl.selectedSegmentIndex == 1)
	{
		rows = [arrRecentView count];
	}
	else 
	{
		switch (section) 
		{
			case 0:
				rows = kTayBacBoTownsCount;
				break;

			case 1:
				rows = kDongBacBoTownsCount;
				break;
				
			case 2:
				rows = kThanhHoaHueTownsCount;
				break;
				
			case 3:
				rows = kDaNangBinhThuanTownsCount;
				break;
				
			case 4:
				rows = kTayNguyenTownsCount;
				break;
				
			case 5:
				rows = kNamBoTownsCount;
				break;
				
			default:
				rows = 0;
				break;
		}
	}
	
	return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
	NSString* strTitle = @"";
	if (segControl.selectedSegmentIndex == 0)
	{
		if ((section >= 0) && (section < (kWeatherAreasCount - 1)))
		{
			strTitle = WeatherAreas[section];
		}
	}
	return strTitle;
}

// method to dislay index on Table view to show uncommand it
/*
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView 
{
	
	if(searching || !_bShowSectionIndexTitles)
		return nil;
	
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	[tempArray addObject:@"#"];
	[tempArray addObject:@"A"];
	[tempArray addObject:@"B"];
	[tempArray addObject:@"C"];
	[tempArray addObject:@"D"];
	[tempArray addObject:@"E"];
	[tempArray addObject:@"F"];
	[tempArray addObject:@"G"];
	[tempArray addObject:@"H"];
	[tempArray addObject:@"I"];
	[tempArray addObject:@"J"];
	[tempArray addObject:@"K"];
	[tempArray addObject:@"L"];
	[tempArray addObject:@"M"];
	[tempArray addObject:@"N"];
	[tempArray addObject:@"O"];
	[tempArray addObject:@"P"];
	[tempArray addObject:@"Q"];
	[tempArray addObject:@"R"];
	[tempArray addObject:@"S"];
	[tempArray addObject:@"T"];
	[tempArray addObject:@"U"];
	[tempArray addObject:@"V"];
	[tempArray addObject:@"W"];
	[tempArray addObject:@"X"];
	[tempArray addObject:@"Y"];
	[tempArray addObject:@"Z"];
	
	return tempArray;
}*/

/*
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	
	if(searching)
		return -1;
	
	return index;
}
*/
static NSString *CellIdentifier = @"CurWeaCell";

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	int section = indexPath.section;
	int row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.font = [UIFont boldSystemFontOfSize: 14];
		cell.textLabel.textColor = [UIColor blueColor];
		cell.imageView.image = [UIImage imageNamed:@"nangmua.gif"];
    }
	
	if (segControl.selectedSegmentIndex == 0)
	{
		switch (section) 
		{
			case 0:
				cell.textLabel.text = TayBacBoTowns[row];
				break;
				
			case 1:
				cell.textLabel.text = DongBacBoTowns[row];
				break;
				
			case 2:
				cell.textLabel.text = ThanhHoaHueTowns[row];
				break;
				
			case 3:
				cell.textLabel.text = DaNangBinhThuanTowns[row];
				break;
				
			case 4:
				cell.textLabel.text = TayNguyenTowns[row];
				break;
				
			case 5:
				cell.textLabel.text = NamBoTowns[row];
				break;
				
			default:
				break;
		}
	}
	else 
	{
		cell.textLabel.text = [arrRecentView objectAtIndex:row];
	}

	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	int section = indexPath.section;
	int row = indexPath.row;
	
//	DetailWeaViewController* controller = [[DetailWeaViewController alloc] initWithNibName:@"DetailWeaViewController" bundle:nil];
	if (segControl.selectedSegmentIndex == 0)
	{
		NSString *areaName;
		switch (section) 
		{
			case 0:
				areaName = TayBacBoTowns[row];
				break;
				
			case 1:
				areaName = DongBacBoTowns[row];
				break;
				
			case 2:
				areaName = ThanhHoaHueTowns[row];
				break;
				
			case 3:
				areaName = DaNangBinhThuanTowns[row];
				break;
				
			case 4:
				areaName = TayNguyenTowns[row];
				break;
				
			case 5:
				areaName = NamBoTowns[row];
				break;
				
			default:
				break;
		}
		controller.weatherAreaName = areaName;
		BOOL isReplace = NO;
		int i;
		for (i = 0; i < [arrRecentView count]; i++)
		{
			if ([areaName isEqualToString:[arrRecentView objectAtIndex:i]])
			{
				isReplace = YES;
				break;
			}
		}
		if (isReplace)
		{
			[arrRecentView insertObject:[arrRecentView objectAtIndex:i] atIndex:0];
			[arrRecentView removeObjectAtIndex:i+1];
			//[arrRecentView exchangeObjectAtIndex:i withObjectAtIndex:0];
		}
		else 
		{
			[arrRecentView insertObject:areaName atIndex:0];
		}
		if ([arrRecentView count] > 10)
			[arrRecentView removeLastObject];
	}
	else
	{
		controller.weatherAreaName = [arrRecentView objectAtIndex:row];
		[arrRecentView insertObject:[arrRecentView objectAtIndex:row] atIndex:0];
		[arrRecentView removeObjectAtIndex:row+1];
		//[arrRecentView exchangeObjectAtIndex:row withObjectAtIndex:0];
	}
	
	[[NSUserDefaults standardUserDefaults] setObject:controller.weatherAreaName forKey:@"CurViewCity"];
	[self.navigationController pushViewController:controller animated:YES];
	[controller refresh];
	//[controller release];
	[tblWeather reloadData];
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
