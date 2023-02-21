//
//  MainVideoCell.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/18.
//

#import <UIKit/UIKit.h>

@protocol MainVideoCellDelegate
@required
-(void)ScaleWithVideo:(UIPinchGestureRecognizer *)gesture isplay:(BOOL)isplay;
-(void)UpdateCurrentPlayerPlayState:(BOOL)isplay;

@end

@interface MainVideoCell : UITableViewCell
@property (nonatomic,strong) id<MainVideoCellDelegate>delegate;
@property (nonatomic,assign) BOOL isPlayReady;
@property (nonatomic,strong) UIImageView *pauseIcon;
-(void)SetContainerWithAlpha:(CGFloat)Alpha;
-(void)replay;
-(void)play;
-(void)pause;
-(void)ReSetVideo;
- (void)SetVideoAssset:(VideoPlayData *)data;
- (void)startDownloadHighPriorityTask:(NSString *)url;
@end

