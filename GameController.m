//
//  GameController.m
//  Anagrams
//
//  Created by Marin Todorov on 16/02/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "GameController.h"
#import "config.h"
#import "TileView.h"
#import "TargetView.h"
#import "ExplodeView.h"
#import "StarDustView.h"
#import "Popup.h"



//之后有3条命，当命用完时判断失败时用
// self.wrongAnagram();



@interface GameController ()<PopupDelegate>{
    NSString *titleText;
    NSString *subTitleText;
    
    
    PopupBackGroundBlurType blurType;
    PopupIncomingTransitionType incomingType;
    PopupOutgoingTransitionType outgoingType;
    
    Popup *popper;
    
}

@end

@implementation GameController
{
  //tile lists
  NSMutableArray* _tiles;
  NSMutableArray* _targets;
  
  //stopwatch variables
  int _secondsLeft;
  NSTimer* _timer;
    
    UIImageView *life1;
    UIImageView *life2;
    UIImageView *life3;
    
    int lifes;
    
}


//判断设备类型
-(bool)checkDevice:(NSString*)name

{
    NSString* deviceType = [UIDevice currentDevice].model;
    NSLog(@"deviceType = %@", deviceType);
    
    NSRange range = [deviceType rangeOfString:name];
    return range.location != NSNotFound;
}

//initialize the game controller
-(instancetype)init
{
  self = [super init];
  if (self != nil) {
    //initialize
    self.data = [[GameData alloc] init];
    
    self.audioController = [[AudioController alloc] init];
    [self.audioController preloadAudioEffects: kAudioEffectFiles];
  }
  return self;
}

