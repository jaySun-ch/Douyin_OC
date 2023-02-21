//
//  UIViewController+Extension.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/9.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

- (void)dismissViewToRootController:(BOOL)animationed completion:(void (^ _Nullable)(void))completion{
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:animationed completion:completion];
}

@end
