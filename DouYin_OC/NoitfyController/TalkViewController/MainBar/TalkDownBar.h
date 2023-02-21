//
//  TalkDownBar.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/10.
//

#import <UIKit/UIKit.h>

@protocol TalkDownBarDelegate

@required
-(void)DidChangeTextViewHeight:(CGFloat)height;
-(void)DidSendMessage:(NSString *)Message;

@end

@interface TalkDownBar : UIView
@property (nonatomic,strong) id<TalkDownBarDelegate> delegate;
@property (nonatomic,copy) NSString *TalkID;
-(void)DisMissKeyBoard;
@end
