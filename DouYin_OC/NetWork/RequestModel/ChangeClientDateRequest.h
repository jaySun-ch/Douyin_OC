//
//  ChangeClientDateRequest.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/7.
//
#import "BaseRequest.h"

@interface ChangeClientDateRequest : BaseRequest
@property (nonatomic,copy) NSString *ChangeMessageName;
@property (nonatomic,copy) NSDate *ChangeContend;
@property (nonatomic,copy) NSString *PhoneNumber;
@end
