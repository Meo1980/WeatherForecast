//
//  AboutUsViewController.m
//  WeatherForecast
//
//  Created by Trần Thị Yến Linh on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AboutUsViewController.h"


@implementation AboutUsViewController
@synthesize lbVersion;

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
	
	NSString* tmpstr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	lbVersion.text = [NSString stringWithFormat:@"Phiên bản %@", tmpstr];
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


- (void)dealloc {
	self.lbVersion = nil;
    [super dealloc];
}


@end
