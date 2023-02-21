//
//  PublicSearchResultSliderBar.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/14.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,BRSliderBarStyle){
    BRSliderBarNormal,
    BRSliderBarWithfilter,
    BRSliderBarWithScroll,
};

@protocol BRSliderBarDelegate

@required
-(void)BRSliderDidTapOnButtonWithTag:(NSInteger)Tag;

@end

@interface BRSliderBar : UIView
@property (nonatomic,strong) UIColor *LineColor;
@property (nonatomic,strong) UIColor *SelectColor;
@property (nonatomic,strong) UIColor *NormalColor;
@property (nonatomic,strong) id<BRSliderBarDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame Style:(BRSliderBarStyle)Style TitleArray:(NSArray<NSString *> *)TitleArray ;
-(void)setIndex:(NSInteger)currentIndex;
@end
