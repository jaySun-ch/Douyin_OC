//
//  UIWindow+Extension.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/18.
//

#import "UIWindow+Extension.h"
#import "TabbarController.h"
#import "objc/runtime.h"
#import "SetSliderBar.h"
#import "DragTipsView.h"
#import "VideoAccountDetialView.h"

#define SliderBarWidth (ScreenWidth / 2) + 50

@interface UIWindow (Extension)
@end

@implementation UIWindow (Extension)

+ (void)showTips:(NSString *)text{
    UITextView *tips = objc_getAssociatedObject(self, &tipsKey);
    if(tips) {
        [self dismiss];
        [NSThread sleepForTimeInterval:0.5f];
    }
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGFloat maxWidth = 200;
    CGFloat maxHeight = window.frame.size.height - 200;
    CGFloat commonInset = 10;
    
    UIFont  *font = [UIFont systemFontOfSize:12];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    CGRect rect = [string boundingRectWithSize:CGSizeMake(maxWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    CGSize size = CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height < maxHeight ? rect.size.height : maxHeight));
    
    CGRect textFrame = CGRectMake(window.frame.size.width/2 , window.frame.size.height / 2, size.width  + commonInset * 2, size.height + commonInset * 2);
    tips = [[UITextView alloc] initWithFrame:textFrame];
    tips.center = CGPointMake(window.frame.size.width / 2, window.frame.size.height / 2);
    tips.text = text;
    tips.font = font;
    tips.textColor = [UIColor whiteColor];
    tips.backgroundColor = [UIColor blackColor];
    tips.layer.cornerRadius = 5;
    tips.editable = NO;
    tips.selectable = NO;
    tips.scrollEnabled = NO;
    tips.textContainer.lineFragmentPadding = 0;
    tips.contentInset = UIEdgeInsetsMake(commonInset, commonInset, commonInset, commonInset);
    tips.alpha = 0;
    tips.transform = CGAffineTransformMakeScale(0, 0);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerGuesture:)];
    [window addGestureRecognizer:tap];
    [window addSubview:tips];
    
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        tips.transform = CGAffineTransformMakeScale(1, 1);
        tips.alpha = 1;
    } completion:nil];
    
    
    objc_setAssociatedObject(self, &tapKey, tap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &tipsKey, tips, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2.0f];
}


+(void)ShowProgreeViewWithTitle:(NSString *)title{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *Background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (ScreenWidth / 3), (ScreenWidth / 3) * 0.7)];
    Background.layer.cornerRadius = 8;
    Background.backgroundColor = [UIColor darkGrayColor];
    Background.tag = 30;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,(ScreenWidth / 3) * 0.7 / 2,(ScreenWidth / 3), 30)];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont systemFontOfSize:15.0]];
    [label setText:title];
    [label setTextColor:[UIColor whiteColor]];
    [Background addSubview:label];
    
    CustomLoadView *load = [[CustomLoadView alloc] init];
    [Background addSubview:load];
    load.centerX = label.centerX + 2;
    load.centerY = ((ScreenWidth / 3) * 0.7 / 4 + 5);
    [window addSubview:Background];
    Background.center =  CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
    [window setUserInteractionEnabled:NO];
}

+(void)SignOutWithProgress{
    [self ShowProgreeViewWithTitle:@"正在退出登陆"];
    [self performSelector:@selector(DismissProgressView) afterDelay:1.5f];
}

+(void)DismissProgressViewNormal{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *Background =[window viewWithTag:30];
    [UIView animateWithDuration:0.2f animations:^{
        Background.alpha = 0;
    }completion:^(BOOL finished) {
        [Background removeFromSuperview];
        [window setUserInteractionEnabled:YES];
    }];
}

