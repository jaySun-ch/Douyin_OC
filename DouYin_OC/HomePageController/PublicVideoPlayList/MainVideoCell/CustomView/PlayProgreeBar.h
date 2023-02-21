//
//  PlayProgreeBar.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/19.
//
#import <UIKit/UIKit.h>

@protocol PlayProgreeBarDelegate
@required
-(void)DidDragOnPlayBar:(UIGestureRecognizerState)state;
-(void)EndDragToProgress:(CGFloat)progress;
-(void)DidChangePlayBar:(CGFloat)progress;

@end

@interface PlayProgreeBar : UIView
@property (nonatomic,strong) id<PlayProgreeBarDelegate>delegate;
-(void)ChangeWithProgress:(CGFloat)Progress;
- (void)resetView;
-(void)FocusOnPlaybar;
@end
