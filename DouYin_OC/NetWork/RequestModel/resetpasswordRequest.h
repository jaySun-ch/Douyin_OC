//
//  resetpasswordRequest.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/27.
//


#import "BaseRequest.h"

@interface resetpasswordRequest : BaseRequest
@property (nonatomic,copy) NSString *PhoneNumber;
@property (nonatomic,copy) NSString *newpassword;
@end
