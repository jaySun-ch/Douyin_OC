//
//  ChangeBackGroundView.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/5.
//

#import <UIKit/UIKit.h>


@protocol  ChangeBackGroundViewDelegate

@required
-(void)DismissBackGroundView:(BOOL)isUp;
-(void)ShowSelectBackGroundViewController;

@end

@interface ChangeBackGroundView:UIView
@property (nonatomic,strong) id<ChangeBackGroundViewDelegate> delegate;
@property (nonatomic,strong) UIImageView *backgroundImage;
@end
