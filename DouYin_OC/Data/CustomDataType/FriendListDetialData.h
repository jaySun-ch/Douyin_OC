//
//  ClientNamImageIntroudceData.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/16.
//

#import "BaseModel.h"

@protocol FriendListDetialData;

@interface FriendListDetialData : BaseModel
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *ClientImageUrl;
@property (nonatomic,copy) NSString *introduce;
@property (nonatomic,copy) NSString *Id;
@end