//fetches a random anagram, deals the letter tiles and creates the targets
-(void)dealWithNum:(int)num
{
   //设置popview的弹出，回收等属性
    blurType=PopupBackGroundBlurTypeNone;
    incomingType=PopupIncomingTransitionTypeFallWithGravity;
    outgoingType=PopupOutgoingTransitionTypeFallWithGravity;
    
    //用于判断的设备是iPad 还是iphone
    NSLog(@"oo");
    NSString *  nsStrIphone=@"iPhone";
    NSString *  nsStrIpod=@"iPod";
    NSString *  nsStrIpad=@"iPad";
    bool  bIsiPhone=false;
    bool  bIsiPod=false;
    bool  bIsiPad=false;
    bIsiPhone=[self  checkDevice:nsStrIphone];
    bIsiPod=[self checkDevice:nsStrIpod];
    bIsiPad=[self checkDevice:nsStrIpad];
    
    
  NSAssert(self.level.array, @"no level loaded");
  
  //random anagram
  //int randomIndex = arc4random()%[self.level.anagrams count];
  //NSArray* anaPair = self.level.anagrams[ randomIndex ];
    NSString *question = [NSString stringWithFormat:@"%@",[self.level.array[num] objectForKey:@"question"]];
    NSString *answer = [NSString stringWithFormat:@"%@",[self.level.array[num] objectForKey:@"answer"]];
    NSString *tips = [NSString stringWithFormat:@"%@",[self.level.array[num] objectForKey:@"tips"]];
    
    subTitleText=tips;
    titleText=@"Tips";

//  NSString* anagram1 = anaPair[0];
//  NSString* anagram2 = anaPair[1];
  
  int ana1len = [question length];
  int ana2len = [answer length];
  
  NSLog(@"phrase1[%i]: %@", ana1len, question);
  NSLog(@"phrase2[%i]: %@", ana2len, answer);
  
  //calculate the tile size
  float tileSide = ceilf( kScreenWidth*0.9 / (float)MAX(ana1len, ana2len) ) - kTileMargin;
    
    float tileSide1 = ceilf( kScreenWidth*0.9 / 5.0 )- kTileMargin;

  //get the left margin for first tile
  float xOffset = (kScreenWidth - 5 * (tileSide1 + kTileMargin))/2;
    
  
  //adjust for tile center (instead the tile's origin)
  xOffset += tileSide1/2;

  // initialize target list
  _targets = [NSMutableArray arrayWithCapacity: ana2len];
  
  // create targets
  for (int i=0;i<ana2len;i++) {
    NSString* letter = [answer substringWithRange:NSMakeRange(i, 1)];
    
    if (![letter isEqualToString:@" "]) {
      TargetView* target = [[TargetView alloc] initWithLetter:letter andSideLength:tileSide1];
        if (bIsiPad) {
        target.center = CGPointMake(xOffset + i*(tileSide1 + kTileMargin), kScreenHeight/3*2-tileSide1*2);
        }
        else{
      target.center = CGPointMake(xOffset + i*(tileSide1 + kTileMargin), kScreenHeight/3*2-tileSide1*3);
        }
      [self.gameView addSubview:target];
      [_targets addObject: target];
    }
  }
  
  //initialize tile list
  _tiles = [NSMutableArray arrayWithCapacity: ana1len];
  
  //create tiles
  for (int i=0;i<ana1len;i++) {
    NSString* letter = [question substringWithRange:NSMakeRange(i, 1)];
    
    if (![letter isEqualToString:@" "]) {
      TileView* tile = [[TileView alloc] initWithLetter:letter andSideLength:tileSide1];
        
        
        int height=floor(i/5);
        int weight=i%5;
        
        
      tile.center = CGPointMake(xOffset + weight*(tileSide1 + kTileMargin), height*kScreenHeight/8+kScreenHeight/3*2);
      //[tile randomize];
      tile.dragDelegate = self;
      
      [self.gameView addSubview:tile];
      [_tiles addObject: tile];
    }
  }
    
    //tipsButton
    UIImage* image = [UIImage imageNamed:@"btn"];
    
    
    //the help button
    self.btnHelp = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnHelp setTitle:@"" forState:UIControlStateNormal];
    self.btnHelp.titleLabel.font = [UIFont fontWithName:@"comic andy" size:50.0];
    [self.btnHelp setBackgroundImage:image forState:UIControlStateNormal];
    if (bIsiPad) {
    self.btnHelp.frame = CGRectMake(kTileMargin,  kScreenHeight/3*2-tileSide1*3-tileSide1/2-5, image.size.width/image.size.height*tileSide1, image.size.height/image.size.height*tileSide1);
    }else{
        self.btnHelp.frame = CGRectMake(kTileMargin,  kScreenHeight/3*2-tileSide1*5, image.size.width/image.size.height*tileSide1, image.size.height/image.size.height*tileSide1);
    }
    //self.btnHelp.center=CGPointMake(kTileMargin, kScreenHeight/3*2-tileSide1*3);
    self.btnHelp.alpha = 0.7;
    
    [self.btnHelp addTarget:self action:@selector(getTips:) forControlEvents:UIControlEventTouchUpInside];
    [self.gameView addSubview: self.btnHelp];
    
    
    //getTipsbutton
    UIImage* getAnswersButtonImage = [UIImage imageNamed:@"btn"];
    
    
    //the help button
    self.getAnswersButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.getAnswersButton setTitle:@"" forState:UIControlStateNormal];
    self.getAnswersButton.titleLabel.font = [UIFont fontWithName:@"comic andy" size:50.0];
    [self.getAnswersButton setBackgroundImage:getAnswersButtonImage forState:UIControlStateNormal];
    if (bIsiPad) {
        self.getAnswersButton.frame = CGRectMake(2*kTileMargin+getAnswersButtonImage.size.width/getAnswersButtonImage.size.height*tileSide1,  kScreenHeight/3*2-tileSide1*3-tileSide1/2-5, getAnswersButtonImage.size.width/getAnswersButtonImage.size.height*tileSide1, getAnswersButtonImage.size.height/getAnswersButtonImage.size.height*tileSide1);
    }else{
        self.getAnswersButton.frame = CGRectMake(2*kTileMargin+getAnswersButtonImage.size.width/getAnswersButtonImage.size.height*tileSide1,  kScreenHeight/3*2-tileSide1*5, getAnswersButtonImage.size.width/getAnswersButtonImage.size.height*tileSide1, getAnswersButtonImage.size.height/getAnswersButtonImage.size.height*tileSide1);
    }
    //self.btnHelp.center=CGPointMake(kTileMargin, kScreenHeight/3*2-tileSide1*3);
    self.getAnswersButton.alpha = 0.7;
    
    [self.getAnswersButton addTarget:self action:@selector(getAnswers:) forControlEvents:UIControlEventTouchUpInside];
    [self.gameView addSubview: self.getAnswersButton];
    
  
  //start the timer
 // [self startStopwatch];
    
    
    //加3个心形作为性命
    
    lifes=3;
    
    UIImage * lifeImage=[UIImage imageNamed:@"tile"];
    life1=[[UIImageView alloc]initWithFrame:CGRectMake(kTileMargin, 0, lifeImage.size.width/lifeImage.size.height*tileSide1, lifeImage.size.height/lifeImage.size.height*tileSide1)];
     life1.center = CGPointMake(xOffset + 1*(tileSide1 + kTileMargin),tileSide1/2+30);
    [life1 setImage:lifeImage];
    [self.gameView addSubview: life1];
    
    
    life2=[[UIImageView alloc]initWithFrame:CGRectMake(kTileMargin, 0, lifeImage.size.width/lifeImage.size.height*tileSide1, lifeImage.size.height/lifeImage.size.height*tileSide1)];
    life2.center = CGPointMake(xOffset + 2*(tileSide1 + kTileMargin),tileSide1/2+30);
    [life2 setImage:lifeImage];
    [self.gameView addSubview: life2];
    
    life3=[[UIImageView alloc]initWithFrame:CGRectMake(kTileMargin, 0, lifeImage.size.width/lifeImage.size.height*tileSide1, lifeImage.size.height/lifeImage.size.height*tileSide1)];
    life3.center = CGPointMake(xOffset + 3*(tileSide1 + kTileMargin),tileSide1/2+30);
    [life3 setImage:lifeImage];
    [self.gameView addSubview: life3];
}


