//
//  SignInRequest.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/27.
//


#import "BaseRequest.h"

@interface SignInRequest : BaseRequest
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *password;
@end
