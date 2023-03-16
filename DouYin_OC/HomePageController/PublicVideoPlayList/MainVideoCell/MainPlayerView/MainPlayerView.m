//
//  AVPlayerView.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/16.
//

#import "MainPlayerView.h"



@interface MainPlayerView()<NSURLSessionTaskDelegate,NSURLSessionDataDelegate,AVAssetResourceLoaderDelegate>
@property (nonatomic ,strong) AVURLAsset  *urlAsset;
//当前播放的资源url
@property(nonatomic,strong) NSURL *playUrl;
//当前播放器
@property(nonatomic,strong) AVPlayer *player;
//当前播放的item
@property(nonatomic,strong) AVPlayerItem *playerItem;
//当前播放器的图像界面
@property(nonatomic,strong) AVPlayerLayer *playerLayer;

@property (nonatomic,strong) AVPlayerItemVideoOutput  *output;
//播放器的时间观察
@property(nonatomic,strong) id TimeObserver;
@property (nonatomic, strong) NSOperation  *queryCacheOperation;
@property (nonatomic, strong) WebCombineOperation  *combineOperation;
@property (nonatomic, strong) NSMutableData        *data;
@property (nonatomic, assign) long long            expectedContentLength;
@property (nonatomic, strong) NSMutableArray       *pendingRequests;

@end

@implementation MainPlayerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _pendingRequests = [NSMutableArray array];
        _output = [[AVPlayerItemVideoOutput alloc] init];
        _player = [[AVPlayer alloc] init];
        
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-TabbarHeight);
        [self.layer addSublayer:_playerLayer];
    }
    return self;
}

- (void)SetPlayerUrl:(NSString *)url VideoRadio:(double)VideoRadio{
    NSLog(@"%@ 本地没有Cache",url);
    if(VideoRadio > 1.0){
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }else{
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    [[WebCacheHelpler sharedWebCache] queryURLFromDiskMemory:url cacheQueryCompletedBlock:^(id data, BOOL hasCache) {
        if(hasCache){
            NSLog(@"%@ 本地有Cache",data);
            self.playUrl = [NSURL fileURLWithPath:data];
        }else{
            
            self.playUrl = [NSURL URLWithString:url];
        }
    }];
  
    self.urlAsset = [AVURLAsset URLAssetWithURL:self.playUrl options:nil];
    [self.urlAsset.resourceLoader setDelegate:self queue:dispatch_get_main_queue()];
    self.playerItem = [AVPlayerItem playerItemWithURL:self.playUrl];
    [self.playerItem addOutput:self.output];
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
    self.playerLayer.player = self.player;
    [self addProgressObserver];
}

-(void)updatePlayerState{
    if(_player.rate == 0){
        [self play];
    }else{
        [self pause];
    }
}

- (void)play{
    [[MainPlayList shareList] play:self.player];
}

- (void)pause{
    [[MainPlayList shareList] pause:self.player];
}

- (void)replay{
    [[MainPlayList shareList] replay:self.player];
}



-(void)SeekToProgress:(CGFloat)Progress{
    [[MainPlayList shareList] SeekToTime:Progress];
}


- (UIImage *)getVideoImageAtTime:(CMTime)time{
    NSError *error = nil;
    AVAssetImageGenerator *ig = [[AVAssetImageGenerator alloc] initWithAsset:[AVURLAsset URLAssetWithURL:self.playUrl options:nil]];
    CGImageRef image = [ig copyCGImageAtTime:time actualTime:nil error:&error];
    UIImage *screenShot = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    return screenShot;
}
    
- (CGFloat)rate{
    return [_player rate];
}


- (void)retry{
    
}

- (void)startDownLoadTask:(NSURL *)URL isBackground:(BOOL)isBackground {
    __weak __typeof(self) wself = self;
    NSLog(@"startDownloadTask %@",self.playUrl.absoluteString);
    _queryCacheOperation = [[WebCacheHelpler sharedWebCache] queryURLFromDiskMemory:self.playUrl.absoluteString cacheQueryCompletedBlock:^(id data, BOOL hasCache) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(hasCache) {
                NSLog(@"本地存在缓存");
                return;
            }
            
            if(wself.combineOperation != nil) {
                [wself.combineOperation cancel];
            }
            
            wself.combineOperation = [[WebDownloader sharedDownloader] downloadWithURL:URL responseBlock:^(NSHTTPURLResponse *response) {
                NSLog(@"下载缓存%@",URL.path);
                wself.data = [NSMutableData data];
                wself.expectedContentLength = response.expectedContentLength;
                [wself processPendingRequests];
            } progressBlock:^(NSInteger receivedSize, NSInteger expectedSize, NSData *data) {
                NSLog(@"下载缓存%ld",receivedSize * 100/ expectedSize);
                [wself.data appendData:data];
                //处理视频数据加载请求
                [wself processPendingRequests];
            } completedBlock:^(NSData *data, NSError *error, BOOL finished) {
                if(!error && finished) {
                    //下载完毕，将缓存数据保存到本地
                    NSLog(@"下载完毕");
                    [[WebCacheHelpler sharedWebCache] storeDataToDiskCache:wself.data key: self.playUrl.absoluteString];
                }
            } cancelBlock:^{
                
            } isBackground:isBackground];
        });
    }];
}


