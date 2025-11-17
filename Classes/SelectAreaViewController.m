//
//  SelectAreaViewController.m
//  WeatherForecast
//
//  Created by Trần Thị Yến Linh on 8/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SelectAreaViewController.h"
#import "CommonDefine.h"


@implementation SelectAreaViewController
@synthesize vwAreaPicking;
@synthesize tvwFavourite;
@synthesize pvwArea;
@synthesize arrFavourite;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	UIBarButtonItem* refreshBut = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onShowAddArea:)];
	self.navigationItem.rightBarButtonItem = refreshBut;
	[refreshBut release];
	
	refreshBut = [[UIBarButtonItem alloc] initWithTitle:@"Xem Thời Tiết" style:UIBarButtonItemStyleDone target:self action:@selector(onDone:)];
	self.navigationItem.leftBarButtonItem = refreshBut;
	[refreshBut release];
	
	self.navigationItem.title = @"Tỉnh\\Thành";	
	
	[self.view addSubview:vwAreaPicking];
	vwAreaPicking.center = CGPointMake(160, 500);
	
	[tvwFavourite setEditing:YES];
}

- (void) viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[[NSUserDefaults standardUserDefaults] setObject:arrFavourite forKey:@"FavouriteCities"];
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	self.vwAreaPicking = nil;
	self.tvwFavourite = nil;
	self.pvwArea = nil;
	self.arrFavourite = nil;
    [super dealloc];
}

- (void) onDone:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) onShowAddArea: (id) sender
{
	self.navigationItem.rightBarButtonItem.enabled = NO;

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	vwAreaPicking.center = CGPointMake(vwAreaPicking.center.x, vwAreaPicking.center.y - 260);
	[UIView commitAnimations];
}

//- (IBAction) onDoneSelectArea: (id)sender
//{
//	[UIView beginAnimations:@"SelectAreaDone" context:nil];
//	[UIView setAnimationDelegate:self];
//	[UIView setAnimationDuration:0.5];
//	vwAreaPicking.center = CGPointMake(vwAreaPicking.center.x, vwAreaPicking.center.y + 260);
//	[UIView commitAnimations];
//}

- (IBAction) onAddArea: (id)sender
{
	NSString	*newArea = @"";
	NSInteger firstRow = [pvwArea selectedRowInComponent:0];
	NSInteger secondRow = [pvwArea selectedRowInComponent:1];
	switch (firstRow) 
	{
		case 0:
			newArea = TayBacBoTowns[secondRow];
			break;
			
		case 1:
			newArea = DongBacBoTowns[secondRow];
			break;
			
		case 2:
			newArea = ThanhHoaHueTowns[secondRow];
			break;
			
		case 3:
			newArea = DaNangBinhThuanTowns[secondRow];
			break;
			
		case 4:
			newArea = TayNguyenTowns[secondRow];
			break;
			
		case 5:
			newArea = NamBoTowns[secondRow];
			break;
			
		default:
			break;
	}

	BOOL canAdd = YES;
	for (NSString *tmpStr in arrFavourite)
		if ([newArea isEqualToString:tmpStr])
		{
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" 
															message:@"Tỉnh\\Thành này đã có trong danh sách." 
														   delegate:nil 
												  cancelButtonTitle:nil otherButtonTitles:@"Đóng", nil];
			[alert show];
			[alert release];
			canAdd = NO;
			break;
		}
	if (canAdd)
	{
		//[tvwFavourite insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[arrFavourite count] inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
		[arrFavourite addObject:newArea];
		[tvwFavourite reloadData];
		NSNotification* notification = [NSNotification notificationWithName:@"NewAreaAdd" object:newArea];
		[[NSNotificationCenter defaultCenter] postNotification:notification];
		
		[UIView beginAnimations:@"SelectAreaDone" context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.5];
		vwAreaPicking.center = CGPointMake(vwAreaPicking.center.x, vwAreaPicking.center.y + 260);
		[UIView commitAnimations];
	}
}

