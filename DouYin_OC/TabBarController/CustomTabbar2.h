//
//  CustomTabbar2.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/15.
//

#import <UIKit/UIKit.h>
#import "CustomTabarItem.h"

NS_ASSUME_NONNULL_BEGIN

@class CustomTabbar2;

@protocol CustomTabbarDelegate2 <UITabBarDelegate>
@optional
-(void) tabbarDidClickCustomPlusButton:(CustomTabbar2 *)tabbar;
@end

@interface CustomTabbar2 : UITabBar
@property (strong,nonatomic) NSArray <CustomTabarItem*> *tabItems;
@property (nonatomic,weak) id<CustomTabbarDelegate2> myDelegate;

-(instancetype)initWithFrameAndtabItems:(CGRect)frame tabItems:(NSArray *)tabItems;
- (void)setCurrentIndex:(NSInteger)tag  tintColor:(UIColor *)tintColor;
-(void)SetBadgeWithbage:(NSInteger)Badge Index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
