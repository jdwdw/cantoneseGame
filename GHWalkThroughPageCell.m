//
//  GHWalkThroughCell.m
//  GHWalkThrough
//
//  Created by Tapasya on 21/01/14.
//  Copyright (c) 2014 Tapasya. All rights reserved.
//

#import "GHWalkThroughPageCell.h"
//#import "ViewController.h"
#import "AppDelegate.h"
#import "config.h"


@interface GHWalkThroughPageCell ()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UITextView* descLabel;
@property (nonatomic, strong) UIImageView* titleImageView;
@property (nonatomic,assign) int theMaxIndex;


//@property (nonatomic,strong) UIButton *button1;

@end

@implementation GHWalkThroughPageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self applyDefaults];
        [self buildUI];
//        [self buildButton];
       self.theMaxIndex=(int)[[NSUserDefaults standardUserDefaults]integerForKey:maxIndex];
    }
    return self;
}

#pragma mark setters

- (void) setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = self.title;
    [self setNeedsLayout];
}

- (void) setTitleImage:(UIImage *)titleImage
{
    _titleImage = titleImage;
    self.titleImageView.image = self.titleImage;
	self.titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self setNeedsLayout];
}

- (void) setDesc:(NSString *)desc
{
    _desc = desc;
    self.descLabel.text = self.desc;
    [self setNeedsLayout];
}

- (void) setButtonTag:(NSInteger)buttonTag
{

   _buttonTag = buttonTag;
        [self buildButton];
//    self.button1.tag = self.buttonTag;
//    NSString *button1Title =[NSString stringWithFormat: @"%ld", (long)self.buttonTag];
//    [self.button1 setTitle:button1Title forState:UIControlStateNormal];
    [self setNeedsLayout];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect1 = self.titleImageView.frame;
    rect1.origin.x = (self.contentView.frame.size.width - rect1.size.width)/2;
    rect1.origin.y = self.bounds.size.height - self.titlePositionY - self.imgPositionY - rect1.size.height;
    self.titleImageView.frame = rect1;

    [self layoutTitleLabel];
    
    CGRect descLabelFrame = CGRectMake(20, self.bounds.size.height - self.descPositionY, self.contentView.frame.size.width - 40, 500);
    self.descLabel.frame = descLabelFrame;
    
}