- (void) animationDidStop:(NSString *)animationID
{
	if ([animationID isEqualToString:@"SelectAreaDone"])
	{
		self.navigationItem.rightBarButtonItem.enabled = YES;
	}
}

#pragma mark UIPickerViewDataSource & Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	NSInteger rows = 0;
	if (component == 0)
	{
		rows = kWeatherAreasCount - 1;
	}
	else if (component == 1)
	{
		NSInteger selectedRow = [pvwArea selectedRowInComponent:0];
		switch (selectedRow) 
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
				break;
		}
	}
	
	return rows;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString* retTitle = @"";
	if (component == 0)
	{
		retTitle = WeatherAreas[row];
	}
	else if (component == 1)
	{
		NSInteger selectedRow = [pvwArea selectedRowInComponent:0];
		switch (selectedRow) 
		{
			case 0:
				retTitle = TayBacBoTowns[row];
				break;
				
			case 1:
				retTitle = DongBacBoTowns[row];
				break;
				
			case 2:
				retTitle = ThanhHoaHueTowns[row];
				break;
				
			case 3:
				retTitle = DaNangBinhThuanTowns[row];
				break;
				
			case 4:
				retTitle = TayNguyenTowns[row];
				break;
				
			case 5:
				retTitle = NamBoTowns[row];
				break;
				
			default:
				break;
		}
	}
	
	return retTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (component == 0)
	{
		[pvwArea reloadComponent:1];
		[pvwArea selectRow:0 inComponent:1 animated:NO];
	}
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	CGFloat width = 140.0;
	if (component == 0)
	{
		width = 180.0;
	}
	
	return width;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
	UILabel* label = nil;
	if(view)
	{
		label = (UILabel*)view;
	}
	else
	{
		if (component == 0)
		{
			label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
		}
		else 
		{
			label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 30)];
		}
	}
	label.backgroundColor = [UIColor clearColor];	
	
	label.numberOfLines = 0;
	label.font = [UIFont boldSystemFontOfSize: 13];
	
	NSString* title = nil;
	if (component == 0)
	{
		title = WeatherAreas[row];
	}
	else if (component == 1)
	{
		NSInteger selectedRow = [pvwArea selectedRowInComponent:0];
		switch (selectedRow) 
		{
			case 0:
				title = TayBacBoTowns[row];
				break;
				
			case 1:
				title = DongBacBoTowns[row];
				break;
				
			case 2:
				title = ThanhHoaHueTowns[row];
				break;
				
			case 3:
				title = DaNangBinhThuanTowns[row];
				break;
				
			case 4:
				title = TayNguyenTowns[row];
				break;
				
			case 5:
				title = NamBoTowns[row];
				break;
				
			default:
				break;
		}
	}
	label.text = [NSString stringWithFormat:@"  %@", title];
	
	return label;
}

#pragma mark UITableView Delegate and DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{	
	
	return [arrFavourite count];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
//{
//	NSString* strTitle = @"";
//	if (segControl.selectedSegmentIndex == 0)
//	{
//		if ((section >= 0) && (section < (kWeatherAreasCount - 1)))
//		{
//			strTitle = WeatherAreas[section];
//		}
//	}
//	return strTitle;
//}

static NSString *CellIdentifier = @"CurWeaCell";

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	int row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:13];
    }
	
	cell.textLabel.text = [arrFavourite objectAtIndex:row];
		
    return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//	[tvwFavourite beginUpdates];
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		[arrFavourite removeObjectAtIndex:indexPath.row];
		[tvwFavourite reloadData];
		NSNotification* notification = [NSNotification notificationWithName:@"AreaDelete" object:[NSNumber numberWithInt:indexPath.row]];
		[[NSNotificationCenter defaultCenter] postNotification:notification];
//		[tvwFavourite deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSNumber numberWithInt: indexPath.row], nil] withRowAnimation:UITableViewRowAnimationFade];
	}
//	[tvwFavourite endUpdates];
}


@end
