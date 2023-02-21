//
//  TwoTalkMessageData.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/11.
//

#import "MultiTalkMessageData.h"


@implementation MultiTalkMessageData
- (instancetype)initWithtalkRoomname:(NSString *)name AllMessage:(NSMutableArray<OneMessageData *>*)AllMessage TalkId:(NSMutableArray<NSString *> *)TalkId{
    self = [super init];
    if(self){
        self.talkRoomname = name;
        self.AllMessage = AllMessage;
        self.TalkId  = TalkId;
    }
    return self;
}

@end
