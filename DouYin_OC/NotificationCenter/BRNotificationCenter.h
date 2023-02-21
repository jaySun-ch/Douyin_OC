//
//  BRNotificationCenter.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/16.
//


#import <Foundation/Foundation.h>
#import "BRNotificationData.h"

@protocol BRNotificationCenterNotViewDelegate

@required
-(void)DidReceivedChatNotificationForNotView:(id)Message;
-(void)DidReceivedNewFriendNotificationForNotView:(id)Message;

@end

@interface BRNotificationCenter : NSObject
@property (nonatomic,strong) id<BRNotificationCenterNotViewDelegate> NotViewDelegate;
@property (nonatomic,strong) NSMutableArray<BRNotificationData *> *AllNotData;
-(void)SendNotifitionWithContend:(NSString *)Contend;
-(void)AddNotDataWithType:(BRNotificationType)Type Message:(id)Message;
+ (BRNotificationCenter *)shareCenter;
-(NSInteger)GetNotificationCount;
-(NSInteger)GetAllMessageCountByID:(NSString *)Id;
-(NSInteger)GetAllNewFriendCount;
-(NSInteger)GetNotificationCountWithoutID:(NSString *)ID;
@end
