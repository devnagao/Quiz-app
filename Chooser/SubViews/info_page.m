//
//  info_page.m
//  howaussie
//
//  Created by Pavan Patel on 01/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "info_page.h"


@implementation info_page

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/
-(IBAction)back_Clicked:(id)sender
{
	[self.view removeFromSuperview];
}

-(IBAction)button1_Clicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/fail-blog/id582566932?ls=1&mt=8"] options:[[NSDictionary alloc] init] completionHandler:nil];
	
}
-(IBAction)button2_Clicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"www.ouridentity.org.au/"] options:[[NSDictionary alloc] init] completionHandler:nil];

}
-(IBAction)button3_Clicked:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.qualityappdesign.com"] options:[[NSDictionary alloc] init] completionHandler:nil];
	
	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
