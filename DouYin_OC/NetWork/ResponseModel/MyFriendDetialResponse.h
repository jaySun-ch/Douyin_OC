//
//  MyFriendDetialResponse.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/16.
//

#import "BaseResponse.h"
#import "FriendListDetialData.h"
@interface MyFriendDetialResponse:BaseResponse
@property (nonatomic,strong) NSMutableArray<FriendListDetialData *> <FriendListDetialData> *msg;
@end
