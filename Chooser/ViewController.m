//
//  ViewController.m
//  Chooser
//
//  Created by Dev on 8/17/17.
//  Copyright © 2017 Dev. All rights reserved.
//

#import "ViewController.h"
#import "info_page.h"
#import "faceBookPage.h"
#import "AppDelegate.h"

@import GoogleMobileAds;

static NSString *const kQuizQuestionKey             = @"kQuizQuestionKey";
static NSString *const kQuizAnswersKey              = @"kQuizAnswersKey";
static NSString *const kQuizCorrectAnswerIndexKey   = @"kQuizCorrectAnswerIndexKey";
static NSString *const kQuizAnswerTextKey           = @"kQuizAnswerTextKey";
static NSString *const kQuizAnswerResultKey         = @"kQuizAnswerResultKey";

@interface ViewController ()

@end

@implementation ViewController

@synthesize theQuestion;
@synthesize theScore;
@synthesize theLives;
@synthesize answerOne;
@synthesize answerTwo;
@synthesize answerThree;
@synthesize answerFour;
@synthesize timer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Replace this ad unit ID with your own ad unit ID.
    self.bannerView.adUnitID = @"ca-app-pub-6593771122972764~2627111420";
    self.bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    [self.bannerView loadRequest:request];
    
    
    visitedQuestions = [[NSMutableArray alloc] init];
    questionsArray = [[NSMutableArray alloc] init];
    scoreDict = [[NSMutableDictionary alloc] initWithCapacity:4];
    shouldRestart = YES;
    
    if ( shouldRestart ) {
        [self restartGame];
    }
    beerImage=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-250, answerOne.frame.origin.y, 200, self.view.frame.size.height-answerOne.frame.origin.y)];
    beerImage.hidden=YES;
    [self.view addSubview:beerImage];
    index=-1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)askQuestion {
    // Unhide all the answer buttons.
    [answerOne setHidden:NO];
    [answerTwo setHidden:NO];
    [answerThree setHidden:NO];
    [answerFour setHidden:NO];
    
    // Set the game to a "live" question (for timer purposes)
    questionLive = YES;
    // Set the time for the timer
    time = 30.0;
    
    questionNumber = index;
    //NSLog(@"Index Number: %i", (int)questionNumber);
    
    NSDictionary *questionDict = questionsArray.count > 0 ? [questionsArray objectAtIndex:questionNumber] : [[NSDictionary alloc] init];
   // NSLog(@"Question dic: %@ at index: %d", questionDict, (int)questionNumber);
    NSArray *answers = [questionDict valueForKey:kQuizAnswersKey];
    if (answers.count>0)
    {
        NSString *number=[NSString stringWithFormat:@"%d", index];
        NSDictionary *dic=[[NSDictionary alloc]initWithObjects:@[number] forKeys:@[@"num"]];
        [visitedQuestions addObject:dic];
        NSLog(@"Answer Count: %d", (int)[answers count]);
        // Set the question string, and set the buttons the the answers
        NSString *activeQuestion = [NSString stringWithFormat:@"Question: %@", [questionDict valueForKey:kQuizQuestionKey]];
        [answerOne setTitle:[[answers objectAtIndex:0] valueForKey:kQuizAnswerTextKey] forState:UIControlStateNormal];
        [answerTwo setTitle:[[answers objectAtIndex:1] valueForKey:kQuizAnswerTextKey] forState:UIControlStateNormal];
        [answerThree setTitle:[[answers objectAtIndex:2] valueForKey:kQuizAnswerTextKey] forState:UIControlStateNormal];
        [answerFour setTitle:[[answers objectAtIndex:3] valueForKey:kQuizAnswerTextKey] forState:UIControlStateNormal];
        // Set theQuestion label to the active question
        theQuestion.text = activeQuestion;
        
        // Start the timer for the countdown
        [timer invalidate];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        
    }
    else
    {
        
        NSLog(@"<<<<<<<<<<<<<<<<<<<<<Else>>>>>>>>>>>>>>>>>>>>>>>");
        if (index==[questionsArray count])
        {
            index++;
            [self updateScore];
        }
        else
        {
            index++;
            [self askQuestion];
        }
        
    }
    
    
    
}

