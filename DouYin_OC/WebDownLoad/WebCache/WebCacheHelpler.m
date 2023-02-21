//
//  WebCacheHelpler.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/16.
//

#import "WebCacheHelpler.h"

@interface WebCacheHelpler()
@property (nonatomic,strong) NSURL *diskCacheDirectoryURL;
@property (nonatomic,strong) dispatch_queue_t Queue;

@end

@implementation WebCacheHelpler

// 返回当前Cache的共享管理
+ (WebCacheHelpler *)sharedWebCache{
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
        _fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *path = [paths lastObject];
        NSString *diskCachePath = [NSString stringWithFormat:@"%@/%@",path,@"WebVideoCache"];
        BOOL isDirectory = NO;
        BOOL isExisted = [_fileManager fileExistsAtPath:diskCachePath isDirectory:&isDirectory];
        if(!isDirectory || !isExisted){
            [_fileManager createDirectoryAtPath:diskCachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
//        NSLog(@"WebCachepath %@",diskCachePath);
        _diskCacheDirectoryURL = [NSURL fileURLWithPath:diskCachePath];
        _Queue = dispatch_queue_create("com.start.webcache", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}



- (NSOperation *)queryDataFromDiskMemory:(NSString *)key cacheQueryCompletedBlock:(WebCacheQueryCompletedBlock)cacheQueryCompletedBlock{
    NSOperation *opearation = [NSOperation new];
    dispatch_async(_Queue, ^{
        if(opearation.isCancelled){
            return;
        }
    
        NSData *data = [self dataFromDiskCache:key];
        if(data){
            cacheQueryCompletedBlock(data,YES);
        }else{
            cacheQueryCompletedBlock(nil,NO);
        }
    });
    return opearation;
}

- (NSOperation *)queryURLFromDiskMemory:(NSString *)key cacheQueryCompletedBlock:(WebCacheQueryCompletedBlock)cacheQueryCompletedBlock {
    NSOperation *opearation = [NSOperation new];
    dispatch_async(_Queue, ^{
        if(opearation.isCancelled){
            return;
        }
        NSString *path = [self diskCachePathForKey:key];//根据Key
//        NSLog(@"queryURLFromDiskMemory %@",path);
        if([self.fileManager fileExistsAtPath:path]){
            cacheQueryCompletedBlock(path,YES);
        }else{
            cacheQueryCompletedBlock(path,NO);
        }
    });
    return opearation;
}


- (NSData *)dataFromDiskCache:(NSString *)key{
    return [NSData dataWithContentsOfFile:[self diskCachePathForKey:key]];
}


- (void)storeDataCache:(NSData *)data forKey:(NSString *)key{
    dispatch_async(_Queue, ^{
        [self storeDataToDiskCache:data key:key];
    });
}


- (void)storeDataToDiskCache:(NSData *)data key:(NSString *)key{
    if(data && key){
//        NSLog(@"%@ %@ storeDataToDiskCache",data,key);
        [_fileManager createFileAtPath:[self diskCachePathForKey:key] contents:data attributes:nil];
    }
}

- (NSString *)diskCachePathForKey:(NSString *)key{
    NSString *fileName = [key substringFromIndex:MAX((int)[key length]-22, 0)];
    NSString *cachePathForKey = [_diskCacheDirectoryURL URLByAppendingPathComponent:fileName].path;
    return cachePathForKey;
}



-(NSString *)clearDiskCache{
    NSArray *contents = [_fileManager contentsOfDirectoryAtPath:_diskCacheDirectoryURL.path error:nil];
    NSEnumerator *enumerator = [contents objectEnumerator];
    NSString *filename;
    CGFloat foldersize = 0.0f;
    while ((filename = [enumerator nextObject])) {
        NSString *filePath = [_diskCacheDirectoryURL.path stringByAppendingPathComponent:filename];
        foldersize += [_fileManager attributesOfItemAtPath:filePath error:nil].fileSize;
        [_fileManager removeItemAtPath:filePath error:NULL];
    }
    return [NSString stringWithFormat:@"%.2f",foldersize/1024.0f/1024.0f];
}


@end
