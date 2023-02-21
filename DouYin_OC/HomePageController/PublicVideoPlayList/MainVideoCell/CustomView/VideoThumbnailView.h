//
//  VideoThumbnailView.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/19.
//

#import <UIKit/UIKit.h>

@interface VideoThumbnailView : UIView
@property (nonatomic,strong) UILabel *currentTime;
@property (nonatomic,strong) UILabel *allTime;
-(void)SetImageWithimage:(UIImage *)image;
@end
