//
//  UserData.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/27.
//

#import "BaseModel.h"
#import "ConcernListData.h"

@interface UserData : BaseModel
@property (nonatomic,strong) NSArray<ConcernListData *> <ConcernListData> *FriendList;
@property (nonatomic,assign) NSInteger Likecount;
@property (nonatomic,strong) NSArray<ConcernListData *> <ConcernListData> *concernList;
@property (nonatomic,strong) NSArray<ConcernListData *> <ConcernListData> *fansList;
@property (nonatomic,copy) NSString *_id;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSDate *CreateDate;
@property (nonatomic,assign) NSInteger __v;
@property (nonatomic,copy) NSString *phoneNumber;
@property (nonatomic,copy) NSString *BackGroundImageUrl;
@property (nonatomic,copy) NSString *ClientImageUrl;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *introduce;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *location;
@property (nonatomic,copy) NSDate *bornDate;
@property (nonatomic,copy) NSString *school;

@end
