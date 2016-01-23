//
//  testController.h
//  cantoneseGame
//
//  Created by dw on 16/1/2.
//  Copyright © 2016年 slippers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDSideBarController.h"

@interface testController : UIViewController<CDSideBarControllerDelegate>{
    CDSideBarController *sideBar;
}
@property (nonatomic,assign) int index;

@end
