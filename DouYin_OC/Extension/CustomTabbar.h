//
//  CustomTabbar.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/14.
//

#import <UIKit/UIKit.h>
#import "CustomTabarItem.h"

NS_ASSUME_NONNULL_BEGIN
@class CustomTabbar;

@protocol CustomTabbarDelegate <UITabBarDelegate>

@optional

-(void) tabbarDidClickCustomPlusButton:(CustomTabbar *)tabbar;
-(void) tabbarDidClickCustomHomePageButton:(CustomTabbar *)tabbar;
-(void) tabbarDidClickCustomFriendPageButton:(CustomTabbar *)tabbar;
-(void) tabbarDidClickCustomNoitfyButton:(CustomTabbar *)tabbar;
-(void) tabbarDidClickCustomAccountButton:(CustomTabbar *)tabbar;
@end

@interface CustomTabbar : UITabBar
@property (nonatomic,strong) UIButton *FristButton;
@property (nonatomic,strong) UIButton *SecondButton;
@property (nonatomic,strong) UIButton *PlusButton;
@property (nonatomic,strong) UIButton *ThirdButton;
@property (nonatomic,strong) UIButton *FourthButton;
@property (nonatomic,weak) id<CustomTabbarDelegate> myDelegate;
@end

NS_ASSUME_NONNULL_END
