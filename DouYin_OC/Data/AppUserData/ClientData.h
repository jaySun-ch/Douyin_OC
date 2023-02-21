//
//  ClientData.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/28.
//


#import <Foundation/Foundation.h>
#import "UserData.h"
#import "ConcernListData.h"

@protocol ClientData;

@interface ClientData : NSObject<NSCoding>
@property (nonatomic,copy) NSDate *LastSignTime;
@property (nonatomic,assign) BOOL IsSign;
@property (nonatomic,strong) NSArray<ConcernListData *> <ConcernListData>  *FriendList;
@property (nonatomic,assign) NSInteger Likecount;
@property (nonatomic,strong) NSArray<ConcernListData *> <ConcernListData> *concernList;
@property (nonatomic,strong) NSArray<ConcernListData *> <ConcernListData>  *fansList;
@property (nonatomic,copy) NSString *_id;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSDate *CreateDate;
@property (nonatomic,assign) NSInteger __v;
@property (nonatomic,copy) NSString *phoneNumber;
@property (nonatomic,copy) NSString *BackGroundImageUrl;
@property (nonatomic,copy) NSString *ClientImageUrl;
@property (nonatomic,copy) NSString *introduce;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *location;
@property (nonatomic,copy) NSDate *bornDate;
@property (nonatomic,copy) NSString *school;

- (instancetype)initWithData:(UserData *)data IsSign:(BOOL)IsSign;
- (NSInteger)getCurrentProgress;
+ (void)SaveUserToServerWithRequest:(ChangeClientMessageRequest *)request responsedata:(void(^)(SuccessResponse *responsedata))responsedata;
+ (void)SaveUserDateToServerWithRequest:(ChangeClientDateRequest *)request responsedata:(void(^)(SuccessResponse * responsedata))responsedata;
@end
