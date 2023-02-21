//
//  ConcernPlayList.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/19.
//

#import "ConcernPlayList.h"

@implementation ConcerPlayList

+ (ConcerPlayList *)PlayerListManager{
    static dispatch_once_t once;
    static ConcerPlayList *manager;
    dispatch_once(&once, ^{
        manager = [ConcerPlayList new];
    });
    return manager;
}

+(void)setPlayerAudio{
    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance]setActive:YES error:nil];
}

- (instancetype)init{
    self = [super init];
    if(self){
        _VideoList = [NSMutableArray array];
    }
    return self;
}

-(void)play:(AVPlayer *)player{
    [self pauseAll];
    // 查看新的player是否在VideoList里面
    if(![_VideoList containsObject:player]){
        [_VideoList addObject:player];
    }
    [player play];
}

-(void)pause:(AVPlayer *)player{
    if([_VideoList containsObject:player]){
        [player pause];
    }
}

-(void)pauseAll{
    [_VideoList enumerateObjectsUsingBlock:^(AVPlayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj pause];
    }];
}

-(void)replay:(AVPlayer *)player{
    [self pauseAll];
    if([_VideoList containsObject:player]){
        [player seekToTime:kCMTimeZero];
        [player play];
    }else{
        [_VideoList addObject:player];
        [player play];
    }
}

-(void)removeAllPlayer{
    [self pauseAll];
    [_VideoList removeAllObjects];
}

@end
