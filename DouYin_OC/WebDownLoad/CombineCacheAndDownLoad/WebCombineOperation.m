//
//  WebCacheManager.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/16.
//

#import "WebCombineOperation.h"

@implementation WebCombineOperation

-(void)cancel{
    if(self.cacheOperation){
        [self.cacheOperation cancel];
        self.cacheOperation = nil;
    }
    
    if(self.downOpearation){
        [self.downOpearation cancel];
        self.downOpearation = nil;
    }
    
    if(self.cancelblock){
        self.cancelblock();
        _cancelblock = nil;
    }
}
@end


