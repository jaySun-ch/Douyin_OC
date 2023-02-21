//
//  MultiTalkMessageData.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/11.
//

#import <Foundation/Foundation.h>
#import "OneMessageData.h"

@interface MultiTalkMessageData : NSObject //一个聊天室的存储内容
@property (nonatomic,assign) NSString *talkRoomname; // 聊天室的名称
@property (nonatomic,strong) NSMutableArray<OneMessageData *>* AllMessage; // 所有的聊天内容
@property (nonatomic,strong) NSMutableArray<NSString *> *TalkId; // 所有聊天的人的UID
- (instancetype)initWithtalkRoomname:(NSString *)name AllMessage:(NSMutableArray<OneMessageData *>*)AllMessage TalkId:(NSMutableArray<NSString *>*)TalkId;
@end
