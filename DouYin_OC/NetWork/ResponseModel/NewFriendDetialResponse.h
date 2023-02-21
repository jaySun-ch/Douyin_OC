//
//  NewFriendDetialResponse.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/16.
//

#import "BaseResponse.h"
#import "FansListDetialData.h"

@interface NewFriendDetialResponse:BaseResponse
@property (nonatomic,strong) NSMutableArray<FansListDetialData *> <FansListDetialData> *msg;
@end
