//
//  AddFriendTopBar.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/13.
//


#import <UIKit/UIKit.h>

@protocol AddFriendTopCenterViewDelegate

@required
-(void)DidChangeIndex:(NSInteger)Index;


@end


@interface AddFriendTopCenterView : UIView
@property (nonatomic,strong) id<AddFriendTopCenterViewDelegate> delegate;
@property(nonatomic, assign) CGSize intrinsicContentSize;
- (instancetype)initWithIndex:(NSInteger)index;
-(void)setIndex:(NSInteger)currentIndex;
-(void)ScrollWithLineView:(CGFloat)ScrollX;
@end