//播放器请求
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest{
    if(_combineOperation == nil){
        NSURL *url = [loadingRequest.request URL];
        [self startDownLoadTask:url isBackground:YES];
    }
    [_pendingRequests addObject:loadingRequest];
    return YES;
}

// 取消请求
- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest{
    [_pendingRequests removeObject:loadingRequest];
}

//对请求进行处理
-(void)processPendingRequests{
    NSMutableArray *requestCompleted = [NSMutableArray array];
    [_pendingRequests enumerateObjectsUsingBlock:^(AVAssetResourceLoadingRequest *loadingRequest, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL disResonedCompletely = [self respondWithDataForRequest:loadingRequest];
        if(disResonedCompletely){
            [requestCompleted addObject:loadingRequest];
            [loadingRequest finishLoading];
        }
    }];
    [self.pendingRequests removeObjectsInArray:requestCompleted];
}

//对播放器请求处理核心
- (BOOL)respondWithDataForRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    long long startoffset = loadingRequest.dataRequest.requestedOffset;
    if(loadingRequest.dataRequest.currentOffset != 0){
        startoffset = loadingRequest.dataRequest.currentOffset;
    }

    if(_data.length < startoffset){
        return NO;
    }

    NSUInteger unreadBuffer = _data.length - (NSInteger)startoffset;
    NSUInteger numberOfBytesTorespondWidth = MIN((NSUInteger)loadingRequest.dataRequest.requestedLength, unreadBuffer);
    [loadingRequest.dataRequest respondWithData:[self.data subdataWithRange:NSMakeRange((NSUInteger)startoffset, numberOfBytesTorespondWidth)]];
    long long endOffset = startoffset + loadingRequest.dataRequest.requestedLength;
    BOOL disRepondFully = _data.length >= endOffset;
    return disRepondFully;
}

//添加播放器观察
-(void)addProgressObserver{
    __weak __typeof(self) weakself = self;
    _TimeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        if(weakself.playerItem.status == AVPlayerStatusReadyToPlay){
            float  current = CMTimeGetSeconds(time);
            float total = CMTimeGetSeconds([weakself.playerItem duration]);
            if(total == current){
                [weakself replay];
            }
            if(weakself.delegate){
                [weakself.delegate onProgressUpdate:current total:total];
            }
        }
    }];
}


//添加播放器的Key
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"status"]){
        NSLog(@"%ld playerItemstatus",self.playerItem.status);
        if(self.playerItem.status == AVPlayerItemStatusUnknown){
            NSLog(@"AVPlayerStatusUnknown");
        }
        if(self.playerItem.status == AVPlayerItemStatusFailed){
            NSLog(@"AVPlayerStatusFailed");
        }
        
        if(self.playerItem.status == AVPlayerItemStatusReadyToPlay){
            
        }
        
        if(_delegate){
            [_delegate onPlayItemStatusUpdate:_playerItem.status];
        }
    }else{
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//释放的时候解除观察
-(void)dealloc{
    [_playerItem removeObserver:self forKeyPath:@"status" context:nil];
    [_player removeTimeObserver:_TimeObserver];
}
@end

