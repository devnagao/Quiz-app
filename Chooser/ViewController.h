//
//  ViewController.h
//  Chooser
//
//  Created by Dev on 8/17/17.
//  Copyright © 2017 Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;
@class GADBannerView;

@interface ViewController : UIViewController
{
    IBOutlet	UILabel		*theQuestion;
    IBOutlet	UILabel		*theScore;
    IBOutlet	UILabel		*theLives;
    IBOutlet	UIButton	*answerOne;
    IBOutlet	UIButton	*answerTwo;
    IBOutlet	UIButton	*answerThree;
    IBOutlet	UIButton	*answerFour;
    
    NSInteger time;
    NSTimer *timer;
    BOOL questionLive;
    AppDelegate *app;
    IBOutlet UIButton *fb;
    
    BOOL shouldRestart;
    NSInteger questionNumber;
    NSMutableArray *visitedQuestions;
    NSMutableArray *questionsArray;
    NSMutableDictionary *scoreDict;
    NSString *currentQuizName;
    int index;
    UIImageView *beerImage;
}

@property(nonatomic, weak) IBOutlet GADBannerView *bannerView;

@property (retain, nonatomic) UILabel	*theQuestion;
@property (retain, nonatomic) UILabel	*theScore;
@property (retain, nonatomic) UILabel	*theLives;
@property (retain, nonatomic) UIButton	*answerOne;
@property (retain, nonatomic) UIButton	*answerTwo;
@property (retain, nonatomic) UIButton	*answerThree;
@property (retain, nonatomic) UIButton	*answerFour;
@property (retain, nonatomic) NSTimer *timer;

-(IBAction)buttonOne;
-(IBAction)buttonTwo;
-(IBAction)buttonThree;
-(IBAction)buttonFour;
-(IBAction)faceBookClicked:(id)sender;
-(void)checkAnswer:(int)theAnswerValue;

-(void)askQuestion;

-(void)updateScore;

-(void)countDown;
-(IBAction)info_Clicked:(id)sender;

- (void)restartGame;

-(int)select_random_question;
- (void)parseQuizWithName:(NSString*)name;


@end

