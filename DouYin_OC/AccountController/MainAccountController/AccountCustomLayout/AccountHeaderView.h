//
//  AccountHeaderView.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/28.
//

#import <UIKit/UIKit.h>
#import "ClientData.h"
#import "CustomButtonView.h"
#import "CustomeIntroduceView.h"
#import "CustomIconView.h"
#import "HeaderTabbar.h"

static const NSInteger AccountHeadBackGround = 0x01;
static const NSInteger AccountHeadClientImage = 0x02;
static const NSInteger AccountHeadClientNameRightButton = 0x03;
@protocol AccountHeaderViewDelegate

@required
-(void)OnTapView:(NSInteger)view;

@end

@interface AccountHeaderView : UICollectionReusableView
@property (nonatomic,strong) id<AccountHeaderViewDelegate> delegate;
@property (nonatomic,strong) HeaderTabbar *tabbar;
-(void)ScrollToPageIndex:(NSInteger)index;
-(void)ScaleBackGroundImage:(CGFloat) offsetY;
- (void)UpdatecontainerViewAlpha:(CGFloat) offsetY;
-(void)SelectPageChangeAlpha;
-(void)initData;
@end