-(int)select_random_question
{
    BOOL isExist=NO;
    NSUInteger r = arc4random_uniform((int)[questionsArray count]);
    for (NSDictionary *dic in visitedQuestions)
    {
        int val=[[dic objectForKey:@"num"] intValue];
        if (val==r)
        {
            isExist=YES;
            break;
        }
    }
    
    if (isExist==NO)
    {
        NSString *number=[NSString stringWithFormat:@"%d", (int)r];
        NSDictionary *dic=[[NSDictionary alloc]initWithObjects:@[number] forKeys:@[@"num"]];
        [visitedQuestions addObject:dic];
    }
    else
    {
        
    }
    
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:questionsArray];
    [tmpArr removeObjectsInArray:visitedQuestions];
    
    NSDictionary *randomQuestion = [tmpArr objectAtIndex:arc4random() % [tmpArr count]];
    NSLog(@"Random Number: %@", randomQuestion);
    return [questionsArray indexOfObject:randomQuestion];
    
}

-(IBAction)info_Clicked:(id)sender
{
    info_page *inf = [[info_page alloc] initWithNibName:@"info_page" bundle:nil];
    
    inf.view.frame = self.view.frame;
    [self addChildViewController:inf];
    [self.view addSubview:inf.view];
}

-(void)updateScore
{
    index=index+1;
    // If the score is being updated, the question is not live
    questionLive = NO;
    [timer invalidate];
    timer = nil;
    
    // Hide the answers from the previous question
    [answerOne setHidden:YES];
    [answerTwo setHidden:YES];
    [answerThree setHidden:YES];
    [answerFour setHidden:YES];
    
    // END THE GAME.
    if(index == [questionsArray count])
    {
        fb.hidden = NO;
        
        NSString *maxScoreResult = @"N/A";
        NSUInteger maxScore = 0;
        for (NSString *scoreResultText in [scoreDict allKeys]) {
            NSUInteger scoreResultValue = [[scoreDict valueForKey:scoreResultText] unsignedIntegerValue];
            if ( scoreResultValue > maxScore ) {
                maxScore = scoreResultValue;
                maxScoreResult = scoreResultText;
            }
        }
        
        [answerOne setHidden:NO];
        [answerTwo setHidden:NO];
        [answerOne setTitle:@"Restart!" forState:UIControlStateNormal];
        [answerTwo setTitle:@"Share It!" forState:UIControlStateNormal];
        shouldRestart = YES;
        beerImage.hidden=NO;
        app.score = maxScoreResult;
        NSLog(@"Beer is: %@", app.score);
        if ([app.score isEqualToString:@"Budweiser"])
        {
            [beerImage setImage:[UIImage imageNamed:@"Budweiser.png"]];
        }
        else if ([app.score isEqualToString:@"Coors Light"])
        {
            [beerImage setImage:[UIImage imageNamed:@"Coors Light.png"]];
        }
        else if ([app.score isEqualToString:@"Corona"])
        {
            [beerImage setImage:[UIImage imageNamed:@"Corona.png"]];
        }
        else if ([app.score isEqualToString:@"Heineken"])
        {
            [beerImage setImage:[UIImage imageNamed:@"Heineken.png"]];
        }
        else if ([app.score isEqualToString:@"Miller Genuine Draft"])
        {
            [beerImage setImage:[UIImage imageNamed:@"miller genuine draft.png"]];
        }
        else if ([app.score isEqualToString:@"Pabst Blue Ribbon"])
        {
            [beerImage setImage:[UIImage imageNamed:@"pabst blue ribbon.png"]];
        }
        beerImage.contentMode=UIViewContentModeScaleAspectFit;
        NSString *finishingStatement = [[NSString alloc] initWithFormat:@"The results are in! You are %@", maxScoreResult];
        theQuestion.text = finishingStatement;
        theLives.text = @"";
        index=-1;
    } else {
        
        [timer invalidate];
        timer = nil;
        theLives.text = @"";
        
        [self askQuestion];
        
        /*
         // Give a short rest between questions
         time = 2.0;
         
         // Initialize the timer
         timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
         [timer retain];
         */
    }
}

