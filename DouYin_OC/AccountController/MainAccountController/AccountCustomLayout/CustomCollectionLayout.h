//
//  CustomCollectionLayout.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/29.
//


#import <UIKit/UIKit.h>

@interface CustomCollectionLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) CGFloat topHeight;
- (instancetype)initWithTopHeight:(CGFloat)height;
@end
