//
//  WebDownloader.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/16.
//
#import "BlockDefine.h"
#import "WebCombineOperation.h"
#import "WebDownloader.h"
#import "WebCacheHelpler.h"

//自定义网络资源下载器
@interface WebDownloader : NSObject
//用于处理下载任务的NSOperationQueue队列
@property (strong, nonatomic) NSOperationQueue *downloadConcurrentQueue;
@property (strong, nonatomic) NSOperationQueue *downloadSerialQueue;

@property (strong, nonatomic) NSOperationQueue *downloadBackgroundQueue;
@property (strong, nonatomic) NSOperationQueue *downloadPriorityHighQueue;
//单例
+ (WebDownloader *)sharedDownloader;
//下载指定URL网络资源

- (WebCombineOperation *)downloadWithURL:(NSURL *)url
                           progressBlock:(WebDownloaderProgressBlock)progressBlock
                          completedBlock:(WebDownloaderCompletedBlock)completedBlock
                             cancelBlock:(WebDownloaderCancelBlock)cancelBlock;

- (WebCombineOperation *)downloadWithURL:(NSURL *)url
                           progressBlock:(WebDownloaderProgressBlock)progressBlock
                          completedBlock:(WebDownloaderCompletedBlock)completedBlock
                             cancelBlock:(WebDownloaderCancelBlock)cancelBlock
                            isConcurrent:(BOOL)isConcurrent;

- (WebCombineOperation *)downloadWithURL:(NSURL *)url
                           responseBlock:(WebDownloaderResponseBlock)responseBlock
                           progressBlock:(WebDownloaderProgressBlock)progressBlock
                          completedBlock:(WebDownloaderCompletedBlock)completedBlock
                             cancelBlock:(WebDownloaderCancelBlock)cancelBlock;

- (WebCombineOperation *)downloadWithURL:(NSURL *)url
                           responseBlock:(WebDownloaderResponseBlock)responseBlock
                           progressBlock:(WebDownloaderProgressBlock)progressBlock
                          completedBlock:(WebDownloaderCompletedBlock)completedBlock
                             cancelBlock:(WebDownloaderCancelBlock)cancelBlock
                            isConcurrent:(BOOL)isConcurrent;

- (WebCombineOperation *)downloadWithURL:(NSURL *)url
                           responseBlock:(WebDownloaderResponseBlock)responseBlock
                           progressBlock:(WebDownloaderProgressBlock)progressBlock
                          completedBlock:(WebDownloaderCompletedBlock)completedBlock
                             cancelBlock:(WebDownloaderCancelBlock)cancelBlock
                            isBackground:(BOOL)isBackground;
@end
