//
//  SuccessResponse.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/27.
//

#import "BaseResponse.h"

@interface  SuccessResponse:BaseResponse
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *msg;
@end
