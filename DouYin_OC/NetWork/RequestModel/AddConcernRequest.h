//
//  AddConcernRequest.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/14.
//

#import "BaseRequest.h"

@interface AddConcernRequest : BaseRequest
@property (nonatomic,strong) NSString *MyID;
@property (nonatomic,strong) NSString *ConcernObjectID;
@end


