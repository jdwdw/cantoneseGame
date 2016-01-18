//
//  testController.m
//  cantoneseGame
//
//  Created by dw on 16/1/2.
//  Copyright © 2016年 slippers. All rights reserved.
//

#import "testController.h"
#import "config.h"
#import "Level.h"
#import "GameController.h"
//#import "HUDView.h"
#import "Popup.h"
#import <AVFoundation/AVFoundation.h>

//@implementation testController
//
//-(instancetype)initWithCoder:(NSCoder *)decoder
//{
//    self = [super initWithCoder:decoder];
//    if (self != nil) {
//        //create the game controller
//        //self.controller = [[GameController alloc] init];
//        NSLog(@"+++++++++++++%d",self.index);
//        self.view.backgroundColor=[UIColor yellowColor ];
//    }
//    return self;
//}
//
//
//-(void)viewDidLoad{
//    
//    [super viewDidLoad];
//    NSLog(@"%d",self.index);
//    self.view.backgroundColor=[UIColor redColor];
//    
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame=CGRectMake(10, 10, 30, 30);
//    backButton.center=CGPointMake(100, 100);
//    backButton.backgroundColor=[UIColor blueColor];
//    //UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//    [backButton addTarget:self action:@selector(backTo:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backButton];
//    
//}
//
//
//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//   NSLog(@"----------%d",self.index);
//    //self.view.backgroundColor=[UIColor blueColor];
//}
//
//-(void)backTo:(UIButton*)sender{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    NSLog(@"back");
//}
@import GoogleMobileAds;
@interface testController () <UIActionSheetDelegate,PopupDelegate>{
    
    NSString *titleText;
    NSString *subTitleText;
    NSString *cancelText;
    NSString *successText;
    
    
    PopupBackGroundBlurType blurType;
    PopupIncomingTransitionType incomingType;
    PopupOutgoingTransitionType outgoingType;
    
    Popup *popper;
    
    
    AVAudioPlayer *player;
    
    //GADInterstitial *interstitial;
    
}
@property (strong, nonatomic) GameController* controller;
@property (strong,nonatomic) GADInterstitial *interstitial;
@end

@implementation testController

//-(instancetype)initWithCoder:(NSCoder *)decoder
//{
//    self = [super initWithCoder:decoder];
//    if (self != nil) {
//        //create the game controller
//        self.controller = [[GameController alloc] init];
//    }
//    return self;
//}

//setup the view and instantiate the game controller
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _interstitial = [[GADInterstitial alloc]initWithAdUnitID:@"ca-app-pub-7330443893787901/1391670676"];
    [_interstitial loadRequest:[GADRequest request]];
    
    titleText = @"Title";
    subTitleText = @"Subtitledhdhgfhfgjhjhgjhghjgvhjhjfgfjgfjhgjhghgjhh\n   po   \n af\n \n \n \n \n \n \n \n aasfadsf\nfadf\nadf\n";
//    cancelText = @"Cancel";
//    successText = @"Success";
    incomingType=PopupIncomingTransitionTypeGhostAppear;
    outgoingType=PopupOutgoingTransitionTypeGrowDisappear;
    
    
    self.controller = [[GameController alloc] init];
    
     self.view.backgroundColor=[UIColor whiteColor];
    
    //add one layer for all game elements
    UIView* gameLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    NSLog(@"%f",kScreenWidth);
    NSLog(@"%f",kScreenHeight);
    [self.view addSubview: gameLayer];
    
    self.controller.gameView = gameLayer;
    
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame=CGRectMake(10, 10, 30, 30);
        backButton.center=CGPointMake(100, 100);
        backButton.backgroundColor=[UIColor blueColor];
        //UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
        [backButton addTarget:self action:@selector(backTo:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backButton];
    
    
    
    //add one layer for all hud and controls
   // HUDView* hudView = [HUDView viewWithRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
   // [self.view addSubview:hudView];
    
    //self.controller.hud = hudView;
    
    __weak testController* weakSelf = self;
    self.controller.onAnagramSolved = ^(){
       // [weakSelf showLevel];
        //再加上有下一题的弹窗
        [weakSelf showPopper];
         //[interstitial presentFromRootViewController:self];
    };
    
    self.controller.wrongAnagram=^(){
        [weakSelf showWrongPopper];
        // [interstitial presentFromRootViewController:self];
        
    };
}

//show tha game menu on app start
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showLevel];
}

