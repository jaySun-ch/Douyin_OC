//
//  CommentBottomBar.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/21.
//

#import <UIKit/UIKit.h>


@interface CommentBottomBar : UIView
@property (nonatomic,strong) YYTextView *textview;
-(void)KeyboardShowLayout;
-(void)KeyBoardDissmisslayout;
@end