+(void)DismissProgressView{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *Background =[window viewWithTag:30];
    [UIView animateWithDuration:0.2f animations:^{
        Background.alpha = 0;
    }completion:^(BOOL finished) {
        [Background removeFromSuperview];
        [window setUserInteractionEnabled:YES];
        [NSUserDefaults.standardUserDefaults setBool:NO forKey:@"HasSignIn"];
        // 退出登陆 并且让当前的User的IsSign变成NO
        ClientData *data = [AppUserData GetCurrenUser];
        data.IsSign = NO;
        [AppUserData SavCurrentUser:data];
        UINavigationController *maincontroller = (UINavigationController *)UIApplication.sharedApplication.delegate.window.rootViewController;
        MainTabbarController *rootController = maincontroller.viewControllers.firstObject;
        [maincontroller popToRootViewControllerAnimated:YES];
        [rootController setSelectedIndex:0];
        [rootController.customTabBar setCurrentIndex:0 tintColor:[UIColor whiteColor]];
        [rootController ChangeTabbarColorGray];
    }];
}

+(void)ShowLoadAutoDismiss{
    CustomLoadView *loadview = [[CustomLoadView alloc] init];
    loadview.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
    [UIApplication.sharedApplication.delegate.window addSubview:loadview];
    [self performSelector:@selector(DissMissLoadWithBlock:) withObject:nil afterDelay:1.0f];
}

+(void)ShowLoadNoAutoDismiss{
    CustomLoadView *loadview = [[CustomLoadView alloc] init];
    loadview.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
    [UIApplication.sharedApplication.delegate.window addSubview:loadview];
}

+(void)DissMissLoadWithBlock:(void(^)(void))Block{
    for(UIView *view in UIApplication.sharedApplication.delegate.window.subviews){
        if([view isKindOfClass:CustomLoadView.class]){
            [view removeFromSuperview];
        }
    }
    if(Block){
        Block();
    }
}

+(void)AddSubView:(UIView *)view{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:view];
}

+(void)AddSetSliderBar{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UINavigationController *maincontroller = (UINavigationController *)UIApplication.sharedApplication.delegate.window.rootViewController;
    UITabBarController *rootController = maincontroller.viewControllers.firstObject;
    SetSliderBar *SliderBar = [window viewWithTag:12];
    UIView *Background = [rootController.view viewWithTag:22];
    if(SliderBar == nil){
        SetSliderBar *SliderBar = [[SetSliderBar alloc] initWithFrame:CGRectMake((ScreenWidth),0,SliderBarWidth, ScreenHeight)];
        SliderBar.tag = 12;
        [window addSubview:SliderBar];
    }
    
    if(Background == nil){
        UIView *Background =  [[UIView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, ScreenHeight)];
        Background.tag = 22;
        Background.backgroundColor = [UIColor blackColor];
        Background.alpha = 0;
        [Background setUserInteractionEnabled:YES];
        [Background addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(DissMissSliderBar)]];
        [Background addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(BackgroundGestureHandler:)]];
        [rootController.view addSubview:Background];
    }
    maincontroller.view.transform = CGAffineTransformIdentity;
    rootController.view.transform = CGAffineTransformIdentity;
}

+(void)RemoveSetSliderBar{
    UINavigationController *maincontroller = (UINavigationController *)UIApplication.sharedApplication.delegate.window.rootViewController;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UITabBarController *rootController = maincontroller.viewControllers.firstObject;
    SetSliderBar *SliderBar = [window viewWithTag:12];
    UIView *Background = [rootController.view viewWithTag:22];
    [Background removeFromSuperview];
    [SliderBar removeFromSuperview];
}

+(void)ShowSetSliderBar{
    [self AddSetSliderBar];
    UINavigationController *maincontroller = (UINavigationController *)UIApplication.sharedApplication.delegate.window.rootViewController;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UITabBarController *rootController = maincontroller.viewControllers.firstObject;
    SetSliderBar *SliderBar = [window viewWithTag:12];
    UIView *Background = [rootController.view viewWithTag:22];
    [UIView animateWithDuration:0.3f animations:^{
        Background.alpha = 0.3;
        maincontroller.view.transform  = CGAffineTransformMakeTranslation(-(ScreenWidth-SliderBarWidth), 0);
        SliderBar.transform  = CGAffineTransformMakeTranslation(-(ScreenWidth-SliderBarWidth), 0);
    } completion:^(BOOL finished) {
    }];
}

