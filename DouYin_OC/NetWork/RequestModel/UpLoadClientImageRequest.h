//
//  UpLoadClientImageRequest.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/9.
//

#import "BaseRequest.h"

@interface UpLoadClientImageRequest : BaseRequest
@property (nonatomic,copy) NSString *ChangeMessageName;
@property (nonatomic,copy) NSString *PhoneNumber;
@end
