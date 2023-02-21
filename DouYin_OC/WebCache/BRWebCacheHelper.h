//
//  WebCacheHelper.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/31.
//

#import <Foundation/Foundation.h>

@interface BRWebCacheHelper : NSObject
+ (BRWebCacheHelper *)shareCache;
-(void)SaveFileToDisk:(NSURL*)location response:(NSURLResponse *)response error:(NSError *)error;
@end
