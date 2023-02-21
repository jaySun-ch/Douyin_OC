//
//  UIViewController+PanModalDefault.h
//  HWPanModal
//
//  Created by heath wang on 2019/4/26.
//

#import <UIKit/UIKit.h>
#import "HWPanModalPresentable.h"
#import "HWPanModalPanGestureDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (PanModalDefault) <HWPanModalPresentable, HWPanModalPanGestureDelegate>

@end

NS_ASSUME_NONNULL_END