+(void)ShowSetSliderBarWithTrans:(UIScreenEdgePanGestureRecognizer *)gesture{
    UINavigationController *maincontroller = (UINavigationController *)UIApplication.sharedApplication.delegate.window.rootViewController;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UITabBarController *rootController = maincontroller.viewControllers.firstObject;
    SetSliderBar *SliderBar = [window viewWithTag:12];
    UIView *Background = [rootController.view viewWithTag:22];
    CGFloat Transx  = [gesture translationInView:maincontroller.view].x;
    if(gesture.state == UIGestureRecognizerStateBegan){
        [self AddSetSliderBar];
    }
    
//    NSLog(@"%f ScreenEdgeGestureHandler",Transx);
    
    if(gesture.state == UIGestureRecognizerStateChanged){
        // 当手势发生变化的时候 如果当前的
        if(Transx <= 0 && Transx >= -(ScreenWidth-SliderBarWidth)){
            [UIView animateWithDuration:0.15f animations:^{
                Background.alpha = 0.3;
                maincontroller.view.transform  = CGAffineTransformMakeTranslation(Transx, 0);
                SliderBar.transform  = CGAffineTransformMakeTranslation(Transx, 0);
            } completion:nil];
        }
        
    }
   
    if(gesture.state == UIGestureRecognizerStateEnded){
        if(Transx < -50){
            [UIView animateWithDuration:0.2f animations:^{
                Background.alpha = 0.3;
                maincontroller.view.transform  = CGAffineTransformMakeTranslation(-(ScreenWidth-SliderBarWidth), 0);
                SliderBar.transform  = CGAffineTransformMakeTranslation(-(ScreenWidth-SliderBarWidth), 0);
            } completion:nil];
        }else{
            [self DissMissSliderBar];
        }
    }
   
  
   
}



+(void)BackgroundGestureHandler:(UIPanGestureRecognizer *)gesture{
    UINavigationController *maincontroller = (UINavigationController *)UIApplication.sharedApplication.delegate.window.rootViewController;
    CGFloat Transx = [gesture translationInView:maincontroller.view].x;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UITabBarController *rootController = maincontroller.viewControllers.firstObject;
    SetSliderBar *SliderBar = [window viewWithTag:12];
    UIView *Background = [rootController.view viewWithTag:22];
    if(Transx >= 0){
        if(gesture.state == UIGestureRecognizerStateEnded){
            if(Transx < 50){
                [UIView animateWithDuration:0.2f animations:^{
                    Background.alpha = 0.3;
                    maincontroller.view.transform  = CGAffineTransformMakeTranslation(-(ScreenWidth-SliderBarWidth), 0);
                    SliderBar.transform  = CGAffineTransformMakeTranslation(-(ScreenWidth-SliderBarWidth), 0);
                } completion:nil];
            }else{
                [self DissMissSliderBar];
            }
        }else{
            if(Transx <= ScreenWidth / 2){
                [UIView animateWithDuration:0.2f animations:^{
                    Background.alpha = 0.3 * (ScreenWidth / 2 - Transx)/(ScreenWidth / 2);
                    maincontroller.view.transform  = CGAffineTransformMakeTranslation(-(ScreenWidth-SliderBarWidth)+Transx, 0);
                    SliderBar.transform  = CGAffineTransformMakeTranslation(-(ScreenWidth-SliderBarWidth)+Transx, 0);
                }completion:nil];
            }
        }
    }
}


+(void)DissMissSliderBar{
    UINavigationController *maincontroller = (UINavigationController *)UIApplication.sharedApplication.delegate.window.rootViewController;
    UITabBarController *rootController = maincontroller.viewControllers.firstObject;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *Background = [rootController.view viewWithTag:22];
    SetSliderBar *SliderBar = [window viewWithTag:12];
//    NSLog(@"%@ DissMissSliderBar",SliderBar);
    [UIView animateWithDuration:0.3f animations:^{
        Background.alpha = 0;
        [maincontroller.view setTransform:CGAffineTransformIdentity];
        SliderBar.transform  = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [Background removeFromSuperview];
        [SliderBar removeFromSuperview];
    }];
}

