//
//  PlayerListManage.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/16.
//

#import "MainPlayList.h"

@implementation MainPlayList

+ (MainPlayList *)shareList{
    static dispatch_once_t once;
    static MainPlayList *list;
    dispatch_once(&once, ^{
        list = [MainPlayList new];
    });
    return list;
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


-(void)SeekToTime:(CGFloat)progress{
    AVPlayer *currentPlayer =  [_VideoList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(AVPlayer *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if(evaluatedObject.rate  != 0){
            return YES;
        }
        return NO;
    }]].firstObject;
    float total = CMTimeGetSeconds([currentPlayer.currentItem duration]);
    [currentPlayer seekToTime:CMTimeMake(total * progress, 1) toleranceBefore:CMTimeMake(0.1, 1) toleranceAfter:CMTimeMake(0.1, 1)];
}

-(void)setCurrentRate:(CGFloat)rate{
    AVPlayer *currentPlayer =  [_VideoList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(AVPlayer *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if(evaluatedObject.rate  != 0){
            return YES;
        }
        return NO;
    }]].firstObject;
    [currentPlayer setRate:rate];
}

-(void)removeAllPlayer{
    [self pauseAll];
    [_VideoList removeAllObjects];
}



@end
