//
//  CustomFavoriteView.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/17.
//

#import <UIKit/UIKit.h>

@interface CustomFavoriteView : UIView


@property (nonatomic, strong) UIImageView      *favoriteBefore;
@property (nonatomic, strong) UIImageView      *favoriteAfter;
@property (nonatomic, assign) BOOL      isFavorite;

- (void)resetView;
- (void)startLikeAnim:(BOOL)isLike;
@end

