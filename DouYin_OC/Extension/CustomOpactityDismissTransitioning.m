//
//  CustomOpactityDismissTransitioning.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/15.
//

#import "CustomOpactityDismissTransitioning.h"

@implementation CustomOpactityDismissTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.25f;
}

// signIn --> signUp
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UINavigationController *toVc = (UINavigationController *)[transitionContext viewForKey:UITransitionContextToViewControllerKey];
    UINavigationController *fromVc = (UINavigationController *)[transitionContext viewForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    [fromVc removeFromParentViewController];
    [containerView addSubview:toVc.view];
    toVc.view.alpha = 0;
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionLayoutSubviews animations:^{
        toVc.view.alpha = 1;
    } completion:^(BOOL finished) {
//        NSLog(@"Hascompletion");
        [transitionContext completeTransition:YES];
    }];
}

@end
