//
//  UIWindow+Extension.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/18.
//

#import <UIKit/UIKit.h>

static char tipsKey;
static char tapKey;
static const NSInteger SliderBackground = 0x01;
static const NSInteger SliderBar = 0x02;

@interface UIWindow (Extension)

+(void)showTips:(NSString *)text;
+(void)AddSubView:(UIView *)view;
+(void)PushController:(UIViewController *)conrtoller;
+(void)PushController:(UIViewController *)conrtoller animated:(BOOL)animated;
+(void)popController;
+(void)PopToRootController;
+(void)PopToConrtoller:(UIViewController *)conrtoller;
+(void)ShowLoadNoAutoDismiss;
+(void)ShowLoadAutoDismiss;
+(void)DissMissLoadWithBlock:(void(^)(void))Block;
+(void)ShowSetSliderBar;
+(void)PushControllerWithDissmissSliderBar:(UIViewController *)controller;
+(void)ShowProgreeViewWithTitle:(NSString *)title;
+(void)DismissProgressViewNormal;
+(void)DissMissSliderBar;
+(void)SignOutWithProgress;
+(void)AddSetSliderBar;
+(void)RemoveSetSliderBar;
+(void)ShowSetSliderBarWithTrans:(UIScreenEdgePanGestureRecognizer *)gesture;
+(void)PushControllerWithScrollX:(CGFloat)scrollx gesture:(UIScreenEdgePanGestureRecognizer *)gesture;
@end