- (void) layoutTitleLabel
{
    CGFloat titleHeight;
    
    if ([self.title respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.title attributes:@{ NSFontAttributeName: self.titleFont }];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.contentView.frame.size.width - 20, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        titleHeight = ceilf(rect.size.height);
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        titleHeight = [self.title sizeWithFont:self.titleFont constrainedToSize:CGSizeMake(self.contentView.frame.size.width - 20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
#pragma clang diagnostic pop
    }
    
    CGRect titleLabelFrame = CGRectMake(10, self.bounds.size.height - self.titlePositionY, self.contentView.frame.size.width - 20, titleHeight);

    self.titleLabel.frame = titleLabelFrame;
}

- (void) applyDefaults
{
    self.title = @"Title";
    self.desc = @"Default Description";
    
    self.imgPositionY    = 50.0f;
    self.titlePositionY  = 180.0f;
    self.descPositionY   = 160.0f;
    self.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    self.titleColor = [UIColor whiteColor];
    self.descFont = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
    self.descColor = [UIColor whiteColor];
}

- (void) buildUI {
    
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *pageView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    
    if (self.titleImageView == nil) {
        UIImageView *titleImageView = self.titleImage != nil ? [[UIImageView alloc] initWithImage:self.titleImage] : [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/4*3, kScreenWidth/4*3)];
        self.titleImageView = titleImageView;
    }
    [pageView addSubview:self.titleImageView];
    
    if(self.titleLabel == nil) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.text = self.title;
        titleLabel.font = self.titleFont;
        titleLabel.textColor = self.titleColor;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [pageView addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    
    if(self.descLabel == nil) {
        UITextView *descLabel = [[UITextView alloc] initWithFrame:CGRectZero];
        descLabel.text = self.desc;
        descLabel.scrollEnabled = NO;
        descLabel.font = self.descFont;
        descLabel.textColor = self.descColor;
        descLabel.backgroundColor = [UIColor clearColor];
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.userInteractionEnabled = NO;
        [pageView addSubview:descLabel];
        self.descLabel = descLabel;
    }

    [self.contentView addSubview:pageView];
}

-(void)buildButton{
//    [UIView animateWithDuration:<#(NSTimeInterval)#> delay:<#(NSTimeInterval)#> usingSpringWithDamping:<#(CGFloat)#> initialSpringVelocity:<#(CGFloat)#> options:<#(UIViewAnimationOptions)#> animations:<#^(void)animations#> completion:<#^(BOOL finished)completion#>]
    
    //加一个for循环加9个button
    
   // if (self.button1==nil) {
    
//        UIButton *button1=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
//        
//        button1.backgroundColor=[UIColor redColor];
//        button1.tag=self.buttonTag;
//        [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//            NSString *button1Title =[NSString stringWithFormat: @"%ld", (long)self.buttonTag];
//            [button1 setTitle:button1Title forState:UIControlStateNormal];
//      //  self.button1=button1;
//            [self.contentView addSubview:button1];
   // }
    
    
    UIImage *unlock = [UIImage imageNamed:@"unlock.png"];
    UIImage *lock = [UIImage imageNamed:@"lock.png"];
    
    // init and draw nodes, add reference to array
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    int border = screenRect.size.width / 4*1; // 30 percent outside border: edge to center of outside tile
    int totalBorder = border * 2;
    int useableArea = screenRect.size.width - totalBorder;
    int columns = 3;
    int spans = columns - 1;
    int span = useableArea / spans;
    int startPoint = border;
    
    // Row 1
    for (int i = 0; i < columns; i++){
        
//        SKSpriteNode *menuBtn = [SKSpriteNode spriteNodeWithTexture:texture];
//        menuBtn.position = CGPointMake(startPoint, screenRect.size.height/10 * 7.5);
//        [self addChild:menuBtn];
//        menuBtn.name = [NSString stringWithFormat:@"%i", i + 1];
//        [nodes addObject:menuBtn];
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame=CGRectMake(10, 10, kScreenWidth/5, kScreenWidth/5);
        button1.center=CGPointMake(startPoint, screenRect.size.height/10 * 3.5);
        button1.backgroundColor=[UIColor clearColor];
        button1.tag=self.buttonTag+i;
        button1.titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:kScreenWidth/8 ];
        [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        NSString *button1Title =[NSString stringWithFormat: @"%ld", (long)self.buttonTag+i];
        
        if (button1.tag<=self.theMaxIndex) {
            [button1 setBackgroundImage:unlock forState:UIControlStateNormal ];
            [button1 setTitle:button1Title forState:UIControlStateNormal];
        }else{
            [button1 setBackgroundImage:lock forState:UIControlStateNormal ];
        }
        
        //[button1 setTitle:button1Title forState:UIControlStateNormal];
        //  self.button1=button1;
        [self.contentView addSubview:button1];
        
        startPoint += span;
    }
    
    startPoint = border;
    
    // Row 2
    for (int i = 0; i < columns; i++){
        
//        SKSpriteNode *menuBtn = [SKSpriteNode spriteNodeWithTexture:texture];
//        menuBtn.position = CGPointMake(startPoint, screenRect.size.height/10 * 6);
//        [self addChild:menuBtn];
//        menuBtn.name = [NSString stringWithFormat:@"%i", i + 1 + 3];
//        [nodes addObject:menuBtn];
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame=CGRectMake(10, 10, kScreenWidth/5, kScreenWidth/5);
        button1.center=CGPointMake(startPoint, screenRect.size.height/10 * 5);
        button1.backgroundColor=[UIColor clearColor];
        button1.tag=self.buttonTag+i+3;
        button1.titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:kScreenWidth/8 ];
        [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        NSString *button1Title =[NSString stringWithFormat: @"%ld", (long)self.buttonTag+i+3];
        
        if (button1.tag<=self.theMaxIndex) {
            [button1 setBackgroundImage:unlock forState:UIControlStateNormal ];
            [button1 setTitle:button1Title forState:UIControlStateNormal];
        }else{
            [button1 setBackgroundImage:lock forState:UIControlStateNormal ];
        }
        
        //[button1 setTitle:button1Title forState:UIControlStateNormal];
        //  self.button1=button1;
        [self.contentView addSubview:button1];
        
        startPoint += span;
    }
    
    startPoint = border;
    
    // Row 3
    for (int i = 0; i < columns; i++){
        
//        SKSpriteNode *menuBtn = [SKSpriteNode spriteNodeWithTexture:texture];
//        menuBtn.position = CGPointMake(startPoint, screenRect.size.height/10 * 4.5);
//        [self addChild:menuBtn];
//        menuBtn.name = [NSString stringWithFormat:@"%i", i + 1 + 6];
//        [nodes addObject:menuBtn];
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame=CGRectMake(10, 10, kScreenWidth/5, kScreenWidth/5);
        button1.center=CGPointMake(startPoint, screenRect.size.height/10 * 6.5);
        button1.backgroundColor=[UIColor clearColor];
        button1.tag=self.buttonTag+i+6;
        button1.titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:kScreenWidth/8 ];
        [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        NSString *button1Title =[NSString stringWithFormat: @"%ld", (long)self.buttonTag+i+6];
        if (button1.tag<=self.theMaxIndex) {
            [button1 setBackgroundImage:unlock forState:UIControlStateNormal ];
            [button1 setTitle:button1Title forState:UIControlStateNormal];
        }else{
            [button1 setBackgroundImage:lock forState:UIControlStateNormal ];
        }
       // [button1 setTitle:button1Title forState:UIControlStateNormal];
        //  self.button1=button1;
        [self.contentView addSubview:button1];
        
        startPoint += span;
    }


}


-(void)buttonAction:(UIButton*)sender{
//    if (sender.tag==9) {
//            NSLog(@"button.tag is %ld",sender.tag);
//    }
  NSLog(@"button.tag is %ld",sender.tag);
    [self dismissMenuWithSelection:sender];
    
    testController* testviewController=[[testController alloc]init];
    testviewController.index=sender.tag;
    
    
    //获取navigationController来push GameController进去
    if (sender.tag<=self.theMaxIndex) {
        AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
        [(UINavigationController *)appDelegate.window.rootViewController pushViewController:testviewController animated:YES];
        NSLog(@"%@",appDelegate.window.rootViewController);
    }
//    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
//    [(UINavigationController *)appDelegate.window.rootViewController pushViewController:testviewController animated:YES];
//    NSLog(@"%@",appDelegate.window.rootViewController);
    else{
        NSLog(@"you can't get into it because you not break in");
    }
    

//    [UIView animateWithDuration:0.3 animations:^{
//        self.alpha = 0;
//    } completion:^(BOOL finished){
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)0);
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [self removeFromSuperview];
//            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(walkthroughDidDismissView:)]) {
//              //  [self.delegate walkthroughDidDismissView:self];
//            }
//        });
//    }];
    
    
    
}





- (void)dismissMenuWithSelection:(UIButton*)button
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:.2f
          initialSpringVelocity:10.f
                        options:0 animations:^{
                            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                        }
                     completion:^(BOOL finished) {
                        // [self dismissMenu];
                         button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                     }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
