//
//  AllTalkMessageData.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/11.
//
#import <Foundation/Foundation.h>
#import "MultiTalkMessageData.h"

@interface AllTalkMessageData : NSObject<NSCoding> // 当前用户所有的聊天内容
@property (nonatomic,assign) NSMutableArray<MultiTalkMessageData *> *allmessageData;

@end
