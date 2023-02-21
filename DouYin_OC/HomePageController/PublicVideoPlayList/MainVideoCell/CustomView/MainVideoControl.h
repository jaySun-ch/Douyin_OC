//
//  MainVideoControl.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2023/1/3.
//

#import <UIKit/UIKit.h>

@protocol MainVideoControlDelegate
@required
-(void)TapOnVideoControlWithTag:(NSInteger)Tag;

@end

static const NSInteger cancelButton = 0x01;
static const NSInteger pauseButton = 0x02;
static const NSInteger ratebutton = 0x03;

@interface MainVideoControl : UIView
@property (nonatomic,strong) id<MainVideoControlDelegate>delegate;
@property (nonatomic,strong) UIButton *playbutton;
@property (nonatomic,strong) UIButton *ratebutton;
@end
