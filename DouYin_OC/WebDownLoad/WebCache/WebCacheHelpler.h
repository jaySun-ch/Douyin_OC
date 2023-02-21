//
//  WebCacheHelpler.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/16.
//

#import "BlockDefine.h"

@interface WebCacheHelpler : NSObject
@property (nonatomic,strong) NSFileManager *fileManager;

+ (WebCacheHelpler *)sharedWebCache;

//根据key值从本地磁盘中查询缓存数据
-(NSOperation *)queryURLFromDiskMemory:(NSString *)key cacheQueryCompletedBlock:(WebCacheQueryCompletedBlock)cacheQueryCompletedBlock;

//根据key值从内存和本地磁盘中查询缓存数据，所查询缓存数据包含指定文件类型
-(NSOperation *)queryDataFromDiskMemory:(NSString *)key cacheQueryCompletedBlock:(WebCacheQueryCompletedBlock)cacheQueryCompletedBlock;

//存储缓存数据到内存和本地磁盘
-(void)storeDataCache:(NSData *)data forKey:(NSString *)key;

- (NSString *)diskCachePathForKey:(NSString *)key;

//存储缓存数据到本地磁盘
- (void)storeDataToDiskCache:(NSData *)data key:(NSString *)key;

-(NSString *)clearDiskCache;

@end