+(void)PushControllerWithDissmissSliderBar:(UIViewController *)controller{
    UINavigationController *maincontroller = (UINavigationController *)UIApplication.sharedApplication.delegate.window.rootViewController;
    UITabBarController *rootController = maincontroller.viewControllers.firstObject;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *Background = [rootController.view viewWithTag:22];
    SetSliderBar *SliderBar = [window viewWithTag:12];
    Background.alpha = 0;
    controller.view.alpha = 0;
    [UIWindow PushController:controller];
    [window setBackgroundColor:[UIColor whiteColor]];
    [maincontroller.view setTransform:CGAffineTransformIdentity];
    rootController.view.transform  = CGAffineTransformMakeTranslation(-(ScreenWidth-SliderBarWidth), 0);
    SliderBar.transform  = CGAffineTransformMakeTranslation(-(ScreenWidth-SliderBarWidth), 0);
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        SliderBar.transform = CGAffineTransformMakeTranslation(-(ScreenWidth), 0);
        SliderBar.alpha = 0;
    }completion:nil];
    
    [UIView animateWithDuration:0.3f delay:0.1f options:UIViewAnimationOptionCurveEaseIn animations:^{
        rootController.view.alpha = 0;
        controller.view.alpha = 1;
        rootController.view.transform  = CGAffineTransformMakeTranslation(-(ScreenWidth), 0);
    }completion:^(BOOL finished) {
        [SliderBar removeFromSuperview];
        [Background removeFromSuperview];
        [self performSelector:@selector(RemoveTransFrom) afterDelay:0.2f];
        [window setBackgroundColor:[UIColor clearColor]];
    }];
}

+(void)RemoveTransFrom{
    UINavigationController *maincontroller = (UINavigationController *)UIApplication.sharedApplication.delegate.window.rootViewController;
    UITabBarController *rootController = maincontroller.viewControllers.firstObject;
    [rootController.view setTransform:CGAffineTransformIdentity];
    rootController.view.alpha = 1;
}


+(void)handlerGuesture:(UIGestureRecognizer *)sender {
    if(!sender || !sender.view)
        return;
    [self dismiss];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object: nil];
}

+(void)dismiss {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UITapGestureRecognizer *tap = objc_getAssociatedObject(self, &tapKey);
    [window removeGestureRecognizer:tap];
    
    UITextView *tips = objc_getAssociatedObject(self, &tipsKey);
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        tips.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [tips removeFromSuperview];
    }];
}

+(void)PushController:(UIViewController *)conrtoller animated:(BOOL)animated{
    UINavigationController *rootController = (UINavigationController *)UIApplication.sharedApplication.delegate.window.rootViewController;
    [rootController pushViewController:conrtoller animated:animated ];
}

+(void)PushController:(UIViewController *)conrtoller{
    UINavigationController *rootController = (UINavigationController *)UIApplication.sharedApplication.delegate.window.rootViewController;
    [rootController pushViewController:conrtoller animated:YES];
}

+(void)popController{
    UINavigationController *rootController = (UINavigationController *)UIApplication.sharedApplication.delegate.window.rootViewController;
    [rootController popViewControllerAnimated:YES];
}

+(void)PopToRootController{
    UINavigationController *rootController = (UINavigationController *)UIApplication.sharedApplication.delegate.window.rootViewController;
    [rootController popToRootViewControllerAnimated:YES];
}

+(void)PopToConrtoller:(UIViewController *)conrtoller{
    UINavigationController *rootController = (UINavigationController *)UIApplication.sharedApplication.delegate.window.rootViewController;
    [rootController popToViewController:conrtoller animated:YES];
}

