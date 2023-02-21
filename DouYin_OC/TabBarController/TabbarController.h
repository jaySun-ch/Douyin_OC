//
//  TabbarController.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/14.
//


#import <UIKit/UIKit.h>
#import "CustomTabbar.h"
#import "CustomTabbar2.h"
#import "HomePageController.h"
#import "NotifyController.h"
#import "FriendController.h"
#import "AccountController.h"
#import "SignViewController.h"

@interface MainTabbarController:UITabBarController
@property (strong, nonatomic) CustomTabbar2 *customTabBar;
-(void)ChangeTabbarColorGray;
@end