-(void)getTips:(UIButton *)sender
{
  
    [self showPopper];
}

-(void)getAnswers:(id)sender{
    self.getAnswersAnagram();
}

//a tile was dragged, check if matches a target
-(void)tileView:(TileView*)tileView didDragToPoint:(CGPoint)pt
{
  TargetView* targetView = nil;
  
  for (TargetView* tv in _targets) {
    if (CGRectContainsPoint(tv.frame, pt)) {
      targetView = tv;
      break;
    }
  }
  
  // check if target was found
  if (targetView!=nil) {
    
    // check if letter matches
    if ([targetView.letter isEqualToString: tileView.letter]) {
      
      [self placeTile:tileView atTarget:targetView];
      
      //more stuff to do on success here
      [self.audioController playEffect: kSoundDing];
      
      //give points
      //self.data.points += self.level.pointsPerTile;
      //[self.hud.gamePoints countTo:self.data.points withDuration:1.5];
      
      //check for finished game
      [self checkForSuccess];
    
    } else {

      //visualize the mistake
      [tileView randomize];
      
      [UIView animateWithDuration:0.35
                            delay:0.00
                          options:UIViewAnimationOptionCurveEaseOut
                       animations:^{
                         tileView.center = CGPointMake(tileView.center.x + randomf(-20, 20),
                                                       tileView.center.y + randomf(20, 30));
                       } completion:nil];

      //more stuff to do on failure here
      [self.audioController playEffect:kSoundWrong];
      
      //take out points
     // self.data.points -= self.level.pointsPerTile/2;
     // [self.hud.gamePoints countTo:self.data.points withDuration:.75];
        lifes-=1;
        [self lifeImage];
        if (lifes<=0) {

    //之后有3条命，当命用完时判断失败时用
     //延时1秒再弹出popView
        [self performSelector:@selector(gameOver) withObject:nil afterDelay:1];
  
//            [self clearBoard];
//             self.wrongAnagram();
        }
    }
  }
}

-(void)gameOver{
                [self clearBoard];
                 self.wrongAnagram();
}


-(void)placeTile:(TileView*)tileView atTarget:(TargetView*)targetView
{
  targetView.isMatched = YES;
  tileView.isMatched = YES;
  
  tileView.userInteractionEnabled = NO;
  
  [UIView animateWithDuration:0.35
                        delay:0.00
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     tileView.center = targetView.center;
                     tileView.transform = CGAffineTransformIdentity;
                   }
                   completion:^(BOOL finished){
                     targetView.hidden = YES;
                   }];

  ExplodeView* explode = [[ExplodeView alloc] initWithFrame:CGRectMake(tileView.center.x,tileView.center.y,10,10)];
  [tileView.superview addSubview: explode];
  [tileView.superview sendSubviewToBack:explode];
}

-(void)checkForSuccess
{
  for (TargetView* t in _targets) {
    //no success, bail out
    if (t.isMatched==NO) return;
  }
  
  NSLog(@"Game Over!");

  //stop the stopwatch
  //[self stopStopwatch];
  
  //the anagram is completed!
  [self.audioController playEffect:kSoundWin];
  
  //win animation
  TargetView* firstTarget = _targets[0];
  
  int startX = 0;
  int endX = kScreenWidth + 300;
  int startY = firstTarget.center.y;
  
  StarDustView* stars = [[StarDustView alloc] initWithFrame:CGRectMake(startX, startY, 10, 10)];
  [self.gameView addSubview:stars];
  [self.gameView sendSubviewToBack:stars];
    

   
    
  [UIView animateWithDuration:3
                        delay:0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     stars.center = CGPointMake(endX, startY);
                   } completion:^(BOOL finished) {
                     
                     //game finished
                     [stars removeFromSuperview];
                     
                     //when animation is finished, show menu
                     [self clearBoard];
                     self.onAnagramSolved();
                       

                   }];
}

