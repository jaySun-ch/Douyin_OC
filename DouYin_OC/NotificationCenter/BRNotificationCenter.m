//
//  BRNotificationCenter.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/16.
//


#import "BRNotificationCenter.h"


@interface BRNotificationCenter()

@end


@implementation BRNotificationCenter

+ (BRNotificationCenter *)shareCenter{
    static dispatch_once_t once;
    static BRNotificationCenter *manager;
    dispatch_once(&once, ^{
        manager = [BRNotificationCenter new];
    });
    return manager;
}

- (instancetype)init{
    self = [super init];
    if(self){
        self.AllNotData = [NSMutableArray array];
    }
    return self;
}

-(void)AddNotDataWithType:(BRNotificationType)Type Message:(id)Message{
    BRNotificationData *data = [[BRNotificationData alloc] init];
    data.NotType = Type;
    data.NotContend = Message;
    [self.AllNotData addObject:data];
    [UIApplication sharedApplication].applicationIconBadgeNumber = self.AllNotData.count;
    if(Type == BRNotificationNewFriend && self.NotViewDelegate){
        [self.NotViewDelegate DidReceivedNewFriendNotificationForNotView:Message];
    }
    if(Type == BRNotificationNewChatMessage && self.NotViewDelegate){
        [self.NotViewDelegate DidReceivedChatNotificationForNotView:Message];
    }
}

-(NSInteger)GetAllMessageCountByID:(NSString *)Id{
    return [self.AllNotData filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(BRNotificationData *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        SuccessResponse *res = evaluatedObject.NotContend;
        if(evaluatedObject.NotType == BRNotificationNewChatMessage &&  [res.status isEqualToString:Id]){
            return YES;
        }
        return NO;
    }]].count;
}

-(NSInteger)GetAllNewFriendCount{
    return [self.AllNotData filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(BRNotificationData *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if(evaluatedObject.NotType == BRNotificationNewFriend){
            return YES;
        }
        return NO;
    }]].count;
}



-(void)SendNotifitionWithContend:(NSString *)Contend{
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if(granted){
                UNMutableNotificationContent *content = [UNMutableNotificationContent new];
                content.title = @"抖音";
                content.body = Contend;
                content.sound = [UNNotificationSound defaultSound];
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1.0f repeats:NO];
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"request" content:content trigger:trigger];
                [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                    
                }];
            }
    }];
}

-(NSInteger)GetNotificationCount{
    return [self.AllNotData filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(BRNotificationData  *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if(evaluatedObject.NotType == BRNotificationNewFriend ||  evaluatedObject.NotType == BRNotificationNewChatMessage){
            return YES;
        }
        return NO;
    }]].count;
}

-(NSInteger)GetNotificationCountWithoutID:(NSString *)ID{
    return [self.AllNotData filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(BRNotificationData *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        SuccessResponse *res = evaluatedObject.NotContend;
        if(evaluatedObject.NotType == BRNotificationNewChatMessage || evaluatedObject.NotType == BRNotificationNewFriend){
            if([res.status isEqualToString:ID]){
                return NO;
            }else{
                return YES;
            }
        }
        return NO;
    }]].count;
}
@end
