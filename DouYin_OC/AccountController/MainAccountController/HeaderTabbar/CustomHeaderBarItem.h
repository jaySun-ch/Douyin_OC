//
//  CustomHeaderBarItem.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/29.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

@interface CustomHeaderBarItem : UIView
- (instancetype)initWithFrame:(CGRect)frame label:(NSString *)label isLock:(BOOL)islock;
-(void)SetFocus:(BOOL)isSelected;
@end