#pragma mark - Game manu
//show the level selector menu
//-(void)showLevelMenu
//{
//    UIActionSheet* action = [[UIActionSheet alloc] initWithTitle:@"Play @ difficulty level:"
//                                                        delegate:self
//                                               cancelButtonTitle:nil
//                                          destructiveButtonTitle:nil
//                                               otherButtonTitles:@"Easy-peasy", @"Challenge accepted" , @"I'm totally hard-core", nil];
//    [action showInView:self.view];
//}
//
////level was selected, load it up and start the game
//-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    //1 check if the user tapped outside the menu
//    if (buttonIndex==-1) {
//        [self showLevelMenu];
//        return;
//    }
//    
//    //2 map index 0 to level 1, etc...
//    int levelNum = buttonIndex+1;
//    
//    //3 load the level, fire up the game
//    self.controller.level = [Level level];
//    [self.controller dealWithNum:self.index];
//    NSLog(@"%d",levelNum);
//}

-(void)showLevel{
    self.controller.level = [Level level];
    [self.controller dealWithNum:self.index];
    
    Level *level=[Level level];
    
    NSString *answer = [NSString stringWithFormat:@"%@",[level.array[self.index] objectForKey:@"answer"]];
    NSString *explain = [NSString stringWithFormat:@"%@",[level.array[self.index] objectForKey:@"explain"]];
    
    NSString *voice = [NSString stringWithFormat:@"%@",[level.array[self.index] objectForKey:@"voice"]];
    
    titleText=answer;
    subTitleText=explain;
    [self loadVoice:voice];
    //[interstitial loadRequest:[GADRequest request]];
   // [interstitial presentFromRootViewController:self];
}
-(void)backTo:(UIButton*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"back");
}
-(void)showNextLevel{
    
    self.index+=1;
    self.controller.level = [Level level];
    [self.controller dealWithNum:self.index];
    
    Level *level=[Level level];
    
    
    NSString *answer = [NSString stringWithFormat:@"%@",[level.array[self.index] objectForKey:@"answer"]];
    NSString *explain = [NSString stringWithFormat:@"%@",[level.array[self.index] objectForKey:@"explain"]];
    NSString *voice = [NSString stringWithFormat:@"%@",[level.array[self.index] objectForKey:@"voice"]];
   
    titleText=answer;
    subTitleText=explain;
    [self loadVoice:voice];
    //[interstitial loadRequest:[GADRequest request]];
   // [interstitial presentFromRootViewController:self];
}



#pragma mark Popup Methods

- (void)showPopper {
    
   // if (numFields == 0) {
       // popper = [[Popup alloc] initWithTitle:titleText subTitle:subTitleText cancelTitle:cancelText successTitle:successText];
    popper=[[Popup alloc]initWithTitle:titleText subTitle:subTitleText haveOkButton:NO haveBackButton:YES haveVoiceButton:YES haveNextButton:YES haveRenewButton:NO];
   // popper=[[Popup alloc]initWithTitle:titleText subTitle:subTitleText haveOkButton:YES haveBackButton:NO haveVoiceButton:NO haveNextButton:NO];
//    }
//    else if (numFields == 1) {
//        popper = [[Popup alloc] initWithTitle:titleText subTitle:subTitleText textFieldPlaceholders:@[@"One Text Field"] cancelTitle:cancelText successTitle:successText cancelBlock:^{
//            NSLog(@"Cancel block 1");
//        } successBlock:^{
//            NSLog(@"Success block 1");
//        }];
//    }
//    else if (numFields == 2) {
//        popper = [[Popup alloc] initWithTitle:titleText subTitle:subTitleText textFieldPlaceholders:@[@"One Text Field", @"Two Text Fields"] cancelTitle:cancelText successTitle:successText cancelBlock:^{
//            NSLog(@"Cancel block 2");
//        } successBlock:^{
//            NSLog(@"Success block 2");
//        }];
//    }
//    else if (numFields == 3) {
//        popper = [[Popup alloc] initWithTitle:titleText subTitle:subTitleText textFieldPlaceholders:@[@"One Text Field", @"Two Text Fields", @"Three Text Fields"] cancelTitle:cancelText successTitle:successText cancelBlock:^{
//            NSLog(@"Cancel block 3");
//        } successBlock:^{
//            NSLog(@"Success block 3");
//        }];
//    }
    
//    [self figureOutSecure];
//    [self figureOutTransitions];
//    [self figureOutKeyboardType];
    
    [popper setDelegate:self];
    [popper setBackgroundBlurType:blurType];
    [popper setIncomingTransition:incomingType];
    [popper setOutgoingTransition:outgoingType];
    [popper setRoundedCorners:YES];
    [popper showPopup];
    //加广告
    if ( arc4random()%2==1) {
        [self loadAD];
    }
    
}

