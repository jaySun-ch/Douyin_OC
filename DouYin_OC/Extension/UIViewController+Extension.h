//
//  UIViewController+Extension.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Extension)
-(void)dismissViewToRootController:(BOOL)animationed completion:(void (^ __nullable)(void))completion;
@end

NS_ASSUME_NONNULL_END
