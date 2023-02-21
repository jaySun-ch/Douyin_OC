//
//  WebDownloadOperation.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/16.
//

#import "WebDownloadOperation.h"

@interface WebDownloadOperation ()

@property (nonatomic, copy) WebDownloaderResponseBlock responseBlock;     //下载进度响应block
@property (nonatomic, copy) WebDownloaderProgressBlock progressBlock;     //下载进度回调block
@property (nonatomic, copy) WebDownloaderCompletedBlock completedBlock;   //下载完成回调block
@property (nonatomic, copy) WebDownloaderCancelBlock cancelBlock;         //取消下载回调block
@property (nonatomic, strong) NSMutableData *data;                        //用于存储网络资源数据
@property (assign, nonatomic) NSInteger expectedSize;                     //网络资源数据总大小

@property (assign, nonatomic) BOOL executing;//判断NSOperation是否执行
@property (assign, nonatomic) BOOL finished;//判断NSOperation是否结束

@end


@implementation WebDownloadOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)initWithRequest:(NSURLRequest *)request responseBlock:(WebDownloaderResponseBlock)responseBlock progressBlock:(WebDownloaderProgressBlock)progressBlock completedBlock:(WebDownloaderCompletedBlock)completedBlock cancelBlock:(WebDownloaderCancelBlock)cancelBlock{
    if((self = [super init])){
        _request = [request copy];
        _responseBlock = [responseBlock copy];
        _progressBlock = [progressBlock copy];
        _completedBlock = [completedBlock copy];
        _cancelBlock = [cancelBlock copy];
    }
    return self;
}

- (void)start{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    if(self.isCancelled){
        [self done];
        return;
    }
    
    @synchronized (self) {
        NSURLSessionConfiguration *seesionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        seesionConfig.timeoutIntervalForRequest = 15;
        _session = [NSURLSession sessionWithConfiguration:seesionConfig delegate:self delegateQueue:NSOperationQueue.mainQueue];
        _dataTask = [_session dataTaskWithRequest:_request];
        [_dataTask resume];
    }
}

-(BOOL)isExecuting{
    return _executing;
}

- (BOOL)isFinished{
    return _finished;
}

- (BOOL)isAsynchronous{
    return YES;
}

-(void)done{
    [super cancel];
    if(_executing){
        [self willChangeValueForKey:@"isFinished"];
        [self willChangeValueForKey:@"isExecuting"];
        _finished = YES;
        _executing = NO;
        [self didChangeValueForKey:@"isFinished"];
        [self didChangeValueForKey:@"isExecuting"];
        [self reset];
    }
}

-(void)reset{
    if(self.dataTask){
        [_dataTask cancel];
    }
    if(self.session){
        [self.session invalidateAndCancel];
        self.session = nil;
    }
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if(_responseBlock){
        _responseBlock(httpResponse);
    }
    NSInteger code = [httpResponse statusCode];
    
    completionHandler(NSURLSessionResponseAllow);
    self.data = [NSMutableData new];
    NSInteger expected = response.expectedContentLength;
    self.expectedSize = expected;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if(_completedBlock){
        if(error){
            if(error.code == NSURLErrorCancelled){
                _cancelBlock();
            }else{
                _completedBlock(nil,error,NO);
            }
        }else{
            _completedBlock(self.data,nil,YES);
        }
    }
    [self done];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    [self.data appendData:data];
    if(self.progressBlock){
        self.progressBlock(self.data.length, self.expectedSize, data);
    }
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler{
    NSCachedURLResponse *cachedResponse = proposedResponse;
    if(completionHandler){
        completionHandler(cachedResponse);
    }
}

@end
