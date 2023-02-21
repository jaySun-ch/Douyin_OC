//
//  CustomStarView.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/19.
//

#import <UIKit/UIKit.h>

@interface CustomStarView : UIView


@property (nonatomic, strong) UIImageView      *starBefore;
@property (nonatomic, strong) UIImageView      *starAfter;
@property (nonatomic, assign) BOOL      isStar;

- (void)resetView;
- (void)startLikeAnim:(BOOL)isStar;
@end
