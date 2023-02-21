//
//  WebDownloader.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/16.
//

#import "WebDownloader.h"

@implementation WebDownloader

+ (WebDownloader *)sharedDownloader{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if(self){
        //初始化并行下载队列
        _downloadConcurrentQueue = [NSOperationQueue new];
        _downloadConcurrentQueue.name = @"com.concurrent.webdownloader";
        _downloadConcurrentQueue.maxConcurrentOperationCount = 6;
        
        //初始化串行下载队列
        _downloadSerialQueue = [NSOperationQueue new];
        _downloadSerialQueue.name = @"com.serial.webdownloader";
        _downloadSerialQueue.maxConcurrentOperationCount = 1;
        
        
        //初始化后台串行下载队列
        _downloadBackgroundQueue = [NSOperationQueue new];
        _downloadBackgroundQueue.name = @"com.background.webdownloader";
        _downloadBackgroundQueue.maxConcurrentOperationCount = 1;
        _downloadBackgroundQueue.qualityOfService = NSQualityOfServiceBackground;
        
        //初始化高优先级下载队列
        _downloadPriorityHighQueue = [NSOperationQueue new];
        _downloadPriorityHighQueue.name = @"com.priorityhigh.webdownloader";
        _downloadPriorityHighQueue.maxConcurrentOperationCount = 1;
        _downloadPriorityHighQueue.qualityOfService = NSQualityOfServiceUserInteractive;
        [_downloadPriorityHighQueue addObserver:self forKeyPath:@"operations" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (WebCombineOperation *)downloadWithURL:(NSURL *)url progressBlock:(WebDownloaderProgressBlock)progressBlock completedBlock:(WebDownloaderCompletedBlock)completedBlock cancelBlock:(WebDownloaderCancelBlock)cancelBlock{
    return  [self downloadWithURL:url progressBlock:nil completedBlock:completedBlock cancelBlock:cancelBlock isConcurrent:YES];
}

- (WebCombineOperation *)downloadWithURL:(NSURL *)url
                           progressBlock:(WebDownloaderProgressBlock)progressBlock
                          completedBlock:(WebDownloaderCompletedBlock)completedBlock
                             cancelBlock:(WebDownloaderCancelBlock)cancelBlock
                            isConcurrent:(BOOL)isConcurrent {
    return [self downloadWithURL:url responseBlock:nil progressBlock:progressBlock completedBlock:completedBlock cancelBlock:cancelBlock isConcurrent:isConcurrent];
}

- (WebCombineOperation *)downloadWithURL:(NSURL *)url
                           responseBlock:(WebDownloaderResponseBlock)responseBlock
                           progressBlock:(WebDownloaderProgressBlock)progressBlock
                          completedBlock:(WebDownloaderCompletedBlock)completedBlock
                             cancelBlock:(WebDownloaderCancelBlock)cancelBlock {
    return [self downloadWithURL:url responseBlock:responseBlock progressBlock:progressBlock completedBlock:completedBlock cancelBlock:cancelBlock isConcurrent:YES];
}

- (WebCombineOperation *)downloadWithURL:(NSURL *)url
                           responseBlock:(WebDownloaderResponseBlock)responseBlock
                           progressBlock:(WebDownloaderProgressBlock)progressBlock
                          completedBlock:(WebDownloaderCompletedBlock)completedBlock
                             cancelBlock:(WebDownloaderCancelBlock)cancelBlock
                            isConcurrent:(BOOL)isConcurrent {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    request.HTTPShouldUsePipelining = YES;
    __block NSString *key = url.absoluteString;
    __block WebCombineOperation  *operation = [WebCombineOperation new];
    __weak __typeof(self) weakself = self;
    operation.cacheOperation = [[WebCacheHelpler sharedWebCache] queryDataFromDiskMemory:key cacheQueryCompletedBlock:^(id data, BOOL hasCache) {
        if(hasCache){
            if(completedBlock){
                completedBlock(data,nil,YES);
            }
        }else{
            operation.downOpearation = [[WebDownloadOperation alloc]initWithRequest:request responseBlock:^(NSHTTPURLResponse *response) {
                if(responseBlock){
                    responseBlock(response);
                }
            } progressBlock:progressBlock completedBlock:^(NSData *data, NSError *error, BOOL finished) {
                if(completedBlock){
                    if(finished && !error){
                        [[WebCacheHelpler sharedWebCache]storeDataCache:data forKey:key];
                        completedBlock(data,nil,YES);
                    }else{
                        completedBlock(data,error,NO);
                    }
                }
            } cancelBlock:^{
                if(cancelBlock){
                    cancelBlock();
                }
            }];
            
            if(isConcurrent){
                [weakself.downloadConcurrentQueue addOperation:operation.downOpearation];
            }else{
                [weakself.downloadSerialQueue addOperation:operation.downOpearation];
            }
        }
    }];
    return operation;
}

- (WebCombineOperation *)downloadWithURL:(NSURL *)url
                           responseBlock:(WebDownloaderResponseBlock)responseBlock
                           progressBlock:(WebDownloaderProgressBlock)progressBlock
                          completedBlock:(WebDownloaderCompletedBlock)completedBlock
                             cancelBlock:(WebDownloaderCancelBlock)cancelBlock
                            isBackground:(BOOL)isBackground {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    request.HTTPShouldUsePipelining = YES;
    __block NSString *key = url.absoluteString;
    __block WebCombineOperation  *operation = [WebCombineOperation new];
    __weak __typeof(self) weakself = self;
    operation.cacheOperation = [[WebCacheHelpler sharedWebCache] queryDataFromDiskMemory:key cacheQueryCompletedBlock:^(id data, BOOL hasCache) {
        if(hasCache){
            if(completedBlock){
                completedBlock(data,nil,YES);
            }
        }else{
            operation.downOpearation = [[WebDownloadOperation alloc] initWithRequest:request responseBlock:^(NSHTTPURLResponse *response) {
                if(responseBlock){
                    responseBlock(response);
                }
            } progressBlock:progressBlock completedBlock:^(NSData *data, NSError *error, BOOL finished) {
                if(completedBlock){
                    if(finished && !error){
                        [[WebCacheHelpler sharedWebCache]storeDataCache:data forKey:key];
                        completedBlock(data,nil,YES);
                    }else{
                        completedBlock(data,error,NO);
                    }
                }
            } cancelBlock:^{
                if(cancelBlock){
                    cancelBlock();
                }
            }];
            
            if(isBackground){
                [weakself.downloadBackgroundQueue addOperation:operation.downOpearation];
            }else{
                [weakself.downloadPriorityHighQueue cancelAllOperations];
                [weakself.downloadPriorityHighQueue addOperation:operation.downOpearation];
            }
        }
    }];
    return operation;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"operations"]){
        @synchronized (self) {
            if(self.downloadPriorityHighQueue.operations.count == 0){
                [self.downloadBackgroundQueue setSuspended:NO];
            }else{
                [self.downloadBackgroundQueue setSuspended:YES];
            }
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)dealloc{
    [_downloadPriorityHighQueue removeObserver:self forKeyPath:@"operations"];
}


@end