+(void)PushControllerWithScrollX:(CGFloat)scrollx gesture:(UIScreenEdgePanGestureRecognizer *)gesture{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UINavigationController *maincontroller = (UINavigationController *)UIApplication.sharedApplication.delegate.window.rootViewController;
    UITabBarController *rootController = maincontroller.viewControllers.firstObject;
    VideoAccountDetialView *viewcontroller = [VideoAccountDetialView new];
    viewcontroller.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    viewcontroller.view.backgroundColor = [UIColor whiteColor];
    viewcontroller.view.tag = 10;
    DragTipsView *Tipview = [[DragTipsView alloc] initWithFrame:CGRectMake(0, 0, 80, ScreenHeight)];
    Tipview.transform = CGAffineTransformMakeTranslation(ScreenWidth, 0);
    Tipview.tag = 20;
    
//    NSLog(@"PushControllerWithScrollX %f",scrollx);
    //UIView *Tipview = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth - 40, 0, 40, ScreenHeight)];
    //Tipview.backgroundColor = [UIColor whiteColor];
    if(gesture.state == UIGestureRecognizerStateBegan){
//        NSLog(@"hello UIGestureRecognizerStateBegan");
        [rootController.view addSubview:Tipview];
        [rootController.view addSubview:viewcontroller.view];
        viewcontroller.view.transform = CGAffineTransformMakeTranslation(ScreenWidth, 0);
        [UIView animateWithDuration:0.2f animations:^{
            Tipview.transform = CGAffineTransformMakeTranslation(ScreenWidth - 80, 0);
        }];
    }
    

    
    if(gesture.state == UIGestureRecognizerStateChanged){
        if(scrollx >= -ScreenWidth  && scrollx <= 0){
            // 如果 scrollx
            [UIView animateWithDuration:0.2f animations:^{
                rootController.view.transform = CGAffineTransformMakeTranslation(scrollx, 0);
                UIView *viewcontrollerview = [rootController.view viewWithTag:10];
                DragTipsView *tipview  = [rootController.view viewWithTag:20];
                if(ScreenWidth + scrollx / 5 >= 0){
                    viewcontrollerview.transform = CGAffineTransformMakeTranslation(ScreenWidth + scrollx / 5, 0);
                }
                
                tipview.transform = CGAffineTransformMakeTranslation(ScreenWidth - 80 + scrollx / 25, 0);
            }];
        }
    }
    
    UIView *viewcontrollerview = [rootController.view viewWithTag:10];
//    NSLog(@"%f viewcontrollertransform",viewcontrollerview.transform.tx);
    
    
    if(gesture.state == UIGestureRecognizerStateEnded){
        DragTipsView *tipview  = [rootController.view viewWithTag:20];
        if(scrollx <=  -ScreenWidth / 2){
            [UIView animateWithDuration:0.2f animations:^{
                rootController.view.transform = CGAffineTransformMakeTranslation(-ScreenWidth, 0);
            }completion:^(BOOL finished) {
                [tipview removeFromSuperview];
                [UIWindow PushController:viewcontroller animated:NO];
                rootController.view.transform = CGAffineTransformIdentity;
                UIView *viewcontrollerview = [rootController.view viewWithTag:10];
                [viewcontrollerview removeFromSuperview];
            }];
        }else{
            [UIView animateWithDuration:0.2f animations:^{
                rootController.view.transform = CGAffineTransformMakeTranslation(0, 0);
                UIView *viewcontrollerview = [rootController.view viewWithTag:10];
                viewcontrollerview.transform = CGAffineTransformMakeTranslation(ScreenWidth, 0);
                tipview.alpha = 0;
                tipview.transform = CGAffineTransformMakeTranslation(ScreenWidth, 0);
            }completion:^(BOOL finished) {
                tipview.transform = CGAffineTransformIdentity;
                [tipview removeFromSuperview];
            }];
        }
    }
    
    if(gesture.state == UIGestureRecognizerStateCancelled){
        DragTipsView *tipview  = [rootController.view viewWithTag:20];
        [UIView animateWithDuration:0.2f animations:^{
            rootController.view.transform = CGAffineTransformMakeTranslation(0, 0);
            tipview.alpha = 0;
        }completion:^(BOOL finished) {
            [tipview removeFromSuperview];
        }];
    }
}


@end

