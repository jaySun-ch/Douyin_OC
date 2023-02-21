//
//  UINavigationController+Extension.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/13.
//

#import "UINavigationController+Extension.h"

@implementation UINavigationController (Extension)

- (void)viewDidLoad{
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
}

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated IsExtension:(BOOL)IsExtension{
    if(IsExtension){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    return [self popToRootViewControllerAnimated:animated];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return  self.viewControllers.count > 1;
}

-(void)SetNavigationBarBackgroundClear{
//    UINavigationBarAppearance *appearanece = [[UINavigationBarAppearance alloc] init];
//    appearanece.backgroundColor = [UIColor clearColor];
//    appearanece.backgroundImage = [UIImage new];
//    appearanece.backgroundEffect = nil;
//    self.navigationBar.scrollEdgeAppearance = appearanece;
//    self.navigationBar.standardAppearance = appearanece;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//    self.navigationBar.clipsToBounds = YES;
}

-(void)SetNavigationBarBackgoundWhite{
//    self.navigationBar.clipsToBounds = NO;
//    UINavigationBarAppearance *appearanece = [[UINavigationBarAppearance alloc] init];
//    appearanece.backgroundColor = [UIColor whiteColor];
////    appearanece.backgroundImage = [UIImage new];
//    appearanece.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterialLight];
//    self.navigationBar.standardAppearance = appearanece;
//    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//    [self.navigationBar setShadowImage:[UIImage new]];
//    for (UIView *view in self.navigationBar.subviews) {
//        if([view.className isEqualToString:@"_UIBarBackground"]){
//            view.backgroundColor = [UIColor whiteColor];
//            for(UIView *view2 in view.subviews){
//                for(UIView *view3 in view2.subviews){
//                    if(view3.bounds.size.height < 1){
//                        view3.size = CGSizeMake(ScreenWidth, 0);
//                    }
//                }
//            }
//        }
//    }
    
//    if ([view2 isKindOfClass:[UIImageView class]] && view2.bounds.size.height<1){
//    //             //实践后发现系统的横线高度为0.333
//    //                   UIImageView *imageview = (UIImageView *)view2;
//    //                    imageview.backgroundColor = [UIColor redColor];
//    //            }
}

-(void)ShowNavigationBarDownLine{
    self.navigationBar.clipsToBounds = NO;
}

-(void)HiddenNavigationBarDownLine{
    self.navigationBar.clipsToBounds = YES;
}
@end
