//
//  faceBookPage.m
//  SportsExchangeLive
//
//  Created by Laxman on 09/11/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "faceBookPage.h"
#import "FBConnect.h"
#import "AppDelegate.h"
///////////////////////////////////////////////////////////////////////////////////////////////////
// This application will not work until you enter your Facebook application's API key here:

static NSString* kApiKey = @"133347826730555";

// Enter either your API secret or a callback URL (as described in documentation):
static NSString* kApiSecret = @"897da99fbddeb139759030323f5c2727"; // @"<YOUR SECRET KEY>";
static NSString* kGetSessionProxy = nil; // @"<YOUR SESSION CALLBACK)>";

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation faceBookPage
@synthesize label = _label;
BOOL feed=FALSE;

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self.title = @"Connect to Facebook";
	if (self = [super initWithNibName:@"faceBookPage" bundle:nibBundleOrNil]) {
		if (kGetSessionProxy) {
			_session = [FBSession sessionForApplication:kApiKey getSessionProxy:kGetSessionProxy
												delegate:self];
		} else {
			_session = [FBSession sessionForApplication:kApiKey secret:kApiSecret delegate:self];
		}
	}
	return self;
}


-(IBAction)back_clicked:(id)sender;
{
	[self.view removeFromSuperview];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)viewDidLoad {
	app = [[UIApplication sharedApplication] delegate];
	
	[_session resume];
	_loginButton.style = FBLoginButtonStyleWide;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError*)error {
	_label.text = [NSString stringWithFormat:@"Error(%d) %@", (int)error.code,
				   error.localizedDescription];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBSessionDelegate

- (void)session:(FBSession*)session didLogin:(FBUID)uid {
	_permissionButton.hidden = NO;
	_feedButton.hidden = NO;
	
	NSString* fql = [NSString stringWithFormat:
					 @"select uid,name from user where uid == %lld", session.uid];
	
	NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
	[[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
}

- (void)sessionDidLogout:(FBSession*)session {
	_label.text = @"";
	_permissionButton.hidden = YES;
	_feedButton.hidden = YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

- (void)request:(FBRequest*)request didLoad:(id)result {
	
	if([result isKindOfClass:[NSString class]] )
	{
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Result Published" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
	}
	else if([result isKindOfClass:[NSArray class]])
	{
		NSArray* users = result;
		NSDictionary* user = [users objectAtIndex:0];
		NSString* name = [user objectForKey:@"name"];
		_label.text = [NSString stringWithFormat:@"Logged in as %@", name];
	}
	
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
	_label.text = [NSString stringWithFormat:@"Error(%d) %@", (int)error.code,
				   error.localizedDescription];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)askPermission:(id)target {
	FBPermissionDialog* dialog = [[FBPermissionDialog alloc] init];
	dialog.delegate = self;
	dialog.permission = @"status_update";
	[dialog show];
}

- (void)publishFeed:(id)target {
	//FBFeedDialog* dialog = [[[FBFeedDialog alloc] init] autorelease];
//	dialog.delegate = self;
//	//dialog.templateBundleId = 9999999;
//	dialog.templateData = @"{\"name\":\"test name\",\"caption\":\"test caption\",\"description\":\"test description\"";
//	[dialog show];
//	
	NSMutableDictionary *params = [NSMutableDictionary dictionary];
	NSString *str = [NSString stringWithFormat:@"I should date %@ I got this from the Which One Direction Star Should You Date app for iPhone and iPod Touch. http://bit.ly/which1dstar", app.score];
	[params setObject:str forKey:@"message"];

//	NSString *action_links = @"[{\"text\":\"Aussie Quiz\"}]";
//	[params setObject:action_links forKey:@"action_links"];
	
	[[FBRequest requestWithDelegate:self] call:@"facebook.Stream.publish" params:params];
	
	
	
//	NSString *message = @"Sports Exchange Live"; 
//	NSString *attachment = @"{\"name\":\"test name\",\"caption\":\"test caption\",\"description\":\"test description\"";
//	attachment = [attachment stringByAppendingFormat:@"\"user_lat\":\"%f\",", 1.03];
//	attachment = [attachment stringByAppendingFormat:@"\"user_lng\":\"%f\",", 103.10];
//	attachment = [attachment stringByAppendingString:@"}"];
//	

	
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.


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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}




@end
