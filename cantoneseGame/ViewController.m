//
//  ViewController.m
//  cantoneseGame
//
//  Created by dw on 16/1/1.
//  Copyright © 2016年 slippers. All rights reserved.
//

#import "ViewController.h"
#import "GHWalkThroughView.h"
#import "config.h"

static NSString * const sampleDesc1 = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque tincidunt laoreet diam, id suscipit ipsum sagittis a. ";

static NSString * const sampleDesc2 = @" Suspendisse et ultricies sem. Morbi libero dolor, dictum eget aliquam quis, blandit accumsan neque. Vivamus lacus justo, viverra non dolor nec, lobortis luctus risus.";

static NSString * const sampleDesc3 = @"In interdum scelerisque sem a convallis. Quisque vehicula a mi eu egestas. Nam semper sagittis augue, in convallis metus";

static NSString * const sampleDesc4 = @"Praesent ornare consectetur elit, in fringilla ipsum blandit sed. Nam elementum, sem sit amet convallis dictum, risus metus faucibus augue, nec consectetur tortor mauris ac purus.";

static NSString * const sampleDesc5 = @"Sed rhoncus arcu nisl, in ultrices mi egestas eget. Etiam facilisis turpis eget ipsum tempus, nec ultricies dui sagittis. Quisque interdum ipsum vitae ante laoreet, id egestas ligula auctor";

@interface ViewController ()<GHWalkThroughViewDataSource>
@property (nonatomic, strong) GHWalkThroughView* ghView ;
@property(nonatomic,strong) GHWalkThroughPageCell *ghCell;

@property (nonatomic, strong) NSArray* descStrings;

@property (nonatomic, strong) UILabel* welcomeLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //加入GHWalkThrough 作为选关系统
//    _ghView = [[GHWalkThroughView alloc] initWithFrame:self.view.bounds];
//    [_ghView setDataSource:self];
//    [_ghView setWalkThroughDirection:GHWalkThroughViewDirectionVertical];
//    UILabel* welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
//    welcomeLabel.text = @"Welcome";
//    welcomeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40];
//    welcomeLabel.textColor = [UIColor whiteColor];
//    welcomeLabel.textAlignment = NSTextAlignmentCenter;
//    self.welcomeLabel = welcomeLabel;
//    
//    self.descStrings = [NSArray arrayWithObjects:sampleDesc1,sampleDesc2, sampleDesc3, sampleDesc4, sampleDesc5, nil];
//    
//
//    
//    [_ghView setFloatingHeaderView:self.welcomeLabel];
//   // self.ghView.isfixedBackground = YES;
//    [self.ghView setWalkThroughDirection:GHWalkThroughViewDirectionHorizontal];
//    [self.ghView showInView:self.view animateDuration:0.3];
    //NSLog(@"%@",self.navigationController);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //加入GHWalkThrough 作为选关系统
    _ghView = [[GHWalkThroughView alloc] initWithFrame:self.view.bounds];
    [_ghView setDataSource:self];
    [_ghView setWalkThroughDirection:GHWalkThroughViewDirectionVertical];
    UILabel* welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    welcomeLabel.text = @"Welcome";
    welcomeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40];
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    self.welcomeLabel = welcomeLabel;
    
    self.descStrings = [NSArray arrayWithObjects:sampleDesc1,sampleDesc2, sampleDesc3, sampleDesc4, sampleDesc5, nil];
    
    
    
    [_ghView setFloatingHeaderView:self.welcomeLabel];
    // self.ghView.isfixedBackground = YES;
    [self.ghView setWalkThroughDirection:GHWalkThroughViewDirectionHorizontal];
//      [self.ghView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    //转到当前的选择cell上
    
    int theResenceCell=(int)[[NSUserDefaults standardUserDefaults]integerForKey:presenceCell];
    
    [self.ghView showInView:self.view animateDuration:0.3];
    [UIView animateWithDuration:0.0 delay:0.0 options:0 animations:^{
        [self.ghView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:theResenceCell inSection:0]
                                           atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                   animated:NO];
    } completion:^(BOOL finished) {
        NSLog(@"Completed");
    }];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - GHDataSource

-(NSInteger) numberOfPages
{
    return 5;
}

- (void) configurePage:(GHWalkThroughPageCell *)cell atIndex:(NSInteger)index
{
    cell.title = [NSString stringWithFormat:@"This is page %ld", index+1];
    cell.titleImage = [UIImage imageNamed:[NSString stringWithFormat:@"title%ld", index+1]];
    cell.desc = [self.descStrings objectAtIndex:index];
    
    cell.buttonTag=index*9;
  //  [cell buildButton];
}

- (UIImage*) bgImageforPage:(NSInteger)index
{
    NSString* imageName =[NSString stringWithFormat:@"bg_0%ld.jpg", index+1];
    UIImage* image = [UIImage imageNamed:imageName];
    return image;
}


@end