-(IBAction)faceBookClicked:(id)sender;
{
    faceBookPage *fp = [[faceBookPage alloc] initWithNibName:@"faceBookPage" bundle:nil];
    [self.view addSubview:fp.view];
}

-(void)countDown
{
    
    if(questionLive==YES)
    {
        time = time - 1;
        theLives.text = [NSString stringWithFormat:@"Time remaining: %i!", (int)time];
        
        if(time == 0)
        {
            // Loser!
            questionLive = NO;
            theQuestion.text = @"Sorry, you ran out of time!";
            [timer invalidate];
            timer = nil;
            [self updateScore];
        }
    }
    // In-between Question counter
    else
    {
        time = time - 1;
        theLives.text = [NSString stringWithFormat:@"Next question in...%i!", (int)time];
        
        if(time == 0)
        {
            [timer invalidate];
            timer = nil;
            theLives.text = @"";
            [self askQuestion];
        }
    }
    if(time < 0)
    {
        NSLog(@"Out of time ");
        [timer invalidate];
        timer = nil;
    }
}


- (IBAction)buttonOne
{
    if ( shouldRestart ) {
        [self restartGame];
        return;
    }
    
    if(questionNumber == NSNotFound){
        // This means that we are at the startup-state
        // We need to make the other buttons visible, and start the game.
        currentQuizName = @"quiz1";
        [self parseQuizWithName:currentQuizName];
        [answerTwo setHidden:NO];
        [answerThree setHidden:NO];
        [answerFour setHidden:NO];
        index=0;
        [self askQuestion];
    }
    
    else
    {
        NSInteger theAnswerValue = 0;
        [self checkAnswer:(int)theAnswerValue];
    }
}

-(void)shareIt
{
    NSString *text = [NSString stringWithFormat:@"I'm a %@ - Using What Beer Are You? for iPhone/iPad: http://bit.ly/whatbeerareyou", app.score];
    
    NSArray *itemstoShare=[[NSArray alloc]initWithObjects:text, nil];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:itemstoShare applicationActivities:nil];
    controller.excludedActivityTypes = [[NSArray alloc] initWithObjects:
                                        UIActivityTypeCopyToPasteboard,
                                        UIActivityTypePostToWeibo,
                                        UIActivityTypeSaveToCameraRoll,
                                        UIActivityTypeCopyToPasteboard,
                                        UIActivityTypeAssignToContact,
                                        nil];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)buttonTwo
{
    if ( shouldRestart ) {
        [self shareIt];
        return;
    }
    if(questionNumber == NSNotFound){
        // This means that we are at the startup-state
        // We need to make the other buttons visible, and start the game.
        
        currentQuizName = @"quiz2";
        [self parseQuizWithName:currentQuizName];
        [answerTwo setHidden:NO];
        [answerThree setHidden:NO];
        [answerFour setHidden:NO];
        index=0;
        [self askQuestion];
        return;
    }
    
    else
    {
        NSInteger theAnswerValue = 1;
        [self checkAnswer:(int)theAnswerValue];
    }
}

- (IBAction)buttonThree
{
    NSInteger theAnswerValue = 2;
    [self checkAnswer:(int)theAnswerValue];
}

- (IBAction)buttonFour
{
    NSInteger theAnswerValue = 3;
    [self checkAnswer:(int)theAnswerValue];
}

