//
//  VideoAccountHeaderCell.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2023/1/7.
//

#import <UIKit/UIKit.h>
#import "ClientData.h"
#import "CustomButtonView.h"
#import "CustomeIntroduceView.h"
#import "CustomIconView.h"
#import "HeaderTabbar.h"

static const NSInteger VideoAccountHeadBackGround = 0x01;
static const NSInteger VideoAccountHeadClientImage = 0x02;
static const NSInteger VideoAccountHeadClientNameRightButton = 0x03;

@protocol VideoAccountHeaderCellDelegate

@required
-(void)OnTapView:(NSInteger)view;

@end

@interface VideoAccountHeaderCell : UICollectionReusableView
@property (nonatomic,strong) id<VideoAccountHeaderCellDelegate> delegate;
@property (nonatomic,strong) HeaderTabbar *tabbar;
-(void)ScrollToPageIndex:(NSInteger)index;
-(void)ScaleBackGroundImage:(CGFloat) offsetY;
- (void)UpdatecontainerViewAlpha:(CGFloat) offsetY;
-(void)SelectPageChangeAlpha;
-(void)initData:(ClientData *)data;
@end
