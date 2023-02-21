//
//  ChangeClientMessage.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/7.
//

#import "BaseRequest.h"

@interface ChangeClientMessageRequest : BaseRequest
@property (nonatomic,copy) NSString *ChangeMessageName;
@property (nonatomic,copy) NSString *ChangeContend;
@property (nonatomic,copy) NSString *PhoneNumber;
@end
