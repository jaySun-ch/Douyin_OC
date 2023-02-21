//
//  MusicAlbumAnimationView.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/18.
//


#import <UIKit/UIKit.h>

@interface MusicAlbumAnimationView : UIView

@property (nonatomic,strong) UIImageView *AlbumImage;

-(void)startAnimation:(CGFloat)rate;



-(void)resetView;

@end
