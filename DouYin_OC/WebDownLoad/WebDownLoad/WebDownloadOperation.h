//
//  WebDownloadOperation.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/16.
//

#import "BlockDefine.h"

//自定义用于下载网络资源的NSOperation任务
@interface WebDownloadOperation : NSOperation <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>
@property (strong, nonatomic) NSURLSession             *session;
@property (strong, nonatomic) NSURLSessionTask         *dataTask;
@property (strong, nonatomic, readonly) NSURLRequest   *request;
//初始化
- (instancetype)initWithRequest:(NSURLRequest *)request responseBlock:(WebDownloaderResponseBlock)responseBlock progressBlock:(WebDownloaderProgressBlock)progressBlock completedBlock:(WebDownloaderCompletedBlock)completedBlock cancelBlock:(WebDownloaderCancelBlock)cancelBlock;

@end
