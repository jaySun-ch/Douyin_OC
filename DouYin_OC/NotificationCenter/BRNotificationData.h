//
//  BRNotificationData.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/16.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,BRNotificationType){
    BRNotificationNewFriend,// 新的关注/粉丝
    BRNotificationNewChatMessage, // 新的消息通知
};


@interface BRNotificationData : NSObject
@property (nonatomic,assign) BRNotificationType NotType;
@property (nonatomic,strong) id NotContend;
@end
