//
//  faceBookPage.h
//  SportsExchangeLive
//
//  Created by Laxman on 09/11/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class FBSession,AppDelegate;

@interface faceBookPage : UIViewController<FBDialogDelegate,FBSessionDelegate,FBRequestDelegate>
{
	IBOutlet UILabel* _label;
	IBOutlet UIButton* _permissionButton;
	IBOutlet UIButton* _feedButton;
	IBOutlet FBLoginButton* _loginButton;
	FBSession *_session;
	AppDelegate *app;
	
}
@property(nonatomic,readonly) UILabel* label;

- (void)askPermission:(id)target;
- (void)publishFeed:(id)target;

-(IBAction)back_clicked:(id)sender;

@end
