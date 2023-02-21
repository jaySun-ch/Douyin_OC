//
//  SameCityPlayList.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/19.
//

#import <AVFoundation/AVFoundation.h>

@interface SameCityPlayList:NSObject


@property (nonatomic,strong) NSMutableArray<AVPlayer *> *VideoList;

+(SameCityPlayList *)PlayerListManager;

+(void)setPlayerAudio;

-(void)play:(AVPlayer *)player;

-(void)pause:(AVPlayer *)player;

-(void)pauseAll;

-(void)replay:(AVPlayer *)player;

-(void)removeAllPlayer;
@end

