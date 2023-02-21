//
//  WebCacheManager.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/16.
//

#import "BlockDefine.h"
#import "WebDownloadOperation.h"

@interface WebCombineOperation:NSObject
@property (nonatomic,copy) WebDownloaderCancelBlock cancelblock;
@property (nonatomic,strong) NSOperation *cacheOperation;
@property (nonatomic,strong) WebDownloadOperation *downOpearation;
-(void)cancel;
@end



