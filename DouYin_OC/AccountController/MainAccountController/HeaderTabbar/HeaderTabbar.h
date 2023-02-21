//
//  HeaderTabbar.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/29.
//


#import <UIKit/UIKit.h>

@protocol HeaderTabbarDelegate <NSObject>

@required
-(void)DidSelectIndex:(NSInteger)index;

@end


@interface HeaderTabbar : UIView
- (instancetype)initWithArrayItem:(NSArray<NSString *> *)arrayItem;
@property (nonatomic,weak) id<HeaderTabbarDelegate> delegate;
@property (nonatomic,assign) NSInteger currentIndex;
-(void)ScrollToPageIndex:(NSInteger)index;
@end
