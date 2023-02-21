//
//  PublicVideoPlayListViewController.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/18.
//

#import <UIKit/UIKit.h>

@protocol PublicVideoPlayListViewControllerDelegate
@required
-(void)ScaleWithVideo:(UIPinchGestureRecognizer *)gesture isplay:(BOOL)isplay;
-(void)UpdateCurrentPlayerPlayState:(BOOL)isplay;
@end

@interface PublicVideoPlayListViewController : UIView
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) id<PublicVideoPlayListViewControllerDelegate>delegate;
-(void)play;
-(void)pause;
-(void)ReSetVideo;
@end