// Check for the answer (this is not written right, but it runs)
-(void)checkAnswer:(int)theAnswerValue
{
    NSString *questionResult = [[[[questionsArray objectAtIndex:questionNumber] valueForKey:kQuizAnswersKey] objectAtIndex:theAnswerValue] valueForKey:kQuizAnswerResultKey];
    NSUInteger currentScore = [[scoreDict valueForKey:questionResult] unsignedIntegerValue];
    [scoreDict setValue:[NSNumber numberWithUnsignedInteger:++currentScore] forKey:questionResult];
    theQuestion.text = questionResult;
    [self updateScore];
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.


- (void)parseQuizWithName:(NSString*)name {
    [questionsArray removeAllObjects];
    
    NSString *textFilePath = [[NSBundle mainBundle] pathForResource:name ofType:@"txt"];
    NSString *fileContents = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *rawArray = [[NSArray alloc] initWithArray:[fileContents componentsSeparatedByString:@"\n"]];
    NSMutableDictionary *questionDict = nil;
    for (NSString *line in rawArray) {
        if ( questionDict == nil ) {
            questionDict = [NSMutableDictionary dictionary];
            [questionDict setValue:[NSMutableArray array] forKey:kQuizAnswersKey];
        }
        
        if ( [line length] == 0 ) {
            if ( ![questionsArray containsObject:questionDict] ) {
                [questionsArray addObject:questionDict];
                questionDict = nil;
            }
        } else {
            if ( [questionDict valueForKey:kQuizQuestionKey] == nil ) {
                [questionDict setValue:line forKey:kQuizQuestionKey];
            } else {
                NSString *answer = [[line componentsSeparatedByString:@"\t"] objectAtIndex:0];
                NSString *answerResult = [[line componentsSeparatedByString:@"-"] lastObject];
                NSMutableDictionary *answerDict = [NSMutableDictionary dictionaryWithCapacity:2];
                [answerDict setValue:answer forKey:kQuizAnswerTextKey];
                [answerDict setValue:answerResult forKey:kQuizAnswerResultKey];
                [[questionDict valueForKey:kQuizAnswersKey] addObject:answerDict];
            }
        }
    }
    
    if ( questionDict != nil ) {
        [questionsArray addObject:questionDict];
    }
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:questionsArray];
    NSUInteger count = [mutableArray count];
    // See http://en.wikipedia.org/wiki/Fisher–Yates_shuffle
    if (count > 1) {
        for (NSUInteger i = count - 1; i > 0; --i) {
            [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform((int32_t)(i + 1))];
        }
    }
    
    questionsArray = [[NSArray arrayWithArray:mutableArray] mutableCopy];
    for (int i=0; i<questionsArray.count; i++)
    {
        NSLog(@"-----------------%d-----------------\n %@",i, [questionsArray objectAtIndex:i]);
    }
    // NSLog(@"Arr = [%@]", questionsArray);
    NSLog(@"Total Questions: %d", (int)questionsArray.count);
    
}

-(IBAction)info_page_load{
    info_page *pg = [[info_page alloc]initWithNibName:@"info_page" bundle:nil];
    [self.navigationController pushViewController:pg animated:YES];
    
}

#pragma mark - Public

- (void)restartGame {
    
    shouldRestart = NO;
    beerImage.hidden=YES;
    fb.hidden = TRUE;
    questionLive = NO;
    theQuestion.text = @"If you were a beer, what beer would you be? Click Let's Go to find out or More for fun beer facts";
    theScore.text = @"";
    theLives.text = @"";
    questionNumber = NSNotFound;
    [answerOne setTitle:@"Let's Go!" forState:UIControlStateNormal];
    [answerTwo setTitle:@"Bonus mini 1D quiz" forState:UIControlStateNormal];
    [answerTwo setHidden:YES];
    [answerThree setHidden:YES];
    [answerFour setHidden:YES];
    app = [[UIApplication sharedApplication] delegate];
    
    [visitedQuestions removeAllObjects];
    [scoreDict removeAllObjects];
    
}

@end
