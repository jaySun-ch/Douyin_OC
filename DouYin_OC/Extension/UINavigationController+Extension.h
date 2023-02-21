//
//  UINavigationController+Extension.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/13.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Extension)<UIGestureRecognizerDelegate>
- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated IsExtension:(BOOL)IsExtension;
-(void)SetNavigationBarBackgroundClear;
-(void)ShowNavigationBarDownLine;
-(void)HiddenNavigationBarDownLine;
-(void)SetNavigationBarBackgoundWhite;
@end

