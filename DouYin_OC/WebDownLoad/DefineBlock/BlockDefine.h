//
//  BlockDefine.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/16.
//

#import <UIKit/UIKit.h>
#import "objc/runtime.h"
#import <CommonCrypto/CommonDigest.h>

//缓存清除完毕后的回调block
typedef void(^WebCacheClearCompletedBlock)(NSString *cacheSize);
//缓存查询完毕后的回调block，data返回类型包括NSString缓存文件路径、NSData格式缓存数据
typedef void(^WebCacheQueryCompletedBlock)(id data, BOOL hasCache);
//网络资源下载响应的回调block
typedef void(^WebDownloaderResponseBlock)(NSHTTPURLResponse *response);
//网络资源下载进度的回调block
typedef void(^WebDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize, NSData *data);
//网络资源下载完毕后的回调block
typedef void(^WebDownloaderCompletedBlock)(NSData *data, NSError *error, BOOL finished);
//网络资源下载取消后的回调block
typedef void(^WebDownloaderCancelBlock)(void);
