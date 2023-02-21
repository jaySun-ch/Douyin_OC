//
//  TopBar.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/10.
//


#import <UIKit/UIKit.h>

static const NSInteger TalkTopBarBackButton = 0x01;


@protocol TalkTopBarDelegate

@required
-(void)TopBarDidTapOnView:(NSInteger)view;

@end

@interface TalkTopBar : UIView
@property (nonatomic,strong) UILabel *label ;
@property (nonatomic,strong) id <TalkTopBarDelegate> delegate;
-(void)SetData:(NSString *)imageurl name:(NSString *)name;
@end