-(void)showWrongPopper {
    
    NSString *tile=@"挑战失败";
    NSString *subTitle=@" ";
    popper=[[Popup alloc]initWithTitle:tile subTitle:subTitle haveOkButton:NO haveBackButton:YES haveVoiceButton:NO haveNextButton:NO haveRenewButton:YES];
    [popper setDelegate:self];
    [popper setBackgroundBlurType:blurType];
    [popper setIncomingTransition:incomingType];
    [popper setOutgoingTransition:outgoingType];
    [popper setRoundedCorners:YES];
    [popper showPopup];
    
    
    //加广告
    if ( arc4random()%3==1) {
        [self loadAD];
    }
    
    
}

- (void)popupWillAppear:(Popup *)popup {
}

- (void)popupDidAppear:(Popup *)popup {
}

- (void)popupWilldisappear:(Popup *)popup buttonType:(PopupButtonType)buttonType {
}

- (void)popupDidDisappear:(Popup *)popup buttonType:(PopupButtonType)buttonType {
}

- (void)popupPressButton:(Popup *)popup buttonType:(PopupButtonType)buttonType {
    
    if (buttonType == PopupButtonCancel) {
        NSLog(@"popupPressButton - PopupButtonCancel");
    }
    else if (buttonType == PopupButtonSuccess) {
        NSLog(@"popupPressButton - PopupButtonSuccess");
    }
    else if (buttonType == PopupButtonOk) {
        NSLog(@"popupPressButton - PopupButtonOk");
      [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (buttonType == PopupButtonVoice) {
        NSLog(@"popupPressButton - PopupButtonVoice");
        [self playVoice];
    }
    else if (buttonType == PopupButtonBack) {
        NSLog(@"popupPressButton - PopupButtonBack");
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (buttonType == PopupButtonNext) {
        NSLog(@"popupPressButton - PopupButtonNext");
        if (self.index<44) {
            [self showNextLevel];
        }else{
            
           NSString* title=@"Well done";
           NSString*   subTitle=@"你已经通关了，感谢你的支持。如果喜欢这个游戏的话可以到iTunes上评论，很快会推出新的粤语解密游戏。敬请关注。";
            
        popper=[[Popup alloc]initWithTitle:title subTitle:subTitle haveOkButton:YES haveBackButton:NO haveVoiceButton:NO haveNextButton:NO haveRenewButton:NO];
            
            
            [popper setDelegate:self];
            [popper setBackgroundBlurType:blurType];
            [popper setIncomingTransition:incomingType];
            [popper setOutgoingTransition:outgoingType];
            [popper setRoundedCorners:YES];
            [popper showPopup];
            
        }
        
    }
    else if (buttonType == PopupButtonRenew) {
        NSLog(@"popupPressButton - PopupButtonRenew");
        [self showLevel];
    }
}

- (void)dictionary:(NSMutableDictionary *)dictionary forpopup:(Popup *)popup stringsFromTextFields:(NSArray *)stringArray {
    
    NSLog(@"Dictionary from textfields: %@", dictionary);
    NSLog(@"Array from textfields: %@", stringArray);
    
    //NSString *textFromBox1 = [stringArray objectAtIndex:0];
    //NSString *textFromBox2 = [stringArray objectAtIndex:1];
    //NSString *textFromBox3 = [stringArray objectAtIndex:2];
}



//加载语音

-(void)loadVoice:(NSString*)voiceName
{
    //initialize the effects array
   // audio = [NSMutableDictionary dictionaryWithCapacity: effectFileNames.count];
    
    //loop over the filenames
   // for (NSString* effect in effectFileNames) {
        
        //1 get the file path URL
        NSString* soundPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: voiceName];
        NSURL* soundURL = [NSURL fileURLWithPath: soundPath];
        
        //2 load the file contents
        NSError* loadError = nil;
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error: &loadError];
        NSAssert(loadError==nil, @"load sound failed");
        
        //3 prepare the play
        player.numberOfLoops = 0;
        [player prepareToPlay];
        
        //4 add to the array ivar
       // audio[effect] = player;
   // }
}

-(void)playVoice
{
    //NSAssert(audio[name], @"effect not found");
    
    //AVAudioPlayer* player = (AVAudioPlayer*)audio[name];
    if (player.isPlaying) {
        player.currentTime = 0;
    } else {
        [player play];
    }
}

-(void)loadAD{
    [_interstitial presentFromRootViewController:self];
    _interstitial = [[GADInterstitial alloc]initWithAdUnitID:@"ca-app-pub-7330443893787901/1391670676"];
    [_interstitial loadRequest:[GADRequest request]];
    
}

@end

