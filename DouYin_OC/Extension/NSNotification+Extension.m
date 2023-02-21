//
//  NSNotification+Extension.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/24.
//

#import "NSNotification+Extension.h"

@implementation NSNotification (Extension)

- (CGFloat)keyBoardHeight {
    NSDictionary *userInfo = [self userInfo];
    CGSize size = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    return UIInterfaceOrientationIsLandscape(orientation) ? size.width : size.height;
}

@end

