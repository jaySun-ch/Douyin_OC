//
//  GetUserResponse.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/27.
//
#import "BaseResponse.h"
#import "UserData.h"

@interface  GetUserResponse:BaseResponse
@property (nonatomic,copy) NSString *status;
@property (nonatomic,strong) UserData *msg;
@end
