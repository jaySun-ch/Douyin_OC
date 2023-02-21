//
//  AVPlayerView.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/16.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MainPlayList.h"
#import "SameCityPlayList.h"
#import "ConcernPlayList.h"
#import "WebDownloader.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "NSString+Extension.h"

@protocol MainPlayerViewDelegate

@required

-(void)onProgressUpdate:(CGFloat)current total:(CGFloat) total;
-(void)onPlayItemStatusUpdate:(AVPlayerItemStatus)status;

@end

@interface MainPlayerView : UIView


@property (nonatomic,strong) id<MainPlayerViewDelegate>delegate;

-(void)SetLayerWithScale:(CGFloat)Scale;

-(void)SeekToProgress:(CGFloat)Progress;

- (void)SetPlayerUrl:(NSString *)url VideoRadio:(double)VideoRadio;

-(void)cancelLoading;

- (void)startDownLoadTask:(NSURL *)URL isBackground:(BOOL)isBackground;

-(void)updatePlayerState;

-(void)play;

-(void)pause;

-(void)replay;

-(CGFloat)rate;

-(void)retry;

- (UIImage *)getVideoImageAtTime:(CMTime)time;

@end