//-(void)startStopwatch
//{
//  //initialize the timer HUD
// // _secondsLeft = self.level.timeToSolve;
//  [self.hud.stopwatch setSeconds:_secondsLeft];
//  
//  //schedule a new timer
//  _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                            target:self
//                                          selector:@selector(tick:)
//                                          userInfo:nil
//                                           repeats:YES];
//}

//stop the watch
//-(void)stopStopwatch
//{
//  [_timer invalidate];
//  _timer = nil;
//}

//stopwatch on tick
//-(void)tick:(NSTimer*)timer
//{
//  _secondsLeft --;
//  [self.hud.stopwatch setSeconds:_secondsLeft];
//  
//  if (_secondsLeft==0) {
//    [self stopStopwatch];
//  }
//}

//connect the Hint button
//-(void)setHud:(HUDView *)hud
//{
//  _hud = hud;
//  [hud.btnHelp addTarget:self action:@selector(actionHint) forControlEvents:UIControlEventTouchUpInside];
//}

//the user pressed the hint button
//按看广告要答案时候调用的方法
-(void)actionHint
{
  //self.hud.btnHelp.enabled = NO;
  
  //self.data.points -= self.level.pointsPerTile/2;
  //[self.hud.gamePoints countTo: self.data.points withDuration: 1.5];

  // find the first target, not matched yet
  TargetView* target = nil;
  for (TargetView* t in _targets) {
    if (t.isMatched==NO) {
      target = t;
      break;
    }
  }
  
  // find the first tile, matching the target
  TileView* tile = nil;
  for (TileView* t in _tiles) {
    if (t.isMatched==NO && [t.letter isEqualToString:target.letter]) {
      tile = t;
      break;
    }
  }

  // don't want the tile sliding under other tiles
  [self.gameView bringSubviewToFront:tile];
  
  //show the animation to the user
  [UIView animateWithDuration:1.5
                        delay:0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     tile.center = target.center;
                   } completion:^(BOOL finished) {
                     // adjust view on spot
                     [self placeTile:tile atTarget:target];
                     
                     // check for finished game
                     [self checkForSuccess];
                     
                     // re-enable the button
                    // self.hud.btnHelp.enabled = YES;
                   }];

}

//clear the tiles and targets
-(void)clearBoard
{
  [_tiles removeAllObjects];
  [_targets removeAllObjects];
  
  for (UIView *view in self.gameView.subviews) {
    [view removeFromSuperview];
  }
}

#pragma mark Popup Methods

- (void)showPopper {
    
 
   // popper=[[Popup alloc]initWithTitle:titleText subTitle:subTitleText haveOkButton:NO haveBackButton:YES haveVoiceButton:YES haveNextButton:YES];
     popper=[[Popup alloc]initWithTitle:titleText subTitle:subTitleText haveOkButton:YES haveBackButton:NO haveVoiceButton:NO haveNextButton:NO haveRenewButton:NO];
    
    [popper setDelegate:self];
    [popper setBackgroundBlurType:blurType];
    [popper setIncomingTransition:incomingType];
    [popper setOutgoingTransition:outgoingType];
    [popper setRoundedCorners:YES];
    [popper showPopup];
    
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
        //[self actionHint];
    }
    else if (buttonType == PopupButtonVoice) {
        NSLog(@"popupPressButton - PopupButtonVoic");
    }
    else if (buttonType == PopupButtonBack) {
        NSLog(@"popupPressButton - PopupButtonBack");
    }
    else if (buttonType == PopupButtonNext) {
        NSLog(@"popupPressButton - PopupButtonNext");
    }
    
}

- (void)dictionary:(NSMutableDictionary *)dictionary forpopup:(Popup *)popup stringsFromTextFields:(NSArray *)stringArray {
    
    NSLog(@"Dictionary from textfields: %@", dictionary);
    NSLog(@"Array from textfields: %@", stringArray);
    
    //NSString *textFromBox1 = [stringArray objectAtIndex:0];
    //NSString *textFromBox2 = [stringArray objectAtIndex:1];
    //NSString *textFromBox3 = [stringArray objectAtIndex:2];
}

-(void)lifeImage
{
    switch (lifes) {
        case 3:
            
            break;
        case 2:
            life3.image=[UIImage imageNamed:@"btn"];
            break;
        case 1:
            life2.image=[UIImage imageNamed:@"btn"];
            break;
         case 0:
            life1.image=[UIImage imageNamed:@"btn"];
            break;
        default:
            break;
    }
}


@end
