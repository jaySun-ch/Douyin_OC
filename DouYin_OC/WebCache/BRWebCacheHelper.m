//
//  WebCache.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/31.
//

#import "BRWebCacheHelper.h"

@interface BRWebCacheHelper()
@property (nonatomic,strong) NSFileManager *fileMananger;
@property (nonatomic,strong) NSURL *diskCacheDirectoryURL;
@end

@implementation BRWebCacheHelper

+ (BRWebCacheHelper *)shareCache{
    static dispatch_once_t once;
    static BRWebCacheHelper *cache;
    dispatch_once(&once, ^{
        cache = [BRWebCacheHelper new];
    });
    
    return cache;
}

- (instancetype)init{
    self = [super init];
    if(self){
        _fileMananger = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *path = [paths lastObject];
        NSString *diskCachePath = [NSString stringWithFormat:@"%@%@",path,@"WebVideoCache"];
        BOOL isDirectory = NO;
        BOOL isExisted = [_fileMananger fileExistsAtPath:diskCachePath isDirectory:&isDirectory];
        if(!isDirectory || !isExisted){
            [_fileMananger createDirectoryAtPath:diskCachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        _diskCacheDirectoryURL = [NSURL fileURLWithPath:diskCachePath];
//        NSLog(@"WebCachepath %@",diskCachePath);
    }
    return self;
}

-(void)SaveFileToDisk:(NSURL*)location response:(NSURLResponse *)response error:(NSError *)error{
    NSString *mainPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
    NSString *documents = [mainPath stringByAppendingPathComponent:@"WebVideoCache"];
    NSString *path = [documents stringByAppendingPathComponent:response.suggestedFilename];
    // 保存到当前File
    [_fileMananger moveItemAtURL:location toURL:[NSURL fileURLWithPath:path] error:nil];
}


@end
