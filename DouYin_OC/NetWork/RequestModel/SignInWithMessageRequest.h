//
//  SignInWithMessageRequest.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/27.
//
#import "BaseRequest.h"

@interface SignInWithMessageRequest : BaseRequest
@property (nonatomic,copy) NSString *PhoneNumber;
@end

