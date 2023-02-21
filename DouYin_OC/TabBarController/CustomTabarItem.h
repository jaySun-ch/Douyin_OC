//
//  CustomTabarItem.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTabarItem : UIView
@property (nonatomic,strong) UILabel *labelText;
@property (nonatomic,strong) UIImageView *CurrentImageView;
@property (nonatomic,strong) UILabel *badge;
- (instancetype) initWithTitle:(NSString *) titles;
- (instancetype) initWithImage:(UIImage *) image;
- (void)setItemSelected:(BOOL)itemSelect tintColor:(UIColor*)tintColor;
-(void)changeImagecolor:(UIColor*)tintColor;
-(void)SetBadgeWithBadge:(NSInteger)badge;

@end
NS_ASSUME_NONNULL_END
