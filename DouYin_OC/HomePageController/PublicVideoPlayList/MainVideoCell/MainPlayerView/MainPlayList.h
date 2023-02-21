//
//  PlayerListManage.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/16.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface  MainPlayList:NSObject
@property (nonatomic,strong) NSMutableArray<AVPlayer *> *VideoList;

+(MainPlayList *)shareList;

+(void)setPlayerAudio;

-(void)play:(AVPlayer *)player;

-(void)pause:(AVPlayer *)player;

-(void)pauseAll;

-(void)replay:(AVPlayer *)player;

-(void)removeAllPlayer;

-(void)SeekToTime:(CGFloat)progress;
-(void)setCurrentRate:(CGFloat)rate;
@end

